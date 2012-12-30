//
//  AnalyzerIGroupX.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroupX.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyAnswersPositive = @"answersPositive";
static NSString * const kJSONKeyAnswersNegative = @"answersNegative";


#pragma mark -
#pragma mark AnalyzerIGroupX private

@interface AnalyzerIGroupX()
{
    NSArray *_positiveIndices;
    NSArray *_negativeIndices;
}

@end


#pragma mark -
#pragma mark AnalyzerIGroupX implementation

@implementation AnalyzerIGroupX

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *answersPositiveString = json[kJSONKeyAnswersPositive];
    NSString *answersNegativeString = json[kJSONKeyAnswersNegative];
    
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _positiveIndices = [[answersPositiveString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
        _negativeIndices = [[answersNegativeString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

/* This is one ugly piece of code translated directly from Pascal.
 
 I've written it a couple of years ago and actually have no clue what exactly does it do. I guess I'll have to rewrite it from scratch some time later when I'll get the original book with formulae of computing these values.
 */
- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSInteger X = 0;
    NSInteger T_aer = 0;
    NSInteger FE99 = 0;
    
    NSInteger FE[3] = {0, 0, 0};
    NSInteger Delta[3] = {0, 0, 0};
    
    NSInteger MaxD  = 0;
    NSInteger MaxDV = 0;
    
    NSInteger Res[3] = {0, 0, 0};
    
    NSInteger I = 0;
    
    NSInteger SecD  = 0;
    NSInteger SecDV = 0;
    
    NSInteger Used = 0;
    
    NSInteger DS[3][2] = { {0, 1}, {0,2}, {1,2} };
    
    
    id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    id<AnalyzerGroup> IScale_97 = [analyser firstGroupForType: kGroupType_IScale_97];
    id<AnalyzerGroup> IScale_98 = [analyser firstGroupForType: kGroupType_IScale_98];
    
    id<AnalyzerGroup> IScale_100 = [analyser firstGroupForType: kGroupType_IScale_100];
    id<AnalyzerGroup> IScale_101 = [analyser firstGroupForType: kGroupType_IScale_101];
    id<AnalyzerGroup> IScale_102 = [analyser firstGroupForType: kGroupType_IScale_102];
    
    T_aer =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    if (T_aer == 0)
    {
        self.score = -1;
        return self.score;
    }
    
    FE99 =
    ([IScale_95 computePercentageForRecord: record analyser: analyser] +
     [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / T_aer;
    
    X =
    [IScale_100 computePercentageForRecord: record analyser: analyser] +
    [IScale_101 computePercentageForRecord: record analyser: analyser] +
    [IScale_102 computePercentageForRecord: record analyser: analyser];
    
    if (X == 0)
    {
        self.score = -1;
        return self.score;
    }
    
    FE[0] = round([IScale_100 computePercentageForRecord: record
                                                analyser: analyser] * FE99 / X);
    FE[1] = round([IScale_101 computePercentageForRecord: record
                                                analyser: analyser] * FE99 / X);
    FE[2] = round([IScale_102 computePercentageForRecord: record
                                                analyser: analyser] * FE99 / X);
    
    Delta[0] = abs(FE[0]-FE[1]);
    Delta[1] = abs(FE[0]-FE[2]);
    Delta[2] = abs(FE[1]-FE[2]);
    
    for (I = 0; I <= 2; ++I)
    {
        if (Delta[I] > MaxDV)
        {
            MaxD  = I;
            MaxDV = Delta[I];
        }
    }
    
    if (MaxDV > 4)
    {
        if (FE[DS[MaxD][0]] >= FE[DS[MaxD][1]])
        {
            Res[DS[MaxD][0]] = 50;
            Used = DS[MaxD][0];
        }
        else
        {
            Res[DS[MaxD][1]] = 50;
            Used = DS[MaxD][1];
        }
    }
    else if (MaxDV >= 2)
    {
        if (FE[DS[MaxD][0]] >= FE[DS[MaxD][1]])
        {
            Res[DS[MaxD][0]] = 40;
            Used = DS[MaxD][0];
        }
        else
        {
            Res[DS[MaxD][1]] = 40;
            Used = DS[MaxD][1];
        }
    }
    else
    {
        self.score = 30;
        return self.score;
    }
    
    switch (Used)
    {
        case 0: SecD = 2; break;
        case 1: SecD = 1; break;
        case 2: SecD = 0; break;
            
        default: SecD = -1; break;
    }
    
    if (SecD < 0)
    {
        self.score = -1;
        return self.score;
    }
    
    SecDV = Delta[SecD];
    
    if (SecDV > 4)
    {
        if (FE[DS[SecD][0]] > FE[DS[SecD][1]])
        {
            Res[DS[SecD][0]] = 50;
            Res[DS[SecD][1]] = 30;
        }
        else
        {
            Res[DS[SecD][0]] = 30;
            Res[DS[SecD][1]] = 50;
        }
    }
    else if (SecDV >= 2)
    {
        if (FE[DS[SecD][0]] > FE[DS[SecD][1]])
        {
            Res[DS[SecD][0]] = 40;
            Res[DS[SecD][1]] = 30;
        }
        else
        {
            Res[DS[SecD][0]] = 30;
            Res[DS[SecD][1]] = 40;
        }
    }
    else
    {
        Res[DS[SecD][0]] = 30;
        Res[DS[SecD][1]] = 30;
    }
    
    if ([self.type isEqualToString: kGroupType_IScale_100])
    {
        self.score = Res[0];
    }
    else if ([self.type isEqualToString: kGroupType_IScale_101])
    {
        self.score = Res[1];
    }
    else if ([self.type isEqualToString: kGroupType_IScale_102])
    {
        self.score = Res[2];
    }
    else
        self.score = -1;
    
    return self.score;
}


- (NSUInteger) computeMatchesForRecord: (id<TestRecordProtocol>) record
                              analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger positiveMatches = 0;
    NSUInteger negativeMatches = 0;
    
    for (NSNumber *index in _positiveIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypePositive) &&
            [analyser isValidStatementID: [index integerValue]]) positiveMatches++;
    }
    
    
    for (NSNumber *index in _negativeIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypeNegative) &&
            [analyser isValidStatementID: [index integerValue]]) negativeMatches++;
    }
    
    return positiveMatches+negativeMatches;
}


- (NSUInteger) computePercentageForRecord: (id<TestRecordProtocol>) record
                                 analyser: (id<AnalyzerProtocol>) analyser
{
    return [self computeMatchesForRecord: record
                                analyser: analyser] * 100 /
    (_positiveIndices.count + _negativeIndices.count);
}

@end
