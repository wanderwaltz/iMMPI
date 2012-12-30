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

@protocol Analyzer;

@protocol AnalyzerGroup <NSObject>
@required

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) double   score;

@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (id<AnalyzerGroup>) subgroupAtIndex: (NSUInteger) index;

- (void) visitSubgroupsDFS: (void(^)(id<AnalyzerGroup> subgroup)) block;

- (double) computeScoreForRecord: (id<TestRecord>) record analyser: (id<Analyzer>) analyser;

- (NSUInteger) computeMatchesForRecord: (id<TestRecord>) record
                              analyser: (id<Analyzer>) analyser;

- (NSUInteger) computePercentageForRecord: (id<TestRecord>) record
                                 analyser: (id<Analyzer>) analyser;

@end
