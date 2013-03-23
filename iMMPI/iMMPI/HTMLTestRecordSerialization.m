//
//  HTMLTestRecordSerialization.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "HTMLTestRecordSerialization.h"


#pragma mark -
#pragma mark HTMLTestRecordSerialization implementation

@implementation HTMLTestRecordSerialization

+ (NSData *) dataWithTestRecord: (id<TestRecordProtocol>) record
{
    NSMutableString *html = [NSMutableString string];
    
    id<QuestionnaireProtocol> questionnaire =
    [Questionnaire newForGender: record.person.gender
                       ageGroup: record.person.ageGroup];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    [html appendFormat: @"<h1>%@</h1>", record.person.name];
    
    NSString *dateString = [dateFormatter stringFromDate: record.date];
    
    if (dateString.length > 0)
        [html appendFormat: @"<h2>%@</h2>", dateString];
    
    [html appendString: @"<table width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\"10%\">"];
    [html appendString: @"<col width=\"80%\">"];
    [html appendString: @"<col width=\"10%\">"];
    [html appendString: @"</colgroup>"];
    
    for (NSUInteger i = 0; i < [questionnaire statementsCount]; ++i)
    {
        id<StatementProtocol> statement = [questionnaire statementAtIndex: i];
        
        [html appendString: @"<tr>"];
        
        [html appendFormat: @"<td colspan=\"1\">%d</td>", [statement statementID]];
        [html appendFormat: @"<td colspan=\"1\">%@</td>", [statement text]];
        
        AnswerType answer = [record.testAnswers answerTypeForStatementID: [statement statementID]];
        
        switch (answer)
        {
            case AnswerTypeNegative:
            {
                [html appendString: @"<td colspan=\"1\">-</td>"];
            } break;
                
                
            case AnswerTypePositive:
            {
                [html appendString: @"<td colspan=\"1\">+</td>"];
            }
                
            default:
            {
                [html appendString: @"<td colspan=\"1\"></td>"];
            } break;
        }
        [html appendString: @"</tr>"];
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
        
    NSData *data = [html dataUsingEncoding: NSUTF8StringEncoding];
    
    return data;
}

@end
