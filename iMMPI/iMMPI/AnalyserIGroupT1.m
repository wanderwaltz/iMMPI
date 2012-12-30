//
//  AnalyserIGroupT1.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyserIGroupT1.h"


#pragma mark -
#pragma mark AnalyserIGroupT1 implementation

@implementation AnalyserIGroupT1

#pragma mark -
#pragma mark AnalyserGroup

- (double) computeScoreForRecord: (id<TestRecord>) record
                        analyser: (id<Analyser>) analyser
{
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    id<AnalyserGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyserGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    id<AnalyserGroup> IScale_97 = [analyser firstGroupForType: kGroupType_IScale_97];
    id<AnalyserGroup> IScale_98 = [analyser firstGroupForType: kGroupType_IScale_98];
    
    NSUInteger T_aer =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    if (T_aer > 0)
    {
        NSUInteger percentage = [self computePercentageForRecord: record
                                                        analyser: analyser];
        
        percentage = percentage * 100 / T_aer;
        
        if (percentage <= A)
            self.score = round(10 * 1.5 * percentage/A);
        
        else if (percentage <= B)
            self.score = round(10*(1.5+(percentage-A)/(B-A)));
        
        else if (percentage <= C)
            self.score = round(10*(2.5+(percentage-B)/(C-B)));
        
        else if (percentage <= D)
            self.score = round(10*(3.5+(percentage-C)/(D-C)));
        else
            self.score = 50;
    }
    else self.score = -1;
    
    return self.score;
}


@end
