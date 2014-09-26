//
//  CompositeReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "CompositeReportComposer.h"

SPEC_BEGIN(CompositeReportComposerTests)

describe(@"CompositeReportComposer", ^{
    it(@"should conform to AnalyzerReportComposer protocol", ^{
        [[[CompositeReportComposer class] should] conformToProtocol: @protocol(AnalyzerReportComposer)];
    });
    
    
    let(test_record, ^id{
        return [KWMock mockForProtocol: @protocol(TestRecordProtocol)];
    });
    
    
    let(first_child_report_content, ^NSString *{
        return @"first_child_report_content";
    });
    
    let(second_child_report_content, ^NSString *{
        return @"first_child_report_content";
    });
    
    
    let(first_child_report_composer, ^id{
        id mock = [KWMock mockForProtocol: @protocol(AnalyzerReportComposer)];
        [mock stub: @selector(composeReportForTestRecord:) andReturn: first_child_report_content withArguments: test_record];
        return mock;
    });
    
    
    let(second_child_report_composer, ^id{
        id mock = [KWMock mockForProtocol: @protocol(AnalyzerReportComposer)];
        [mock stub: @selector(composeReportForTestRecord:) andReturn: second_child_report_content withArguments: test_record];
        return mock;
    });
    
    
    let(separator, ^NSString *{
        return @"separator";
    });
    
    
    it(@"should not be able to be created without child composers", ^{
        [[[[CompositeReportComposer alloc]initWithChildComposers: nil separator: separator] should] beNil];
    });
    
    
    it(@"should be able to be created without a separator", ^{
        [[[[CompositeReportComposer alloc] initWithChildComposers: @[first_child_report_composer] separator: nil] shouldNot] beNil];
    });
    
    
    context(@"when newly created", ^{
        let(composite, ^CompositeReportComposer *{
            return [[CompositeReportComposer alloc] initWithChildComposers: @[first_child_report_composer, second_child_report_composer]
                                                                 separator: separator];
        });
        
        
        it(@"should ask its child composers for content", ^{
            [[first_child_report_composer should] receive: @selector(composeReportForTestRecord:) withArguments: test_record];
            [[second_child_report_composer should] receive: @selector(composeReportForTestRecord:) withArguments: test_record];
            [composite composeReportForTestRecord: test_record];
        });
        
        
        it(@"should include reports from all childs separated by a given separator", ^{
            NSString *report = [composite composeReportForTestRecord: test_record];
            [[report should] equal:
                 [NSString stringWithFormat: @"%@%@%@", first_child_report_content, separator, second_child_report_content]];
        });
    });
});

SPEC_END
