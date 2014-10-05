//
//  HtmlReportTagDecoratorTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "HtmlReportTagDecorator.h"
#import "HtmlBuilder.h"

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
    
    
    let(html_builder, ^id{
        return [KWMock nullMockForProtocol: @protocol(HtmlBuilder)];
    });
    
    
    it(@"should not be able to be created without a tag", ^{
        [[[[HtmlReportTagDecorator alloc]
               initWithTag: nil htmlBuilder: html_builder
               contentComposer: child_report_composer] should] beNil];
    });
    
    
    it(@"should not be able to be created without a content composer", ^{
        [[[[HtmlReportTagDecorator alloc]
           initWithTag: tag
           htmlBuilder: html_builder
           contentComposer: nil] should] beNil];
    });
    
    
    it(@"should not be able to be created without a html builder", ^{
        [[[[HtmlReportTagDecorator alloc]
               initWithTag: tag
               htmlBuilder: nil
               contentComposer: child_report_composer] should] beNil];
    });
    
    
    context(@"when newly created", ^{
        let(tag_decorator, ^HtmlReportTagDecorator *{
            return [[HtmlReportTagDecorator alloc]
                        initWithTag: tag
                        htmlBuilder: html_builder
                        contentComposer: child_report_composer];
        });
        
        
        it(@"should ask its child composer for content", ^{
            [[child_report_composer should] receive: @selector(composeReportForTestRecord:) withArguments: test_record];
            [tag_decorator composeReportForTestRecord: test_record];
        });
        
        
        it(@"should use the html builder to wrap the child composer content into the given tag", ^{
            [[html_builder should] receive: @selector(open)];
            [[html_builder should] receive: @selector(addTag:attributes:text:)
                             withArguments: tag, nil, child_report_content];
            [[html_builder should] receive: @selector(close) andReturn: @"html_builder_result"];
            
            NSString *report = [tag_decorator composeReportForTestRecord: test_record];
            [[report should] equal: @"html_builder_result"];
        });
    });
});

SPEC_END
