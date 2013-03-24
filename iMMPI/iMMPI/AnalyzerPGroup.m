//
//  AnalyzerPGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerPGroup.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyAnswersPositive = @"answersPositive";
static NSString * const kJSONKeyAnswersNegative = @"answersNegative";

static NSString * const kJSONKeyMalePercent   = @"malePercent";
static NSString * const kJSONKeyFemalePercent = @"femalePercent";


#pragma mark -
#pragma mark Error message function declarations

static id _logNoAnswersFound();
static id _logMaleBracketNotFound();
static id _logFemaleBracketNotFound();
static id _logWrongNumberOfComponents(NSString *key, id object);


#pragma mark -
#pragma mark AnalyzerPGroup private

@interface AnalyzerPGroup()
{
    NSArray   *_maleBrackets;
    NSArray *_femaleBrackets;
    
    NSArray *_positiveIndices;
    NSArray *_negativeIndices;
}

@end


#pragma mark -
#pragma mark AnalyzerPGroup implementation

@implementation AnalyzerPGroup

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *answersPositiveString = json[kJSONKeyAnswersPositive];
    NSString *answersNegativeString = json[kJSONKeyAnswersNegative];
    
    NSString   *maleBracketString = json[kJSONKeyMalePercent];
    NSString *femaleBracketString = json[kJSONKeyFemalePercent];

    if (maleBracketString.length == 0)   return _logMaleBracketNotFound();
    if (femaleBracketString.length == 0) return _logFemaleBracketNotFound();
    
    NSArray *maleBracket = [[maleBracketString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
    NSArray *femaleBracket = [[femaleBracketString componentsSeparatedByString: @" "]
                              valueForKey: @"intValue"];
    
    if (maleBracket.count != 4)
        return _logWrongNumberOfComponents(kJSONKeyMalePercent, maleBracketString);
    
    if (femaleBracket.count != 4)
        return _logWrongNumberOfComponents(kJSONKeyFemalePercent, femaleBracketString);
    
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _positiveIndices = [[answersPositiveString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
        _negativeIndices = [[answersNegativeString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
        
        if (_positiveIndices.count + _negativeIndices.count == 0)
            return _logNoAnswersFound();
        
        _maleBrackets   = maleBracket;
        _femaleBrackets = femaleBracket;
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (NSArray *) positiveStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return _positiveIndices;
}


- (NSArray *) negativeStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return _negativeIndices;
}


- (BOOL) scoreIsWithinNorm
{
    return fabs(self.score - 3.0) < 0.05;
}


- (NSString *) readableScore
{
    return [NSString stringWithFormat: @"%.1lf", self.score];
}


- (NSArray *) bracketsForRecord: (id<TestRecordProtocol>) record
{
    NSArray *brackets = (record.person.gender == GenderFemale) ? _femaleBrackets : _maleBrackets;
    
    NSAssert(brackets.count == 4, @"");
    
    return brackets;
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger percentage = [self computePercentageForRecord: record
                                                    analyser: analyser];
    
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    if (percentage <= A)
        self.score = round(10 * 1.5 * (double)percentage / (double)A);
    
    else if (percentage <= B)
        self.score = round(10 * (1.5 + (double)(percentage-A) / (double)(B-A)));
    
    else if (percentage <= C)
        self.score = round(10 * (2.5 + (double)(percentage-B) / (double)(C-B)));
    
    else if (percentage <= D)
        self.score = round(10 * (3.5 + (double)(percentage-C) / (double)(D-C)));
    
    else
        self.score = round(10 * (4.5 + 0.5 * (double)(percentage-D) / (double)(100-D)));

    self.score /= 10.0;
    
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
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    NSUInteger total = (_positiveIndices.count + _negativeIndices.count);
    
    return matches * 100 / total;
}


@end


#pragma mark -
#pragma mark Error messages

static id _logNoAnswersFound()
{
    NSLog(@"Failed to parse P_SCALE group: no statement indices found.");
    return nil;
}


static id _logMaleBracketNotFound()
{
    NSLog(@"Failed to parse P_SCALE group: '%@' not found.", kJSONKeyMalePercent);
    return nil;
}


static id _logFemaleBracketNotFound()
{
    NSLog(@"Failed to parse P_SCALE group: '%@' not found.", kJSONKeyFemalePercent);
    return nil;
}


static id _logWrongNumberOfComponents(NSString *key, id object)
{
    NSLog(@"Failed to parse P_SCALE group: expected 4 integer components in '%@', got '%@' instead.", key, object);
    return nil;
}
