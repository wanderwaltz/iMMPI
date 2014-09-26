//
//  AnalyzerReportComposerFactory.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerReportComposerFactory.h"
#import "PersonNameReportComposer.h"
#import "DateReportComposer.h"
#import "CompositeReportComposer.h"
#import "HtmlReportHtmlDecorator.h"
#import "HtmlReportTagDecorator.h"

@implementation AnalyzerReportComposerFactory

+ (id<AnalyzerReportComposer>)answersReportComposer
{
    return [[HtmlReportHtmlDecorator alloc] initWithContentComposer:
                [self decorateComposerWithHtmlBody:
                     [self headerComposer]]];
}


#pragma mark - model-specific sub-composers

+ (id<AnalyzerReportComposer>)headerComposer
{
    return [[CompositeReportComposer alloc] initWithChildComposers: @[[self personNameComposer], [self testDateComposer]]
                separator: nil];
}

+ (id<AnalyzerReportComposer>)personNameComposer
{
    return [self decorateComposer: [[PersonNameReportComposer alloc] init]
              withHtmlHeaderLevel: 1];
}


+ (id<AnalyzerReportComposer>)testDateComposer
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    return [self decorateComposer: [[DateReportComposer alloc] initWithDateFormatter: formatter]
              withHtmlHeaderLevel: 2];
}


#pragma mark - generic helper html decorators

+ (id<AnalyzerReportComposer>)decorateComposer:(id<AnalyzerReportComposer>)composer withHtmlHeaderLevel:(NSInteger)level
{
    NSString *tag = [NSString stringWithFormat: @"H%ld", (long)level];
    return [[HtmlReportTagDecorator alloc] initWithTag: tag contentComposer: composer];
}


+ (id<AnalyzerReportComposer>)decorateComposerWithHtmlBody:(id<AnalyzerReportComposer>)composer
{
    return [[HtmlReportTagDecorator alloc] initWithTag: @"body" contentComposer: composer];
}

@end
