//
//  AnalyzerGroupBase.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark AnalyzerGroupBase interface

@interface AnalyzerGroupBase : NSObject<AnalyzerGroup>
@property (strong,   nonatomic) NSString  *name;
@property (strong,   nonatomic) NSString  *type;
@property (assign,   nonatomic) double     score;
@property (readonly, nonatomic) NSUInteger subgroupsCount;

- (id) initWithJSON: (NSDictionary *) json;

- (id<AnalyzerGroup>) subgroupAtIndex: (NSUInteger) index;

- (NSUInteger) computeMatchesForRecord: (id<TestRecord>) record
                              analyser: (id<Analyzer>) analyser;


+ (id<AnalyzerGroup>) parseGroupJSON: (NSDictionary *) json;

@end
