//
//  AnalyzerKGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerKGroup.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyCorrectionMultiplier = @"correctionMultiplier";


#pragma mark -
#pragma mark AnalyzerKGroup private

@interface AnalyzerKGroup()
{
    double _correctionMultiplier;
}

@end


#pragma mark -
#pragma mark AnalyzerKGroup implementation

@implementation AnalyzerKGroup

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _correctionMultiplier = [json[kJSONKeyCorrectionMultiplier] doubleValue];
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
    
    double median    = (record.person.gender == GenderFemale) ?    self.medianFemale :    self.medianMale;
    double deviation = (record.person.gender == GenderFemale) ? self.deviationFemale : self.deviationMale;
    
    id<AnalyzerGroup> correctionGroup = [analyser firstGroupForType: kGroupType_Base_K];
    
    NSUInteger correctionMatches = [correctionGroup computeMatchesForRecord: record
                                                                   analyser: analyser];
    
    double score = 50 + 10 * (matches+correctionMatches*_correctionMultiplier-median)/deviation;
    
    addRow(___Details_Score,                 self.readableScore);
    addRow(___Details_Matches,               [NSString stringWithFormat: @"%d", matches]);
    addRow(___Details_Median_Male,           [NSString stringWithFormat: @"%.2lf", self.medianMale]);
    addRow(___Details_Deviation_Male,        [NSString stringWithFormat: @"%.2lf", self.deviationMale]);
    addRow(___Details_Median_Female,         [NSString stringWithFormat: @"%.2lf", self.medianFemale]);
    addRow(___Details_Deviation_Female,      [NSString stringWithFormat: @"%.2lf", self.deviationFemale]);
    addRow(___Details_Correction_Multiplier, [NSString stringWithFormat: @"%.2lf", _correctionMultiplier]);
    addRow(___Details_Correction,            [NSString stringWithFormat: @"%d", correctionMatches]);
    addRow(___Details_Computation,
           [NSString stringWithFormat: @"(50 + 10 * (%d + %d*%.2lf- %.2lf)/%.2lf) = %.2lf",
            matches, correctionMatches, _correctionMultiplier, median, deviation, score]);
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger matches = [self computeMatchesForRecord: record
                                              analyser: analyser];
    
    double median    = (record.person.gender == GenderFemale) ?
                        self.medianFemale : self.medianMale;
    
    double deviation = (record.person.gender == GenderFemale) ?
                        self.deviationFemale : self.deviationMale;
    
    id<AnalyzerGroup> correctionGroup = [analyser firstGroupForType: kGroupType_Base_K];
    
    NSUInteger correctionMatches = [correctionGroup computeMatchesForRecord: record
                                                                   analyser: analyser];
    
    double score = round(50 + 10 * (matches+correctionMatches*_correctionMultiplier-median)/deviation);
    self.score   = score;
    
    return self.score;
}


@end
