#if 0
//
//  AnalysisHTMLReportGenerator.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalysisHTMLReportGenerator.h"
#import "Model.h"


#pragma mark -
#pragma mark AnalysisHTMLReportGenerator private

@interface AnalysisHTMLReportGenerator()
{
@private
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark AnalysisHTMLReportGenerator implementation

@implementation AnalysisHTMLReportGenerator

#pragma mark -
#pragma mark initialization methods

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (NSString *)composeOverallAnalysisReportForGroupIndices:(NSArray *)groupIndices
                                         filterNormValues:(BOOL)filter
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    [html appendFormat: @"<h1>%@</h1>", self.record.person.name];
    
    NSString *dateString = [_dateFormatter stringFromDate: self.record.date];
    
    if (dateString.length > 0)
        [html appendFormat: @"<h2>%@</h2>", dateString];
    
    [html appendString: @"<table style=\"border:1px solid black; border-collapse:collapse;\" width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\" 1%\">"];
    [html appendString: @"<col width=\" 4%\">"];
    [html appendString: @"<col width=\" 5%\">"];
    [html appendString: @"<col width=\"75%\">"];
    [html appendString: @"<col width=\"15%\">"];
    [html appendString: @"</colgroup>"];
    
    void (^appendGroupRow)(id<AnalyzerGroup> group, NSUInteger groupIndex) =
    
