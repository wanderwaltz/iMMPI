//
//  TestRecordDocument.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "MMPIDocument.h"
#import "DataStorage.h"
#import "Person.h"
#import "PersonIndexRecord.h"

#pragma mark -
#pragma mark Constants

NSString * const kTestRecordDocumentExtension = @"mmpi";


#pragma mark -
#pragma mark Static constants

static NSString * const kPersonRecordFileName      = @"person.json";
static NSString * const kPersonIndexRecordFileName = @"person-index.json";

#pragma mark -
#pragma mark TestRecordDocument implementation

@implementation MMPIDocument

#pragma mark -
#pragma mark Properties

@synthesize person            =            _person;
@synthesize personIndexRecord = _personIndexRecord;

- (void) setPerson: (Person *) person
{
    [[self.undoManager prepareWithInvocationTarget: self] setPerson: _person];
    
    _person = person;
    _personIndexRecord = [DataStorage createIndexRecordForPerson: person];
}


- (PersonIndexRecord *) personIndexRecord 
{    
    if (_personIndexRecord == nil) 
    {
        if (_fileWrapper != nil) 
        {
            _personIndexRecord = [self decodeObjectOfClass: [PersonIndexRecord class]     
                                     withPreferredFilename: kPersonIndexRecordFileName];
        } 
    }
    
    return _personIndexRecord;
}


- (Person *) person
{    
    if (_person == nil) 
    {
        if (_fileWrapper != nil) 
        {
            _person = [self decodeObjectOfClass: [Person class]
                          withPreferredFilename: kPersonRecordFileName];
        } 
    }    
    
    return _person;
}


#pragma mark -
#pragma mark UIDocument

- (void) encodeObject: (id<Serializable>) object 
           toWrappers: (NSMutableDictionary *) wrappers 
    preferredFilename: (NSString *) preferredFilename 
{
    @autoreleasepool
    {
        NSData        *data    = [object serialize];
        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents: data];
        
        [wrappers setObject: wrapper forKey: preferredFilename];
    }
}


- (id) contentsForType: (NSString *) typeName 
                 error: (NSError *__autoreleasing *) outError 
{    
    NSMutableDictionary *wrappers = [NSMutableDictionary dictionary];
    
    if (_person != nil)
        [self encodeObject: _person 
                toWrappers: wrappers
         preferredFilename: kPersonRecordFileName];
    
    if (_personIndexRecord != nil)
        [self encodeObject: _personIndexRecord 
                toWrappers: wrappers 
         preferredFilename: kPersonIndexRecordFileName];   
    
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc]
                                  initDirectoryWithFileWrappers: wrappers];
    
    return fileWrapper;
    
}


- (BOOL) loadFromContents: (id) contents 
                   ofType: (NSString *) typeName
                    error: (NSError *__autoreleasing *) outError 
{
    _fileWrapper = (NSFileWrapper *)contents;    
    
    _person            = nil;
    _personIndexRecord = nil;
    
    return YES;
    
}


#pragma mark -
#pragma mark File I/O

- (id) decodeObjectOfClass: (Class) class 
     withPreferredFilename: (NSString *) preferredFilename 
{
    NSFileWrapper *wrapper = [_fileWrapper.fileWrappers objectForKey: preferredFilename];
    
    if (wrapper == nil) 
    {
        return nil;
    }
    
    NSData *data = [wrapper regularFileContents];    
    
    return [[class alloc] initWithData: data];    
}



@end
