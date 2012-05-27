//
//  TestRecordData.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecordJsonData.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kTestDateKey           = @"Test Date";
static NSString * const kNumberOfStatementsKey = @"Statements Answered";
static NSString * const kAnswersKey            = @"Answers";

#pragma mark -
#pragma mark TestRecordJsonData implementation

@implementation TestRecordJsonData

- (NSDate *) testDate
{
    return [_jsonData dateForKey: kTestDateKey];
}


- (void) setTestDate: (NSDate *) testDate
{
    [_jsonData setDate: testDate 
                forKey: kTestDateKey];
}


- (NSUInteger) numberOfStatementsAnswered
{
    return [_jsonData unsignedForKey: kNumberOfStatementsKey];
}


- (BOOL) answerForStatementAtIndex: (NSUInteger) index
{
    NSArray *array = [_jsonData arrayForKey: kAnswersKey];
    
    return [[array objectAtIndex: index] boolValue];
}

@end
