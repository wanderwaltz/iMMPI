//
//  HtmlReportTagDecoratorTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "HtmlReportTagDecorator.h"

SPEC_BEGIN(HtmlReportTagDecoratorTests)

describe(@"HtmlReportTagDecorator", ^{
    it(@"should conform to AnalyzerReportComposer protocol", ^{
        [[[HtmlReportTagDecorator class] should] conformToProtocol: @protocol(AnalyzerReportComposer)];
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
    
    
    let(tag, ^NSString *{
        return @"body";
    });
    
    
    it(@"should not be able to be created without a tag", ^{
        [[[[HtmlReportTagDecorator alloc] initWithTag: nil contentComposer: child_report_composer] should] beNil];
    });
    
    
    it(@"should not be able to be created without a content composer", ^{
        [[[[HtmlReportTagDecorator alloc] initWithTag: tag contentComposer: nil] should] beNil];
    });
    
    
    context(@"when newly created", ^{
        let(tag_decorator, ^HtmlReportTagDecorator *{
            return [[HtmlReportTagDecorator alloc] initWithTag: tag contentComposer: child_report_composer];
        });
        
        
        it(@"should ask its child composer for content", ^{
            [[child_report_composer should] receive: @selector(composeReportForTestRecord:) withArguments: test_record];
            [tag_decorator composeReportForTestRecord: test_record];
        });
        
        
        it(@"should wrap the child composer content into the given tag", ^{
            NSString *report = [tag_decorator composeReportForTestRecord: test_record];
            [[report should] equal: [NSString stringWithFormat: @"<%@>%@</%@>", tag, child_report_content, tag]];
        });
    });
});

SPEC_END
