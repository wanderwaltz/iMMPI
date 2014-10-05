//
//  HtmlTableReportComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HtmlTableReportComposerDataSource;

@protocol HtmlTableReportComposer <NSObject>
@property (nonatomic, weak) id<HtmlTableReportComposerDataSource> dataSource;

- (NSString *)composeReport;

@end



@protocol HtmlTableReportComposerDataSource<NSObject>

- (NSDictionary *)tableAttributesForHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer;

- (NSInteger)numberOfColumnsInHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer;
- (NSInteger)numberOfRowsInHtmlTableReportComposer:(id<HtmlTableReportComposer>)composer;

- (NSDictionary *)tableReportComposer:(id<HtmlTableReportComposer>)composer attributesForColumn:(NSInteger)column;

- (NSDictionary *)tableReportComposer:(id<HtmlTableReportComposer>)composer attributesForHeaderCellInColumn:(NSInteger)column;
- (NSString *)tableReportComposer:(id<HtmlTableReportComposer>)composer textForHeaderCellInColumn:(NSInteger)column;

- (NSString *)tableReportcomposer:(id<HtmlTableReportComposer>)composer htmlTextForColumn:(NSInteger)column row:(NSInteger)row;

@end