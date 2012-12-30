//
//  Analyser.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Analyser interface

@interface Analyser : NSObject

@property (readonly, nonatomic) NSUInteger groupsCount;

- (id<AnalyserGroup>) groupAtIndex: (NSUInteger) index;
- (NSUInteger) depthOfGroupAtIndex: (NSUInteger) index;

- (BOOL) loadGroups;

@end
