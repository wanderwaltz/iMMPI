//
//  TestGatherGroupRanges.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.05.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestGatherGroupRanges.h"
#import "AnalyzerFGroup.h"


#pragma mark -
#pragma mark TestGatherGroupRanges implementation

@implementation TestGatherGroupRanges

- (void) setUp
{
    _analyzer = [Analyzer new];
    [_analyzer loadGroups];
}


- (void) getMinScoreForGroup: (id<AnalyzerGroup>) group
                      gender: (Gender) gender
                    outScore: (double *) score
            outReadableScore: (__autoreleasing NSString **) readableScore
{
    id mock = [OCMockObject partialMockForObject: group];
    [[[mock stub] andReturnValue: OCMOCK_VALUE((NSUInteger){0})]
     computeMatchesForRecord: OCMOCK_ANY
                    analyser: OCMOCK_ANY];
    
    id person = [OCMockObject niceMockForClass: [Person class]];
    [[[person stub] andReturnValue: OCMOCK_VALUE((Gender){gender})] gender];
    
    id record = [OCMockObject niceMockForClass: [TestRecord class]];
    [[[record stub] andReturn: person] person];
    
    [mock computeScoreForRecord: record analyser: _analyzer];
    *score         = [mock score];
    *readableScore = [mock readableScore];
    [mock stopMocking];
}


- (void) getMaxScoreForGroup: (id<AnalyzerGroup>) group
                      gender: (Gender) gender
                    outScore: (double *) score
            outReadableScore: (__autoreleasing NSString **) readableScore
{
    NSUInteger maxMatches = [group totalNumberOfValidStatementIDsForRecord: nil
                                                                  analyser: _analyzer];
    
    id mock = [OCMockObject partialMockForObject: group];
    [[[mock stub] andReturnValue: OCMOCK_VALUE((NSUInteger){maxMatches})]
     computeMatchesForRecord: OCMOCK_ANY
                    analyser: OCMOCK_ANY];
    
    id person = [OCMockObject niceMockForClass: [Person class]];
    [[[person stub] andReturnValue: OCMOCK_VALUE((Gender){gender})] gender];
    
    id record = [OCMockObject niceMockForClass: [TestRecord class]];
    [[[record stub] andReturn: person] person];
    
    [mock computeScoreForRecord: record analyser: _analyzer];
    *score         = [mock score];
    *readableScore = [mock readableScore];
    [mock stopMocking];
}



- (NSString *) getRangeStringForGroup: (id<AnalyzerGroup>) group gender: (Gender) gender
{
    double minScore = 0.0;
    double maxScore = 0.0;
    
    NSString *minReadableScore = nil;
    NSString *maxReadableScore = nil;
    
    [self getMinScoreForGroup: group
                       gender: gender
                     outScore: &minScore
             outReadableScore: &minReadableScore];
    
    [self getMaxScoreForGroup: group
                       gender: gender
                     outScore: &maxScore
             outReadableScore: &maxReadableScore];
    
    NSString *genderString = nil;
    
    if (gender == GenderMale)   genderString = @"М";
    if (gender == GenderFemale) genderString = @"Ж";
    
    if (minReadableScore.length + maxReadableScore.length > 0)
    {
        if ((minScore < 0.0)   || (maxScore < 0.0)   ||
            (minScore > 100.0) || (maxScore > 100.0) ||
            (maxScore < minScore))
        {
            return [NSString stringWithFormat: @"(%@) %@: (%@, %@)",
                    genderString, [group name], minReadableScore, maxReadableScore];
        }
    }
    
    return nil;
}


- (void) test_gatherGroupRanges
{
    for (NSInteger i = 0; i < _analyzer.groupsCount; ++i)
    {
        id<AnalyzerGroup> group = [_analyzer groupAtIndex: i];
        
        NSString *maleRanges   = [self getRangeStringForGroup: group gender: GenderMale];
        NSString *femaleRanges = [self getRangeStringForGroup: group gender: GenderFemale];
        
        if (maleRanges != nil)
            GHTestLog(@"%@", maleRanges);
        
        if (femaleRanges != nil)
            GHTestLog(@"%@", femaleRanges);
    }
}

@end
