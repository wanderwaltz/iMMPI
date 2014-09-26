//
//  DateReportComposerTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "DateReportComposer.h"
#import "TestRecordProtocol.h"

SPEC_BEGIN(DateReportComposerTests)

describe(@"DateReportComposer", ^{
    it(@"should conform to AnalyzerReportComposer protocol", ^{
        [[[DateReportComposer class] should] conformToProtocol: @protocol(AnalyzerReportComposer)];
    });
    
    
    let(date_formatter, ^NSDateFormatter *{
        return [KWMock mockForClass: [NSDateFormatter class]];
    });
    
    
    let(record_date, ^id{
        return [NSDate dateWithTimeIntervalSince1970: 100];
    });
    
    
    let(test_record, ^id{
        return [KWMock mockForProtocol: @protocol(TestRecordProtocol)];
    });
    
    
    context(@"when newly created", ^{
        let(composer, ^DateReportComposer *{
            return [[DateReportComposer alloc] initWithDateFormatter: date_formatter];
        });
        
    
        it(@"should use the record date and date formatter to compose the report", ^{
            NSString *expected_report = @"formatted_date";
            
            [[test_record should] receive: @selector(date) andReturn: record_date];
            [[date_formatter should] receive: @selector(stringFromDate:) andReturn: expected_report withArguments: record_date];
            
            NSString *actual_report = [composer composeReportForTestRecord: test_record];
            
            [[actual_report should] equal: expected_report];
        });
    });
});

SPEC_END
