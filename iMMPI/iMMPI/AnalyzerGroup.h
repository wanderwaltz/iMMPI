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

@protocol AnalyserGroup <NSObject>
@property (strong, nonatomic) NSString *name;

@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (id<AnalyserGroup>) subgroupAtIndex: (NSUInteger) index;

- (void) visitSubgroupsDFS: (void(^)(id<AnalyserGroup> subgroup)) block;

@end
