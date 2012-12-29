//
//  JSONTestRecordsModel.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JSONTestRecordsModel.h"
#import "JSONTestRecordModelElement.h"


#pragma mark -
#pragma mark JSONTestRecordsModel private

@interface JSONTestRecordsModel()
{
    NSMutableArray *_elements;
    
    NSString    *_storedRecordsPath;
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark JSONTestRecordsModel implementation

@implementation JSONTestRecordsModel


#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _elements = [NSMutableArray array];
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        _storedRecordsPath = [directories lastObject];
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark MutableTableViewModel

- (NSUInteger) numberOfSections
{
    return 1;
}


- (NSUInteger) numberOfRowsInSection: (NSUInteger) section
{
    return _elements.count;
}


- (id<TestRecord>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    JSONTestRecordModelElement *element = _elements[indexPath.row];
    FRB_AssertClass(element, JSONTestRecordModelElement);
    
    return element.record;
}


- (BOOL) addNewObject: (id<TestRecord>) record
{
    BOOL didAdd = NO;
    
    JSONTestRecordModelElement *element = [JSONTestRecordModelElement new];
    element.record = record;
    
    [_elements addObject: element];
    didAdd = [self storeElement: element];
    
    return didAdd;
}


- (BOOL) updateObject: (id<TestRecord>) record
{
    BOOL didUpdate = NO;
    
    JSONTestRecordModelElement *element = [self elementForRecord: record];
    
    if (element != nil)
    {
        didUpdate = [self storeElement: element];
    }
    
    return didUpdate;
}


#pragma mark -
#pragma mark private: records persistent storage

- (BOOL) storeElement: (JSONTestRecordModelElement *) element
{
    BOOL didStore = NO;
    
    if (element.record)
    {
        NSData *jsonData = [JSONTestRecordSerialization dataWithTestRecord: element.record];
        
        if (jsonData)
        {
            NSString *fileName = element.fileName;
            
            if (fileName == nil)
            {
                fileName = [self fileNameForRecord: element.record];
                element.fileName = fileName;
            }
            
            NSString *path = [_storedRecordsPath stringByAppendingPathComponent: fileName];
            
            didStore = [jsonData writeToFile: path atomically: YES];
        }
    }
    
    return didStore;
}


- (NSString *) fileNameForRecord: (id<TestRecord>) record
{
    NSString *candidate = [NSString stringWithFormat: @"%@ - %@",
                           record.person.name, [_dateFormatter stringFromDate: record.date]];
    NSString *extension = @"json";
    NSString *fileName  = [candidate stringByAppendingPathExtension: extension];
    NSInteger attempts  = 0;
    
    while (![self fileNameIsAvailable: fileName])
    {
        attempts++;
        fileName = [[candidate stringByAppendingFormat: @" %d", attempts]
                    stringByAppendingPathExtension: extension];
    }
    
    return fileName;
}


- (BOOL) fileNameIsAvailable: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fullPath = [_storedRecordsPath stringByAppendingPathComponent: fileName];
    
    return ![fileManager fileExistsAtPath: fullPath];
}


- (JSONTestRecordModelElement *) elementForRecord: (id<TestRecord>) record
{
    for (JSONTestRecordModelElement *element in _elements)
    {
        if (element.record == record)
        {
            return element;
        }
    }
    
    return nil;
}

@end
