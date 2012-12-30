//
//  AnalyzerFGroupFM.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerFGroupFM.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyMaleAnswersPositive = @"maleAnswersPositive";
static NSString * const kJSONKeyMaleAnswersNegative = @"maleAnswersNegative";

static NSString * const kJSONKeyFemaleAnswersPositive = @"femaleAnswersPositive";
static NSString * const kJSONKeyFemaleAnswersNegative = @"femaleAnswersNegative";

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
#pragma mark AnalyzerFGroupFM private

@interface AnalyzerFGroupFM()
{
    NSArray *_malePositiveIndices;
    NSArray *_maleNegativeIndices;
    
    NSArray *_femalePositiveIndices;
    NSArray *_femaleNegativeIndices;
    
    double _medianMale;
    double _deviationMale;
    
    double _medianFemale;
    double _deviationFemale;
}

@end


#pragma mark -
#pragma mark AnalyzerFGroupFM implementation

@implementation AnalyzerFGroupFM

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *maleAnswersPositiveString = json[kJSONKeyMaleAnswersPositive];
    NSString *maleAnswersNegativeString = json[kJSONKeyMaleAnswersNegative];
    
    NSString *femaleAnswersPositiveString = json[kJSONKeyFemaleAnswersPositive];
    NSString *femaleAnswersNegativeString = json[kJSONKeyFemaleAnswersNegative];
    
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
        _malePositiveIndices = [[maleAnswersPositiveString componentsSeparatedByString: @" "]
                                valueForKey: @"intValue"];
        _maleNegativeIndices = [[maleAnswersNegativeString componentsSeparatedByString: @" "]
                                valueForKey: @"intValue"];
        
        _femalePositiveIndices = [[femaleAnswersPositiveString componentsSeparatedByString: @" "]
                                  valueForKey: @"intValue"];
        _femaleNegativeIndices = [[femaleAnswersNegativeString componentsSeparatedByString: @" "]
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

- (double) computeScoreForRecord: (id<TestRecord>) record
                        analyser: (id<Analyzer>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
   
    double median    = (record.person.gender == GenderFemale) ?    _medianFemale :    _medianMale;
    double deviation = (record.person.gender == GenderFemale) ? _deviationFemale : _deviationMale;
    
    double score = round(50 + 10 * (matches-median)/deviation);
    self.score   = score;
    
    return self.score;
}


- (NSUInteger) computeMatchesForRecord: (id<TestRecord>) record
                              analyser: (id<Analyzer>) analyser
{
    NSUInteger positiveMatches = 0;
    NSUInteger negativeMatches = 0;
    
    NSArray *positiveIndices =
    (record.person.gender == GenderFemale) ? _femalePositiveIndices : _malePositiveIndices;
    
    NSArray *negativeIndices =
    (record.person.gender == GenderFemale) ? _femaleNegativeIndices : _maleNegativeIndices;
    
    for (NSNumber *index in positiveIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypePositive) &&
            [analyser isValidStatementID: [index integerValue]]) positiveMatches++;
    }
    
    
    for (NSNumber *index in negativeIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypeNegative) &&
            [analyser isValidStatementID: [index integerValue]]) negativeMatches++;
    }
    
    return positiveMatches+negativeMatches;
}


- (NSUInteger) computePercentageForRecord: (id<TestRecord>) record
                                 analyser: (id<Analyzer>) analyser
{
    NSArray *positiveIndices =
    (record.person.gender == GenderFemale) ? _femalePositiveIndices : _malePositiveIndices;
    
    NSArray *negativeIndices =
    (record.person.gender == GenderFemale) ? _femaleNegativeIndices : _maleNegativeIndices;

    
    return [self computeMatchesForRecord: record
                                analyser: analyser] * 100 /
            (positiveIndices.count + negativeIndices.count);
}

@end


#pragma mark -
#pragma mark Error messages

static id _logMaleDeviationNotFound()
{
    NSLog(@"Failed to parse F_SCALE_FM group: '%@' not found.", kJSONKeyMaleDeviation);
    return nil;
}


static id _logFemaleDeviationNotFound()
{
    NSLog(@"Failed to parse F_SCALE_FM group: '%@' not found.", kJSONKeyFemaleDeviation);
    return nil;
}


static id _logMaleMedianNotFound()
{
    NSLog(@"Failed to parse F_SCALE_FM group: '%@' not found.", kJSONKeyMaleMedian);
    return nil;
}


static id _logFemaleMedianNotFound()
{
    NSLog(@"Failed to parse F_SCALE_FM group: '%@' not found.", kJSONKeyFemaleMedian);
    return nil;
}


static id _logExpectedFloat(NSString *key, id object)
{
    NSLog(@"Failed to parse F_SCALE_FM group: expected '%@' to be of floating-point value, got '%@' instead.", key, object);
    return nil;
}