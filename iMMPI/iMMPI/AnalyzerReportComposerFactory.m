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
#import "AnswersListReportComposer.h"

#import "CompositeReportComposer.h"
#import "HtmlReportHtmlDecorator.h"
#import "HtmlReportTagDecorator.h"

#import "DefaultHtmlBuilder.h"
#import "DefaultHtmlTableReportComposer.h"

@implementation AnalyzerReportComposerFactory

+ (id<AnalyzerReportComposer>)answersReportComposerWithQuestionnaire:(id<QuestionnaireProtocol>)questionnaire
{
    id<AnalyzerReportComposer> headerComposer = [self headerComposer];
    id<AnalyzerReportComposer> answersListComposer = [self answersListComposerWithQuestionnaire: questionnaire];
    
    id<AnalyzerReportComposer> contentComposer =
        [self sequence: @[headerComposer, answersListComposer]];
    
    id<AnalyzerReportComposer> bodyComposer = [self decorateComposerWithHtmlBody: contentComposer];
    
    id<AnalyzerReportComposer> htmlComposer =
        [[HtmlReportHtmlDecorator alloc] initWithContentComposer: bodyComposer];
    
    return htmlComposer;
}


#pragma mark - model-specific sub-composers

+ (id<AnalyzerReportComposer>)headerComposer
{
    return [self sequence: @[[self personNameComposer], [self testDateComposer]]];
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


+ (id<AnalyzerReportComposer>)answersListComposerWithQuestionnaire:(id<QuestionnaireProtocol>)questionnaire
{
    return [[AnswersListReportComposer alloc]
                initWithHtmlTableReportComposer: [self htmlTableReportComposer]
                questionnaire: questionnaire];
}


#pragma mark - generic helper html decorators

+ (id<AnalyzerReportComposer>)decorateComposer:(id<AnalyzerReportComposer>)composer withHtmlHeaderLevel:(NSInteger)level
{
    NSString *tag = [NSString stringWithFormat: @"H%ld", (long)level];
    return [[HtmlReportTagDecorator alloc]
                initWithTag: tag
                htmlBuilder: [self htmlBuilder]
                contentComposer: composer];
}


+ (id<AnalyzerReportComposer>)decorateComposerWithHtmlBody:(id<AnalyzerReportComposer>)composer
{
    return [[HtmlReportTagDecorator alloc]
                initWithTag: @"body"
                htmlBuilder: [self htmlBuilder]
                contentComposer: composer];
}


+ (id<AnalyzerReportComposer>)sequence:(NSArray *)childComposers
{
    return [[CompositeReportComposer alloc] initWithChildComposers: childComposers separator: nil];
}


#pragma mark - helpers

+ (id<HtmlBuilder>)htmlBuilder
{
    return [[DefaultHtmlBuilder alloc] init];
}


+ (id<HtmlTableReportComposer>)htmlTableReportComposer
{
    return [[DefaultHtmlTableReportComposer alloc] initWithHtmlBuilder: [self htmlBuilder]];
}

@end
