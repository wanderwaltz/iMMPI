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
});

SPEC_END

