//
//  TestRecordData.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "JsonDataWrapper.h"

#pragma mark -
#pragma mark TestRecord interface

@interface TestRecord : JsonDataWrapper

@property (strong,   nonatomic) NSDate *testDate;
@property (readonly, nonatomic) NSUInteger numberOfStatementsAnswered;

- (BOOL) answerForStatementAtIndex: (NSUInteger) index;

@end
