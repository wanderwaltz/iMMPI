//
//  AnalyserKGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyserKGroup.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyCorrectionMultiplier = @"correctionMultiplier";


#pragma mark -
#pragma mark AnalyserKGroup private

@interface AnalyserKGroup()
{
    double _correctionMultiplier;
}

@end


#pragma mark -
#pragma mark AnalyserKGroup implementation

@implementation AnalyserKGroup

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _correctionMultiplier = [json[kJSONKeyCorrectionMultiplier] doubleValue];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyserGroup

- (double) computeScoreForRecord: (id<TestRecord>) record
                        analyser: (id<Analyser>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?
                        self.medianFemale : self.medianMale;
    
    double deviation = (record.person.gender == GenderFemale) ?
                        self.deviationFemale : self.deviationMale;
    
    id<AnalyserGroup> correctionGroup = [analyser firstGroupForType: kGroupType_Base_K];
    
    NSUInteger correctionMatches = [correctionGroup computeMatchesForRecord: record
                                                                   analyser: analyser];
    
    double score = round(50 + 10 * (matches+correctionMatches*_correctionMultiplier-median)/deviation);
    self.score   = score;
    
    return self.score;
}


@end
