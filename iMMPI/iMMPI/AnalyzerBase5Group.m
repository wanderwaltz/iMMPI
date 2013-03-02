//
//  AnalyzerBase5Group.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerBase5Group.h"


#pragma mark -
#pragma mark AnalyzerBase5Group implementation

@implementation AnalyzerBase5Group

#pragma mark -
#pragma mark AnalyzerGroup

- (BOOL) scoreIsWithinNorm
{
    return (40.0 <= self.score) && (self.score <= 60.0);
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?    self.medianFemale :    self.medianMale;
    double deviation = (record.person.gender == GenderFemale) ? self.deviationFemale : self.deviationMale;
    
    double delta = matches-median;
    
    if (record.person.gender == GenderFemale) delta = -delta;
    
    double score = round(50 + 10 * delta/deviation);
    self.score   = score;
    
    return self.score;
}

@end
