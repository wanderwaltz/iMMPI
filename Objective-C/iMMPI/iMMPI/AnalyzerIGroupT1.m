//
//  AnalyzerIGroupT1.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroupT1.h"


#pragma mark -
#pragma mark AnalyzerIGroupT1 implementation

@implementation AnalyzerIGroupT1

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
    addRow(___Details_Matches,          [NSString stringWithFormat: @"%ld", (long)matches]);
    addRow(___Details_Matches_Percent,  [NSString stringWithFormat: @"%ld%%", (long)percentage]);
    addRow(___Details_Brackets,         [NSString stringWithFormat: @"%ld < %ld < %ld < %ld", (long)A, (long)B, (long)C, (long)D]);
    addRow(___Details_Taer_Sum,         [NSString stringWithFormat: @"%ld", (long)TaerSum]);
    
    if (TaerSum > 0)
    {
        NSUInteger oldPercentage = percentage;
        percentage = percentage * 100 / TaerSum;
        
        addRow(___Details_Percentage_Taer_Sum,
               [NSString stringWithFormat: @"%ld * 100 / %ld = %ld", (long)oldPercentage, (long)TaerSum, (long)percentage]);
        
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


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    // Сумма Тэра вычисляется как сумма процентов совпадений по шкалам 95-98
    NSUInteger TaerSum = [analyser taerSumForRecord: record];
    
    // Сумма Тэра попадает в знаменатель, поэтому необходимо проверить,
    // что она положительная.
    if (TaerSum > 0)
    {
        // Формульные единицы для каждой из шкал 95-98 вычисляются на
        // основе процента совпадений, умноженного на 10 и деленного на
        // сумму Тэра.
        NSUInteger percentage = [self computePercentageForRecord: record
                                                        analyser: analyser];
        
        // Здесь идет умножение на 100, которое потом компенсируется делением на 10
        // в конце вычисления. Вероятно, это какой-то остаток из прошлой версии
        // приложения на Delphi, где вычисления были организованы как-то иначе.
        percentage = percentage * 100 / TaerSum;
        
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
        
        self.score /= 10.0;
    }
    else self.score = -1;
    
    
    return self.score;
}


@end
