//
//  JSONTestRecordProxy.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 13/02/14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JSONTestRecordProxy.h"
#import "JSONTestRecordSerialization.h"


#pragma mark -
#pragma mark JSONTestRecordProxy private

@interface JSONTestRecordProxy()
{
@private
    id<TestRecordProtocol> _record;
}

@end


#pragma mark -
#pragma mark JSONTestRecordProxy implementation

@implementation JSONTestRecordProxy

#pragma mark -
#pragma mark properties

- (id<PersonProtocol>) person
{
    [self loadRecordIfNeeded];
    return _record.person;
}


- (void) setPerson:(id<PersonProtocol>)person
{
    [self loadRecordIfNeeded];
    _record.person = person;
}


- (id<TestAnswersProtocol>) testAnswers
{
    [self loadRecordIfNeeded];
    return _record.testAnswers;
}


- (void) setTestAnswers: (id<TestAnswersProtocol>) testAnswers
{
    [self loadRecordIfNeeded];
    _record.testAnswers = testAnswers;
}


- (NSString *) personName
{
    if (_record != nil)
    {
        return _record.person.name;
    }
    else
    {
        return _personName;
    }
}


- (NSDate *) date
{
    if (_record != nil)
    {
        return _record.date;
    }
    else if (_date != nil)
    {
        return _date;
    }
    else
    {
        [self loadRecordIfNeeded];
        return _record.date;
    }
}


#pragma mark -
#pragma mark methods

+ (id) proxyForRecord: (id<TestRecordProtocol>) record
         withFileName: (NSString *) fileName
          inDirectory: (NSString *) directory
{
    return [[[self class] alloc] initWithRecord: record
                                   withFileName: fileName
                                    inDirectory: directory];
}


#pragma mark -
#pragma mark initialization

- (id) initWithRecord: (id<TestRecordProtocol>) record
         withFileName: (NSString *) fileName
          inDirectory: (NSString *) directory
{
    self = [super init];
    
    if (self != nil)
    {
        _fileName   = [fileName  copy];
        _directory  = [directory copy];
        _personName = record.person.name;
        _date       = record.date;
        _record     = record;
    }
    return self;
}


#pragma mark -
#pragma mark private

- (void) loadRecordIfNeeded
{
    if (_record == nil)
    {
        NSLog(@"Proxy loading record for %@", _personName);
        
        NSArray  *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *storedRecordsPath = [[directories lastObject] stringByAppendingPathComponent:
                                       _directory];
        
        NSString *recordPath = [storedRecordsPath stringByAppendingPathComponent: _fileName];
        NSData   *recordData = [NSData dataWithContentsOfFile: recordPath];
        
        _record = [JSONTestRecordSerialization testRecordFromData: recordData];
    }
}


#pragma mark -
#pragma mark debugging

- (NSString *) debugDescription
{
    return [NSString stringWithFormat:
            @"%@: %@ (%@)", [super debugDescription], _personName, _date];
}

@end
