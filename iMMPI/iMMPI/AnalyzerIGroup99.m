//
//  AnalyzerIGroup99.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroup99.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyPercent = @"percent";


#pragma mark -
#pragma mark Error message function declarations

static id _logBracketNotFound();
static id _logWrongNumberOfComponents(NSString *key, id object);


#pragma mark -
#pragma mark AnalyzerIGroup99 private

@interface AnalyzerIGroup99()
{
    NSArray *_brackets;
}

@end


#pragma mark -
#pragma mark AnalyzerIGroup99 implementation

@implementation AnalyzerIGroup99

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

    
    self = [super init];
    
    if (self != nil)
    {
        _brackets = bracket;
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
    
    NSUInteger T_aer =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    
    addRow(___Details_Score,            self.readableScore);
    addRow(___Details_Brackets,         [NSString stringWithFormat: @"%d < %d < %d < %d", A, B, C, D]);
    addRow(___Details_Taer_Sum,         [NSString stringWithFormat: @"%d", T_aer]);
    
    if (T_aer > 0)
    {
        NSUInteger percentage95 = [IScale_95 computePercentageForRecord: record analyser: analyser];
        NSUInteger percentage96 = [IScale_96 computePercentageForRecord: record analyser: analyser];
        
        addRow(___Details_Matches_IScale_95, [NSString stringWithFormat: @"%d%%", percentage95]);
        addRow(___Details_Matches_IScale_96, [NSString stringWithFormat: @"%d%%", percentage96]);
        
        NSUInteger percentage = (percentage95 + percentage96) * 100 / T_aer;
        
        addRow(___Details_Percentage_Taer_Sum,
               [NSString stringWithFormat: @"(%d + %d) * 100 / %d = %d", percentage95, percentage96, T_aer, percentage]);
        
        if (percentage <= A)
        {
            double score = 1.5 * (double)percentage / (double)A;
            
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%d <= %d; 1.5 * %d / %d = %.2lf",
                    percentage, A, percentage, A, score]);
        }
        else if (percentage <= B)
        {
            double score = (1.5 + (double)(percentage-A) / (double)(B-A));
            
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%d < %d <= %d; 1.5 + (%d-%d) / (%d-%d) = %.2lf",
                    A, percentage, B, percentage, A, B, A, score]);
        }
        else if (percentage <= C)
        {
            double score = (2.5 + (double)(percentage-B) / (double)(C-B));
            
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%d < %d <= %d; 2.5 + (%d-%d) / (%d-%d) = %.2lf",
                    B, percentage, C, percentage, B, C, B, score]);
        }
        else if (percentage <= D)
        {
            double score = (3.5 + (double)(percentage-C) / (double)(D-C));
            
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%d < %d <= %d; 3.5 + (%d-%d) / (%d-%d) = %.2lf",
                    C, percentage, D, percentage, C, D, C, score]);
        }
        else
        {
            addRow(___Details_Computation,
                   [NSString stringWithFormat:
                    @"%d < %d; 5.00",
                    D, percentage]);
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
    
    NSUInteger T_aer =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    if (T_aer > 0)
    {
        NSUInteger percentage =
        ([IScale_95 computePercentageForRecord: record analyser: analyser] +
         [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / T_aer;
        
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
        
        self.score = self.score/10.0;
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

