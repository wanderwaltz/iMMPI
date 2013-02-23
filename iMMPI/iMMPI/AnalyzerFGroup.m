//
//  AnalyzerFGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerFGroup.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyAnswersPositive = @"answersPositive";
static NSString * const kJSONKeyAnswersNegative = @"answersNegative";

static NSString * const kJSONKeyMaleDeviation   = @"maleDeviation";
static NSString * const kJSONKeyFemaleDeviation = @"femaleDeviation";

static NSString * const kJSONKeyMaleMedian      = @"maleMedian";
static NSString * const kJSONKeyFemaleMedian    = @"femaleMedian";


#pragma mark -
#pragma mark Error message function declarations

static id _logMaleDeviationNotFound();
static id _logFemaleDeviationNotFound();
static id _logMaleMedianNotFound();
static id _logFemaleMedianNotFound();
static id _logExpectedFloat(NSString *key, id object);


#pragma mark -
#pragma mark AnalyzerFGroup private

@interface AnalyzerFGroup()
{
    NSArray *_positiveIndices;
    NSArray *_negativeIndices;
        
    double _medianMale;
    double _deviationMale;
    
    double _medianFemale;
    double _deviationFemale;
}

@end


#pragma mark -
#pragma mark AnalyzerFGroup implementation

@implementation AnalyzerFGroup

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *answersPositiveString = json[kJSONKeyAnswersPositive];
    NSString *answersNegativeString = json[kJSONKeyAnswersNegative];
    
    NSNumber *maleMedian      = json[kJSONKeyMaleMedian];
    NSNumber *maleDeviation   = json[kJSONKeyMaleDeviation];
    
    NSNumber *femaleMedian    = json[kJSONKeyFemaleMedian];
    NSNumber *femaleDeviation = json[kJSONKeyFemaleDeviation];
    
    if (maleMedian    == nil) return _logMaleMedianNotFound();
    if (maleDeviation == nil) return _logMaleDeviationNotFound();
    
    if (femaleMedian    == nil) return _logFemaleMedianNotFound();
    if (femaleDeviation == nil) return _logFemaleDeviationNotFound();
    
    if (![maleMedian isKindOfClass: [NSNumber class]])
        return _logExpectedFloat(kJSONKeyMaleMedian, maleMedian);
    
    if (![maleDeviation isKindOfClass: [NSNumber class]])
        return _logExpectedFloat(kJSONKeyMaleDeviation, maleDeviation);
    
    if (![femaleMedian isKindOfClass: [NSNumber class]])
        return _logExpectedFloat(kJSONKeyFemaleMedian, femaleMedian);
    
    if (![femaleDeviation isKindOfClass: [NSNumber class]])
        return _logExpectedFloat(kJSONKeyFemaleDeviation, femaleDeviation);
    
    
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _positiveIndices = [[answersPositiveString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
        _negativeIndices = [[answersNegativeString componentsSeparatedByString: @" "]
                            valueForKey: @"intValue"];
        
        _medianMale   = [maleMedian   doubleValue];
        _medianFemale = [femaleMedian doubleValue];
        
        _deviationMale   = [maleDeviation   doubleValue];
        _deviationFemale = [femaleDeviation doubleValue];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (NSString *) readableScore
{
    return [NSString stringWithFormat: @"%d", (NSInteger)self.score];
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?    _medianFemale :    _medianMale;
    double deviation = (record.person.gender == GenderFemale) ? _deviationFemale : _deviationMale;
    
    double score = round(50 + 10 * (matches-median)/deviation);
    self.score   = score;
    
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


#pragma mark -
#pragma mark Error messages

static id _logMaleDeviationNotFound()
{
    NSLog(@"Failed to parse F_SCALE group: '%@' not found.", kJSONKeyMaleDeviation);
    return nil;
}


static id _logFemaleDeviationNotFound()
{
    NSLog(@"Failed to parse F_SCALE group: '%@' not found.", kJSONKeyFemaleDeviation);
    return nil;
}


static id _logMaleMedianNotFound()
{
    NSLog(@"Failed to parse F_SCALE group: '%@' not found.", kJSONKeyMaleMedian);
    return nil;
}


static id _logFemaleMedianNotFound()
{
    NSLog(@"Failed to parse F_SCALE group: '%@' not found.", kJSONKeyFemaleMedian);
    return nil;
}


static id _logExpectedFloat(NSString *key, id object)
{
    NSLog(@"Failed to parse F_SCALE group: expected '%@' to be of floating-point value, got '%@' instead.", key, object);
    return nil;
}