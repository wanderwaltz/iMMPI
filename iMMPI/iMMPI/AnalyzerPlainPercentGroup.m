//
//  AnalyzerPlainPercentGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerPlainPercentGroup.h"


#pragma mark -
#pragma mark AnalyzerPlainPercentGroup implementation

@implementation AnalyzerPlainPercentGroup

- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger percentage = [self computePercentageForRecord: record
                                                    analyser: analyser];
    
    self.score =  percentage / 100.0;
    
    return self.score;
}

@end
