//
//  AnswersListReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "AnswersListReportComposer.h"

enum {
    kColumnStatementID,
    kColumnStatementText,
    kColumnAnswerType,
    
    kColumnsCount
};

@interface AnswersListReportComposer()
@property (nonatomic, strong, readonly) id<HtmlTableReportComposer> tableComposer;
@property (nonatomic, strong, readonly) NSDictionary *attributesForColumn;
@property (nonatomic, strong, readonly) NSDictionary *textForHeaderCellInColumn;
@property (nonatomic, strong) id<TestRecordProtocol> testRecord;
@end

@implementation AnswersListReportComposer

#pragma mark -
#pragma mark initialization methods

- (instancetype)init
{
    return [self initWithHtmlTableReportComposer: nil];
}

- (instancetype)initWithHtmlTableReportComposer:(id<HtmlTableReportComposer>)tableComposer
{
    NSParameterAssert(tableComposer != nil);
    if (!tableComposer) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _tableComposer = tableComposer;
    _tableComposer.dataSource = self;
    
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
    return 0;
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


- (NSString *)tableReportcomposer:(id<HtmlTableReportComposer>)composer htmlTextForColumn:(NSInteger)column row:(NSInteger)row
{
    return nil;
}


@end
