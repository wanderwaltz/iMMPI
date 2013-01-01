//
//  JSONTestRecordsStorage.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JSONTestRecordsStorage.h"
#import "JSONTestRecordStorageElement.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONPathExtension = @"json";
static NSString * const kJSONRecordsFolder = @"JSONRecords";


#pragma mark -
#pragma mark JSONTestRecordStorage private

@interface JSONTestRecordsStorage()
{
    NSMutableArray *_elements;
    
    NSString    *_storedRecordsPath;
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark JSONTestRecordsStorage implementation

@implementation JSONTestRecordsStorage

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *storedRecordsPath = [[directories lastObject] stringByAppendingPathComponent:
                                   kJSONRecordsFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: storedRecordsPath])
    {
        NSError *error = nil;
        
        BOOL created =
        [fileManager createDirectoryAtPath: storedRecordsPath
               withIntermediateDirectories: YES
                                attributes: nil
                                     error: &error];
        
        if (!created)
        {
            NSLog(@"Failed to create directory at path '%@' with error: %@",
                  storedRecordsPath, error);
            return nil;
        }
    }
    
    self = [super init];
    
    if (self != nil)
    {
        _elements = [NSMutableArray array];
        
        _storedRecordsPath = storedRecordsPath;
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark TestRecordStorage

- (BOOL) addNewTestRecord: (id<TestRecordProtocol>) testRecord
{
    BOOL didAdd = NO;
    
    JSONTestRecordStorageElement *element = [JSONTestRecordStorageElement new];
    element.record = testRecord;
    
    [_elements addObject: element];
    didAdd = [self storeElement: element];
    
    return didAdd;
}


- (BOOL) updateTestRecord: (id<TestRecordProtocol>) testRecord
{
    BOOL didUpdate = NO;
    
    JSONTestRecordStorageElement *element = [self elementForRecord: testRecord];
    
    if (element != nil)
    {
        didUpdate = [self storeElement: element];
    }
    
    return didUpdate;
}


- (BOOL) loadStoredTestRecords
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *subpaths = [fileManager subpathsAtPath: _storedRecordsPath];
    
    for (NSString *fileName in subpaths)
    {
        if ([[fileName pathExtension] isEqualToString: kJSONPathExtension])
        {
            NSString *path = [_storedRecordsPath stringByAppendingPathComponent: fileName];
            
            NSData *data = [NSData dataWithContentsOfFile: path];
            
            id<TestRecordProtocol> record = [JSONTestRecordSerialization testRecordFromData: data];
            
            if (record != nil)
            {
                JSONTestRecordStorageElement *element = [JSONTestRecordStorageElement new];
                element.record   = record;
                element.fileName = fileName;
                
                [_elements addObject: element];
            }
        }
    }
    
    return YES;
}


- (NSArray *) allTestRecords
{
    NSMutableArray *records = [NSMutableArray arrayWithCapacity: _elements.count];
    
    for (JSONTestRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONTestRecordStorageElement);
        if (element.record != nil)
            [records addObject: element.record];
    }
    
    return records;
}


- (BOOL) containsTestRecord: (id<TestRecordProtocol>) testRecord
{
    FRB_AssertNotNil(testRecord);
    
    for (JSONTestRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONTestRecordStorageElement);
        if (element.record == testRecord)
            return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark private

- (BOOL) storeElement: (JSONTestRecordStorageElement *) element
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


- (NSString *) fileNameForRecord: (id<TestRecordProtocol>) record
{
    NSString *candidate = [NSString stringWithFormat: @"%@ - %@",
                           record.person.name, [_dateFormatter stringFromDate: record.date]];
    
    NSCharacterSet *illegalFileNameCharacters =
    [NSCharacterSet characterSetWithCharactersInString: @"/\\?%*|\"<>$&@"];
    
    candidate = [[candidate componentsSeparatedByCharactersInSet: illegalFileNameCharacters]
                 componentsJoinedByString: @""];
    
    NSString *fileName  = [candidate stringByAppendingPathExtension: kJSONPathExtension];
    NSInteger attempts  = 0;
    
    while (![self fileNameIsAvailable: fileName])
    {
        attempts++;
        fileName = [[candidate stringByAppendingFormat: @" %d", attempts]
                    stringByAppendingPathExtension: kJSONPathExtension];
    }
    
    return fileName;
}


- (BOOL) fileNameIsAvailable: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fullPath = [_storedRecordsPath stringByAppendingPathComponent: fileName];
    
    return ![fileManager fileExistsAtPath: fullPath];
}


- (JSONTestRecordStorageElement *) elementForRecord: (id<TestRecordProtocol>) record
{
    JSONTestRecordStorageElement *found = nil;
    
    if (record != nil)
    {
        for (JSONTestRecordStorageElement *element in _elements)
        {
            if (element.record == record)
            {
                found = element;
                break;
            }
        }
    }
    
    return found;
}


@end
