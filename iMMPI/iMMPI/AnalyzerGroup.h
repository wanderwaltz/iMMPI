//
//  AnalyzerGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark AnalyzerGroup protocol

@protocol AnalyzerProtocol;
@protocol TestRecordProtocol;

@protocol AnalyzerGroup<NSObject>
@required

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;

@property (readonly, nonatomic) NSInteger subgroupsCount;

- (NSString *)readableScore;

- (BOOL)scoreIsWithinNorm;
- (BOOL)canProvideDetailedInfo;

- (NSInteger)indexForRecord:(id<TestRecordProtocol>)record;

- (NSString *)htmlDetailedInfoForRecord:(id<TestRecordProtocol>)record
                               analyser:(id<AnalyzerProtocol>)analyser;


- (id<AnalyzerGroup>)subgroupAtIndex:(NSInteger)index;


- (double)computeScoreForRecord:(id<TestRecordProtocol>)record
                       analyser:(id<AnalyzerProtocol>)analyser;

- (NSInteger)computeMatchesForRecord:(id<TestRecordProtocol>)record
                            analyser:(id<AnalyzerProtocol>)analyser;

- (NSInteger)computePercentageForRecord:(id<TestRecordProtocol>)record
                                 analyser:(id<AnalyzerProtocol>)analyser;

- (NSInteger)totalNumberOfValidStatementIDsForRecord:(id<TestRecordProtocol>)record
                                            analyser:(id<AnalyzerProtocol>)analyser;

- (NSArray<NSNumber *> *)positiveStatementIDsForRecord:(id<TestRecordProtocol>)record;
- (NSArray<NSNumber *> *)negativeStatementIDsForRecord:(id<TestRecordProtocol>)record;

@end

NS_ASSUME_NONNULL_END
