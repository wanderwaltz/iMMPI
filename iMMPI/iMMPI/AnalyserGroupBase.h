//
//  AnalyserGroupBase.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark AnalyserGroupBase interface

@interface AnalyserGroupBase : NSObject<AnalyserGroup>
@property (strong,   nonatomic) NSString  *name;
@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (id<AnalyserGroup>) subgroupAtIndex: (NSUInteger) index;

+ (id<AnalyserGroup>) parseGroupJSON: (NSDictionary *) json;

@end