    ^(id<AnalyzerGroup> group, NSUInteger groupIndex)
    {
        if (group != nil)
        {
            [html appendString: @"<tr>"];
            
            switch ([self.analyzer depthOfGroupAtIndex: groupIndex])
            {
                case 0:
                {
                    [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"4\"><b>%@</b></td>", group.name];
                } break;
                    
                    
                case 1:
                {
                    [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"2\">%ld.</td>",
                     (long)[group indexForRecord: self.record]];
                    [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"2\">%@</td>", group.name];
                } break;
                    
                    
                default:
                {
                    [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"3\">%ld.</td>",
                     (long)[group indexForRecord: self.record]];
                    [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"1\"><i>%@</i></td>", group.name];
                } break;
            }
            
            if ([group scoreIsWithinNorm] && filter)
                [html appendFormat: @"<td style=\"border:1px solid black;\" align=\"center\">%@</td>", ___Normal_Score_Placeholder];
            else
                [html appendFormat: @"<td style=\"border:1px solid black;\" align=\"center\">%@</td>", group.readableScore];
            
            [html appendString: @"</tr>"];
        }
    };
    
    
    if (groupIndices == nil)
    {
        for (NSInteger i = 0; i < _analyzer.groupsCount; ++i)
        {
            id<AnalyzerGroup> group = [_analyzer groupAtIndex: i];
            appendGroupRow(group, i);
        }
    }
    else
    {
        for (NSNumber *groupIndexNumber in groupIndices)
        {
            FRB_AssertClass(groupIndexNumber, NSNumber);
            NSInteger groupIndex = [groupIndexNumber integerValue];
            
            id<AnalyzerGroup> group = [_analyzer groupAtIndex: groupIndex];
            appendGroupRow(group, groupIndex);
        }
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (NSString *)composeDetailedReportForGroupNamed:(NSString *)groupName
{
    id<AnalyzerGroup> group = [_analyzer groupWithName: groupName];
    
    if (group != nil)
    {
        NSMutableString *html = [NSMutableString string];
        
        NSArray *positiveIDs = [group positiveStatementIDsForRecord: _record];
        NSArray *negativeIDs = [group negativeStatementIDsForRecord: _record];
        
        [html appendString: @"<!DOCTYPE html>"];
        [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
        [html appendString: @"<html>"];
        [html appendString: @"<body>"];
        [html appendFormat: @"<h1>%@</h1>", _record.person.name];
        
        NSString *dateString = [_dateFormatter stringFromDate: _record.date];
        
        if (dateString.length > 0)
            [html appendFormat: @"<h2>%@</h2>", dateString];
        
        [html appendFormat: @"<h3>%@</h3>", group.name];
        
        [html appendString: @"<table style=\"border:1px solid black; border-collapse:collapse;\" width=\"100%\">"];
        [html appendString: @"<colgroup>"];
        [html appendString: @"<col width=\"10%\">"];
        [html appendString: @"<col width=\"70%\">"];
        [html appendString: @"<col width=\"10%\">"];
        [html appendString: @"<col width=\"10%\">"];
        [html appendString: @"</colgroup>"];
        
        [html appendString: @"<tr>"];
        [html appendString: @"<th style=\"border:1px solid black;\">№</th>"];
        [html appendString: @"<th style=\"border:1px solid black;\">Вопрос</th>"];
        [html appendString: @"<th style=\"border:1px solid black;\">Шкала</th>"];
        [html appendString: @"<th style=\"border:1px solid black;\">Ответ</th>"];
        [html appendString: @"</tr>"];
        
        void (^appendRowForStatement)(id<StatementProtocol> statement, BOOL positive) =
        ^(id<StatementProtocol> statement, BOOL positive){
            
            if (![self.analyzer isValidStatementID: statement.statementID])
                return; // Ignore invalid statements
            
            [html appendString: @"<tr>"];
            
            [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">%ld</td>", (long)[statement statementID]];
            [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"1\">%@</td>", [statement text]];
            
            
            if (positive)
            {
                [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">+</td>"];
            }
            else
            {
                [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">-</td>"];
            }
            
            
            AnswerType answer = [self.record.testAnswers answerTypeForStatementID:
                                 [statement statementID]];
            
            switch (answer)
            {
                case AnswerTypeNegative:
                {
                    [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">-</td>"];
                } break;
                    
                    
                case AnswerTypePositive:
                {
                    [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">+</td>"];
                }
                    
                default:
                {
                    [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\"></td>"];
                } break;
            }
            [html appendString: @"</tr>"];
        };
        
        
        for (NSNumber *statementID in positiveIDs)
        {
            FRB_AssertClass(statementID, NSNumber);
            id<StatementProtocol> statement = [_questionnaire statementWithID:
                                               [statementID unsignedIntegerValue]];
            
            appendRowForStatement(statement, YES);
        }
        
        
        for (NSNumber *statementID in negativeIDs)
        {
            FRB_AssertClass(statementID, NSNumber);
            id<StatementProtocol> statement = [_questionnaire statementWithID:
                                               [statementID unsignedIntegerValue]];
            
            appendRowForStatement(statement, NO);
        }
        
        [html appendString: @"</table>"];
        [html appendString: @"</body>"];
        [html appendString: @"</html>"];
        
        return html;
    }
    else return nil;
}


- (NSString *)composeAnswersReport
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    [html appendFormat: @"<h1>%@</h1>", _record.person.name];
    
    NSString *dateString = [_dateFormatter stringFromDate: _record.date];
    
    if (dateString.length > 0)
        [html appendFormat: @"<h2>%@</h2>", dateString];
    
    [html appendString: @"<table style=\"border:1px solid black; border-collapse:collapse;\" width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\"10%\">"];
    [html appendString: @"<col width=\"80%\">"];
    [html appendString: @"<col width=\"10%\">"];
    [html appendString: @"</colgroup>"];
    
    
    [html appendString: @"<tr>"];
    [html appendString: @"<th style=\"border:1px solid black;\">№</th>"];
    [html appendString: @"<th style=\"border:1px solid black;\">Вопрос</th>"];
    [html appendString: @"<th style=\"border:1px solid black;\">Ответ</th>"];
    [html appendString: @"</tr>"];

    
    for (NSInteger i = 0; i < [_questionnaire statementsCount]; ++i)
    {
        id<StatementProtocol> statement = [_questionnaire statementAtIndex: i];
        
        [html appendString: @"<tr>"];
        
        [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">%ld</td>", (long)[statement statementID]];
        [html appendFormat: @"<td style=\"border:1px solid black;\" colspan=\"1\">%@</td>", [statement text]];
        
        AnswerType answer = [_record.testAnswers answerTypeForStatementID:
                             [statement statementID]];
        
        switch (answer)
        {
            case AnswerTypeNegative:
            {
                [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">-</td>"];
            } break;
                
                
            case AnswerTypePositive:
            {
                [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\" align=\"center\">+</td>"];
            }
                
            default:
            {
                [html appendString: @"<td style=\"border:1px solid black;\" colspan=\"1\"></td>"];
            } break;
        }
        [html appendString: @"</tr>"];
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}

@end
#endif
