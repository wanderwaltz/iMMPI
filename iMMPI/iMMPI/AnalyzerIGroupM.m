//
//  AnalyzerIGroupM.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroupM.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyPercent    = @"percent";
static NSString * const kJSONKeyMultiplier = @"multiplier";


#pragma mark -
#pragma mark Error message function declarations

static id _logBracketNotFound();
static id _logWrongNumberOfComponents(NSString *key, id object);
static id _logMultiplierNotFound();


#pragma mark -
#pragma mark AnalyzerIGroupM private

@interface AnalyzerIGroupM()
{
    NSArray  *_brackets;
    NSString *_multiplierType;
}

@end


#pragma mark -
#pragma mark AnalyzerIGroupM implementation

@implementation AnalyzerIGroupM

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *bracketString = json[kJSONKeyPercent];
    
    if (bracketString.length == 0)   return _logBracketNotFound();
    
    NSArray *bracket = [[bracketString componentsSeparatedByString: @" "]
                        valueForKey: @"intValue"];
    
    if (bracket.count != 4)
        return _logWrongNumberOfComponents(kJSONKeyPercent, bracketString);
    
    NSString *multiplier = json[kJSONKeyMultiplier];
    
    if (multiplier.length == 0) return _logMultiplierNotFound();
    
    self = [super init];
    
    if (self != nil)
    {
        _brackets       = bracket;
        _multiplierType = multiplier;
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

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
    
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    id<AnalyzerGroup> IScale_97 = [analyser firstGroupForType: kGroupType_IScale_97];
    id<AnalyzerGroup> IScale_98 = [analyser firstGroupForType: kGroupType_IScale_98];
    
    NSUInteger TaerSum =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    
    addRow(___Details_Score,            self.readableScore);
    addRow(___Details_Brackets,         [NSString stringWithFormat: @"%ld < %ld < %ld < %ld", (long)A, (long)B, (long)C, (long)D]);
    addRow(___Details_Taer_Sum,         [NSString stringWithFormat: @"%ld", (long)TaerSum]);
    
    if (TaerSum > 0)
    {
        NSUInteger percentage = 0;
        
        if ([_multiplierType isEqualToString: kGroupType_IScale_99])
        {
            NSUInteger percentage95 = [IScale_95 computePercentageForRecord: record analyser: analyser];
            NSUInteger percentage96 = [IScale_96 computePercentageForRecord: record analyser: analyser];
            
            addRow(___Details_Matches_IScale_95, [NSString stringWithFormat: @"%ld%%", (long)percentage95]);
            addRow(___Details_Matches_IScale_96, [NSString stringWithFormat: @"%ld%%", (long)percentage96]);
            
            percentage =
            ([IScale_95 computePercentageForRecord: record analyser: analyser] +
             [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / TaerSum;
            
            addRow(___Details_Percentage_Taer_Sum,
                   [NSString stringWithFormat: @"(%ld + %ld) * 100 / %ld = %ld",
                    (long)percentage95, (long)percentage96, (long)TaerSum, (long)percentage]);
        }
        else
        {
            NSUInteger percentage95 = [IScale_95 computePercentageForRecord: record analyser: analyser];
            
            addRow(___Details_Matches_IScale_95, [NSString stringWithFormat: @"%ld%%", (long)percentage95]);
            
            percentage =
            [IScale_95 computePercentageForRecord: record analyser: analyser] * 100 / TaerSum;
            
            addRow(___Details_Percentage_Taer_Sum,
                   [NSString stringWithFormat: @"%ld * 100 / %ld = %ld",
                    (long)percentage95, (long)TaerSum, (long)percentage]);
        }
        
        NSUInteger oldPercentage = percentage;
        NSUInteger percentage98  = [IScale_98 computePercentageForRecord: record
                                                                analyser: analyser];
        
        addRow(___Details_Matches_IScale_98, [NSString stringWithFormat: @"%ld%%", percentage98]);
        
        percentage = (percentage * percentage98 * 100 / TaerSum / 10);
        
        
        addRow(___Details_Final_Percentage,
               [NSString stringWithFormat: @"%ld * %ld * 100 / %ld / 10 = %ld",
                (long)oldPercentage, (long)percentage98, (long)TaerSum, (long)percentage]);
        
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
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%ld < %ld; 5.00",
                    (long)D, (long)percentage]);
        }
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (NSArray *) bracketsForRecord: (id<TestRecordProtocol>) record
{
    NSAssert(_brackets.count == 4, @"");
    return _brackets;
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    id<AnalyzerGroup> IScale_97 = [analyser firstGroupForType: kGroupType_IScale_97];
    id<AnalyzerGroup> IScale_98 = [analyser firstGroupForType: kGroupType_IScale_98];
    
    NSUInteger TaerSum =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    if (TaerSum > 0)
    {
        NSUInteger percentage = 0;
        
        if ([_multiplierType isEqualToString: kGroupType_IScale_99])
        {
            percentage =
            ([IScale_95 computePercentageForRecord: record analyser: analyser] +
             [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / TaerSum;
        }
        else
        {
            percentage =
            [IScale_95 computePercentageForRecord: record analyser: analyser] * 100 / TaerSum;
        }
        
        percentage = (percentage * [IScale_98 computePercentageForRecord: record
                                                                analyser: analyser] *
                      100 / TaerSum / 10);
        
        if (percentage <= A)
            self.score = round(10 * 1.5 * (double)percentage/(double)A);
        
        else if (percentage <= B)
            self.score = round(10*(1.5+(double)(percentage-A)/(double)(B-A)));
        
        else if (percentage <= C)
            self.score = round(10*(2.5+(double)(percentage-B)/(double)(C-B)));
        
        else if (percentage <= D)
            self.score = round(10*(3.5+(double)(percentage-C)/(double)(D-C)));
        else
            self.score = 50;
        
        self.score = self.score / 10.0;
    }
    else self.score = -1;
    
    return self.score;
}

@end


#pragma mark -
#pragma mark Error messages

static id _logBracketNotFound()
{
    NSLog(@"Failed to parse ISCALE_99 group: '%@' not found.", kJSONKeyPercent);
    return nil;
}


static id _logWrongNumberOfComponents(NSString *key, id object)
{
    NSLog(@"Failed to parse ISCALE_99 group: expected 4 integer components in '%@', got '%@' instead.", key, object);
    return nil;
}


static id _logMultiplierNotFound()
{
    NSLog(@"Failed to parse ISCALE_M group: '%@' not found.", kJSONKeyMultiplier);
    return nil;
}