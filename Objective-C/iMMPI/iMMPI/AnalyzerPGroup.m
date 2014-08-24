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
        _positiveIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: answersPositiveString];
        _negativeIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: answersNegativeString];
        
        if (_positiveIndices.count + _negativeIndices.count == 0)
            return _logNoAnswersFound();
        
        _maleBrackets   = maleBracket;
        _femaleBrackets = femaleBracket;
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
    
    NSUInteger percentage = [self computePercentageForRecord: record
                                                    analyser: analyser];
    
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    
    addRow(___Details_Score,            self.readableScore);
    addRow(___Details_Matches,          [NSString stringWithFormat: @"%ld", (long)matches]);
    addRow(___Details_Matches_Percent,  [NSString stringWithFormat: @"%ld%%", (long)percentage]);
    addRow(___Details_Brackets,         [NSString stringWithFormat: @"%ld < %ld < %ld < %ld", (long)A, (long)B, (long)C, (long)D]);

    if (percentage <= A)
    {
        double score = 1.5 * (double)percentage / (double)A;
        
        addRow(___Details_Computation,
               [NSString stringWithFormat:
                @"%ld <= %ld; 1.5 * %ld / %ld = %.2lf",
               (long)percentage, (long)A, (long)percentage, (long)A, score]);
    }
    else if (percentage <= B)
    {
        double score = (1.5 + (double)(percentage-A) / (double)(B-A));
        
        addRow(___Details_Computation,
               [NSString stringWithFormat:
                @"%ld < %ld <= %ld; 1.5 + (%ld-%ld) / (%ld-%ld) = %.2lf",
                (long)A, (long)percentage, (long)B, (long)percentage, (long)A, (long)B, (long)A, score]);
    }
    else if (percentage <= C)
    {
        double score = (2.5 + (double)(percentage-B) / (double)(C-B));
        
        addRow(___Details_Computation,
               [NSString stringWithFormat:
                @"%ld < %ld <= %ld; 2.5 + (%ld-%ld) / (%ld-%ld) = %.2lf",
                (long)B, (long)percentage, (long)C, (long)percentage, (long)B, (long)C, (long)B, score]);
    }
    else if (percentage <= D)
    {
        double score = (3.5 + (double)(percentage-C) / (double)(D-C));
        
        addRow(___Details_Computation,
               [NSString stringWithFormat:
                @"%ld < %ld <= %ld; 3.5 + (%ld-%ld) / (%ld-%ld) = %.2lf",
                (long)C, (long)percentage, (long)D, (long)percentage, (long)C, (long)D, (long)C, score]);
    }
    else
    {
        double score = (4.5 + 0.5 * (double)(percentage-D) / (double)(100-D));
        
        addRow(___Details_Computation,
               [NSString stringWithFormat:
                @"%ld < %ld; 4.5 * 0.5 + (%ld-%ld) / (100-%ld) = %.2lf",
                (long)D, (long)percentage, (long)percentage, (long)D, (long)D, score]);
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


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
    
    NSUInteger total = [self totalNumberOfValidStatementIDsForRecord: record
                                                            analyser: analyser];
    
    if (total > 0)
    {
        return matches * 100 / total;
    }
    else return 0;
}


- (NSUInteger) totalNumberOfValidStatementIDsForRecord: (id<TestRecordProtocol>) record
                                              analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger count = 0;
    
    for (NSNumber *statementID in _positiveIndices)
    {
        FRB_AssertClass(statementID, NSNumber);
        if ([analyser isValidStatementID: [statementID unsignedIntegerValue]])
            count++;
    }
    
    
    for (NSNumber *statementID in _negativeIndices)
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
