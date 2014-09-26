//
//  HtmlReportHtmlDecoratorTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "HtmlReportHtmlDecorator.h"

SPEC_BEGIN(HtmlReportHtmlDecoratorTests)

describe(@"HtmlReportHtmlDecorator", ^{
    it(@"should conform to AnalyzerReportComposer protocol", ^{
        [[[HtmlReportHtmlDecorator class] should] conformToProtocol: @protocol(AnalyzerReportComposer)];
    });
    
    
    it(@"should not be able to be created without a child composer", ^{
        [[[[HtmlReportHtmlDecorator alloc] initWithContentComposer: nil] should] beNil];
    });
    
    
    let(test_record, ^id{
        return [KWMock mockForProtocol: @protocol(TestRecordProtocol)];
    });
    
    
    let(child_report_content, ^NSString *{
        return @"child_report_content";
    });
    
    
    let(child_report_composer, ^id{
        id mock = [KWMock mockForProtocol: @protocol(AnalyzerReportComposer)];
        [mock stub: @selector(composeReportForTestRecord:) andReturn: child_report_content withArguments: test_record];
        return mock;
    });
    
    context(@"when newly created", ^{
        let(html_decorator, ^HtmlReportHtmlDecorator *{
            return [[HtmlReportHtmlDecorator alloc] initWithContentComposer: child_report_composer];
        });
        
        
        it(@"should ask the child composer for content when composing a report", ^{
            [[child_report_composer should] receive: @selector(composeReportForTestRecord:) withArguments: test_record];
            [html_decorator composeReportForTestRecord: test_record];
        });
        
        
        it(@"should wrap child composer content in <html></html> tags", ^{
            NSString *report = [html_decorator composeReportForTestRecord: test_record];
            [[report should] containString: [NSString stringWithFormat: @"<html>%@</html>", child_report_content]];
        });
        
        
        it(@"should include the doctype info provided by default", ^{
            NSString *report = [html_decorator composeReportForTestRecord: test_record];
            [[report should] containString: html_decorator.doctype];
        });
        
        
        it(@"should include the customized doctype info", ^{
            NSString *expected_doctype = @"custom_doctype";
            html_decorator.doctype = expected_doctype;
            NSString *report = [html_decorator composeReportForTestRecord: test_record];
            [[report should] containString: expected_doctype];
        });
        
        
        it(@"should include the meta provided by default", ^{
            NSString *report = [html_decorator composeReportForTestRecord: test_record];
            [[report should] containString: html_decorator.meta];
        });
        
        
        it(@"should include the custom meta", ^{
            NSString *expected_meta = @"custom_meta";
            html_decorator.meta = expected_meta;
            NSString *report = [html_decorator composeReportForTestRecord: test_record];
            [[report should] containString: expected_meta];
        });
    });
});

SPEC_END

