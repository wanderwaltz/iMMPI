//
//  AnalyzerBase5Group.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerBase5Group.h"


#pragma mark -
#pragma mark AnalyzerBase5Group implementation

@implementation AnalyzerBase5Group

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
    
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?    self.medianFemale :    self.medianMale;
    double deviation = (record.person.gender == GenderFemale) ? self.deviationFemale : self.deviationMale;
    
    double delta = matches-median;
    
    if (record.person.gender == GenderFemale) delta = -delta;
    
    double score = 50 + 10 * delta/deviation;

    
    addRow(___Details_Score,            self.readableScore);
    addRow(___Details_Matches,          [NSString stringWithFormat: @"%ld", (long)matches]);
    addRow(___Details_Median_Male,      [NSString stringWithFormat: @"%.2lf", self.medianMale]);
    addRow(___Details_Deviation_Male,   [NSString stringWithFormat: @"%.2lf", self.deviationMale]);
    addRow(___Details_Median_Female,    [NSString stringWithFormat: @"%.2lf", self.medianFemale]);
    addRow(___Details_Deviation_Female, [NSString stringWithFormat: @"%.2lf", self.deviationFemale]);
    
    if (record.person.gender == GenderFemale)
    {
        addRow(___Details_Computation,
               [NSString stringWithFormat: @"(50 + 10 * <b>(%.2lf - %ld)</b>/%.2lf) = %.2lf",
                median, (long)matches, deviation, score]);
        
        [html appendString: @"<tr>"];
        
        [html appendFormat: @"<td colspan=\"2\"><i>%@</i></td>",
         ___Details_Reversed_Delta_Note];
        
        [html appendString: @"</tr>"];
    }
    else
    {
        addRow(___Details_Computation,
               [NSString stringWithFormat: @"(50 + 10 * (%ld - %.2lf)/%.2lf) = %.2lf",
                (long)matches, median, deviation, score]);
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (BOOL) scoreIsWithinNorm
{
    return (40.0 <= self.score) && (self.score <= 60.0);
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?    self.medianFemale :    self.medianMale;
    double deviation = (record.person.gender == GenderFemale) ? self.deviationFemale : self.deviationMale;
    
    double delta = matches-median;
    
    if (record.person.gender == GenderFemale) delta = -delta;
    
    double score = round(50 + 10 * delta/deviation);
    self.score   = score;
    
    return self.score;
}

@end
