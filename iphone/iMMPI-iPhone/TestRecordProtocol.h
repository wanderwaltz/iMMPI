//
//  TestRecordProtocol.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 5/24/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#pragma mark -
#pragma mark TestRecordProtocol protocol

@protocol TestRecordProtocol <NSObject>

@property (strong,   nonatomic) NSDate *testDate;
@property (readonly, nonatomic) NSUInteger numberOfStatementsAnswered;

- (BOOL) answerForStatementAtIndex: (NSUInteger) index;

@end
