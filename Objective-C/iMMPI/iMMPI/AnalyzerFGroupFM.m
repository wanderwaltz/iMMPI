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
        _malePositiveIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: maleAnswersPositiveString];
        _maleNegativeIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: maleAnswersNegativeString];
        
        _femalePositiveIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: femaleAnswersPositiveString];
        _femaleNegativeIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: femaleAnswersNegativeString];
        
        _medianMale   = [maleMedian   doubleValue];
        _medianFemale = [femaleMedian doubleValue];
        
        _deviationMale   = [maleDeviation   doubleValue];
        _deviationFemale = [femaleDeviation doubleValue];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (BOOL) canProvideDetailedInfo
{
    return YES;
}


- (NSString *) htmlDetailedInfoForRecord: (id<TestRecordProtocol>) record
                                analyser: (id<AnalyzerProtocol>) analyser
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    
    [html appendString: @"<table width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\"35%\">"];
    [html appendString: @"<col width=\"65%\">"];
    [html appendString: @"</colgroup>"];
    
    void (^addRow)(NSString *left,
                   NSString *right) =
    ^(NSString *left,
      NSString *right)
    {
        [html appendString: @"<tr>"];
        
        [html appendFormat: @"<td colspan=\"1\">%@</td>", left];
        [html appendFormat: @"<td colspan=\"1\">%@</td>", right];
        
        [html appendString: @"</tr>"];
    };
    
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?    _medianFemale :    _medianMale;
    double deviation = (record.person.gender == GenderFemale) ? _deviationFemale : _deviationMale;
    
    double score = 50 + 10 * (matches-median)/deviation;
    
    addRow(___Details_Score,            self.readableScore);
    addRow(___Details_Matches,          [NSString stringWithFormat: @"%d", matches]);
    addRow(___Details_Median_Male,      [NSString stringWithFormat: @"%.2lf", _medianMale]);
    addRow(___Details_Deviation_Male,   [NSString stringWithFormat: @"%.2lf", _deviationMale]);
    addRow(___Details_Median_Female,    [NSString stringWithFormat: @"%.2lf", _medianFemale]);
    addRow(___Details_Deviation_Female, [NSString stringWithFormat: @"%.2lf", _deviationFemale]);
    addRow(___Details_Computation,
           [NSString stringWithFormat: @"(50 + 10 * (%d - %.2lf)/%.2lf) = %.2lf",
            matches, median, deviation, score]);
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (NSArray *) positiveStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return (record.person.gender == GenderFemale) ? _femalePositiveIndices : _malePositiveIndices;
}


- (NSArray *) negativeStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return (record.person.gender == GenderFemale) ? _femaleNegativeIndices : _maleNegativeIndices;
}


- (BOOL) scoreIsWithinNorm
{
    return (40.0 <= self.score) && (self.score <= 60.0);
}


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


- (NSUInteger) computePercentageForRecord: (id<TestRecordProtocol>) record
                                 analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger total = [self totalNumberOfValidStatementIDsForRecord: record
                                                            analyser: analyser];

    if (total > 0)
    {
        return [self computeMatchesForRecord: record
                                    analyser: analyser] * 100 / total;
    }
    else return 0;
}


- (NSUInteger) totalNumberOfValidStatementIDsForRecord: (id<TestRecordProtocol>) record
                                              analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger count = 0;
    
    NSArray *positiveIndices =
    (record.person.gender == GenderFemale) ? _femalePositiveIndices : _malePositiveIndices;
    
    NSArray *negativeIndices =
    (record.person.gender == GenderFemale) ? _femaleNegativeIndices : _maleNegativeIndices;

    
    for (NSNumber *statementID in positiveIndices)
    {
        FRB_AssertClass(statementID, NSNumber);
        if ([analyser isValidStatementID: [statementID unsignedIntegerValue]])
            count++;
    }
    
    
    for (NSNumber *statementID in negativeIndices)
    {
        FRB_AssertClass(statementID, NSNumber);
        if ([analyser isValidStatementID: [statementID unsignedIntegerValue]])
            count++;
    }
    
    return count;
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