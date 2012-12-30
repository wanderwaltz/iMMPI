//
//  AnalyserGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark AnalyserGroup protocol

@protocol Analyser;

@protocol AnalyserGroup <NSObject>
@required

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) double   score;

@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (id<AnalyserGroup>) subgroupAtIndex: (NSUInteger) index;

- (void) visitSubgroupsDFS: (void(^)(id<AnalyserGroup> subgroup)) block;

- (double) computeScoreForRecord: (id<TestRecord>) record analyser: (id<Analyser>) analyser;

@end
