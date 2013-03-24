//
//  AnalyzerGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark AnalyzerGroup protocol

@protocol AnalyzerProtocol;

@protocol AnalyzerGroup <NSObject>
@required

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;

@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (NSString *) readableScore;

- (BOOL) scoreIsWithinNorm;


- (id<AnalyzerGroup>) subgroupAtIndex: (NSUInteger) index;


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser;

- (NSUInteger) computeMatchesForRecord: (id<TestRecordProtocol>) record
                              analyser: (id<AnalyzerProtocol>) analyser;

- (NSUInteger) computePercentageForRecord: (id<TestRecordProtocol>) record
                                 analyser: (id<AnalyzerProtocol>) analyser;

- (NSArray *) positiveStatementIDsForRecord: (id<TestRecordProtocol>) record;
- (NSArray *) negativeStatementIDsForRecord: (id<TestRecordProtocol>) record;

@end
