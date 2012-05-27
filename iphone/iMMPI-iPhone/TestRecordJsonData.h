//
//  TestRecordData.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "TestRecordProtocol.h"
#import "JsonDataWrapper.h"

#pragma mark -
#pragma mark TestRecordJsonData interface

@interface TestRecordJsonData : JsonDataWrapper<TestRecordProtocol>

@property (strong,   nonatomic) NSDate *testDate;
@property (readonly, nonatomic) NSUInteger numberOfStatementsAnswered;

- (BOOL) answerForStatementAtIndex: (NSUInteger) index;

@end
