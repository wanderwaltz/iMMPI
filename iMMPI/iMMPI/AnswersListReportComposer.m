//
//  AnswersListReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "AnswersListReportComposer.h"
#import "Model.h"

#import "QuestionnaireProtocol.h"
#import "StatementProtocol.h"
#import "TestRecordProtocol.h"


enum {
    kColumnStatementID,
    kColumnStatementText,
    kColumnAnswerType,
    
    kColumnsCount
};

@interface AnswersListReportComposer()
@property (nonatomic, strong, readonly) id<HtmlTableReportComposer> tableComposer;
@property (nonatomic, strong, readonly) id<QuestionnaireProtocol> questionnaire;

@property (nonatomic, strong, readonly) NSDictionary *attributesForColumn;
@property (nonatomic, strong, readonly) NSDictionary *attributesForCellInColumn;
@property (nonatomic, strong, readonly) NSDictionary *textForHeaderCellInColumn;

@property (nonatomic, strong) id<TestRecordProtocol> testRecord;
@end

@implementation AnswersListReportComposer

#pragma mark -
#pragma mark initialization methods

- (instancetype)init
{
    return [self initWithHtmlTableReportComposer: nil
                questionnaire: nil];
}

- (instancetype)initWithHtmlTableReportComposer:(id<HtmlTableReportComposer>)tableComposer
                    questionnaire:(id<QuestionnaireProtocol>)questionnaire
{
    NSParameterAssert(tableComposer != nil);
    NSParameterAssert(questionnaire != nil);
    if (!tableComposer || !questionnaire) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _tableComposer = tableComposer;
    _tableComposer.dataSource = self;
    
    _questionnaire = questionnaire;
    
   
    
    _attributesForCellInColumn = @{
                             @(kColumnStatementID)   : @{ @"style"   : @"border:1px solid black;",
                                                          @"colspan" : @"1",
                                                          @"align"   : @"center" },
                             
                             @(kColumnStatementText) : @{ @"style"   : @"border:1px solid black;",
                                                          @"colspan" : @"1" },
                             
                             @(kColumnAnswerType)    : @{ @"style"   : @"border:1px solid black;",
                                                          @"colspan" : @"1",
                                                          @"align"   : @"center" }
                             };
    
    _attributesForColumn = @{
                             @(kColumnStatementID)   : @{ @"width" : @"10%" },
                             @(kColumnStatementText) : @{ @"width" : @"80%" },
                             @(kColumnAnswerType)    : @{ @"width" : @"10%" }
                            };
    
    _textForHeaderCellInColumn = @{
                                   @(kColumnStatementID)   : @"№",
                                   @(kColumnStatementText) : @"Вопрос",
                                   @(kColumnAnswerType)    : @"Ответ"
                                   };
    
    return self;
}


#pragma mark -
#pragma mark <AnalyzerReportComposer>

- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    self.testRecord  = record;
    NSString *report = [self.tableComposer composeReport];
    self.testRecord  = nil;
    
    return report;
}


#pragma mark -
#pragma mark <HtmlTableReportComposerDataSource>

- (NSDictionary *)tableAttributesForHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer
{
    return @{ @"style" : @"border:1px solid black; border-collapse:collapse;",
              @"width" : @"100%" };
}


- (NSInteger)numberOfColumnsInHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer
{
    return 3;
}


- (NSInteger)numberOfRowsInHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer
{
    return [self.questionnaire statementsCount];
}


- (NSDictionary *)tableReportComposer:(id<HtmlTableReportComposer>)composer attributesForColumn:(NSInteger)column
{
    return self.attributesForColumn[@(column)];
}


- (NSDictionary *)tableReportComposer:(id<HtmlTableReportComposer>)composer attributesForHeaderCellInColumn:(NSInteger)column
{
    return @{ @"style" : @"border:1px solid black;" };
}


- (NSString *)tableReportComposer:(id<HtmlTableReportComposer>)composer textForHeaderCellInColumn:(NSInteger)column
{
    return self.textForHeaderCellInColumn[@(column)];
}


- (NSDictionary *)tableReportComposer:(id<HtmlTableReportComposer>)composer
                      attributesForCellInColumn:(NSInteger)column
                      row:(NSInteger)row
{
    return self.attributesForCellInColumn[@(column)];
}

- (NSString *)tableReportcomposer:(id<HtmlTableReportComposer>)composer
                  textForCellInColumn:(NSInteger)column
                  row:(NSInteger)row
{
    id<StatementProtocol> statement = [self.questionnaire statementAtIndex: row];
    
    switch (column) {
        case kColumnStatementID: {
            return [NSString stringWithFormat: @"%ld", (long)[statement statementID]];
        } break;
            
            
        case kColumnStatementText: {
            return [statement text];
        } break;
            
            
        case kColumnAnswerType: {
            AnswerType answer = [[self.testRecord testAnswers] answerTypeForStatementID: [statement statementID]];
            
            switch (answer) {
                case AnswerTypePositive: {
                    return @"+";
                } break;
                    
                case AnswerTypeNegative: {
                    return @"-";
                } break;
                    
                default: {
                    return @"";
                } break;
            }
        } break;
            
            
        default: {
            NSAssert(NO, @"Unknown column %ld", (long)column);
            return nil;
        } break;
    }
}



@end
