//
//  DefaultHtmlTableReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "DefaultHtmlTableReportComposer.h"
#import "HtmlBuilder.h"

@interface DefaultHtmlTableReportComposer()
@property (nonatomic, strong, readonly) id<HtmlBuilder> htmlBuilder;
@end

@implementation DefaultHtmlTableReportComposer
@synthesize dataSource = _dataSource;


#pragma mark -
#pragma mark initialization methods

- (instancetype)initWithHtmlBuilder:(id<HtmlBuilder>)htmlBuilder
{
    NSParameterAssert(htmlBuilder != nil);
    if (!htmlBuilder) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _htmlBuilder = htmlBuilder;
    
    return self;
}


#pragma mark -
#pragma mark <HtmlTableReportComposer>

static NSString * const kTagTable = @"table";
static NSString * const kTagColgroup = @"colgroup";
static NSString * const kTagCol = @"col";
static NSString * const kTagRow = @"tr";
static NSString * const kTagHeader = @"th";
static NSString * const kTagCell = @"td";

- (NSString *)composeReport
{
    id<HtmlBuilder> builder = self.htmlBuilder;
    [builder open];
    
    NSDictionary *tableAttributes = [self.dataSource tableAttributesForHtmlTableReportComposer: self];
    [builder addOpeningTag: kTagTable attributes: tableAttributes];
    
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsInHtmlTableReportComposer: self];
    
    [self composeColgroupsWithBuilder: builder numberOfColumns: numberOfColumns];
    [self composeHeaderRowWithBuilder: builder numberOfColumns: numberOfColumns];
    [self composeRowsWithBuilder: builder numberOfColumns: numberOfColumns];
    
    [builder addClosingTag: kTagTable];
    
    return [builder close];
}


- (void)composeColgroupsWithBuilder:(id<HtmlBuilder>)builder numberOfColumns:(NSInteger)numberOfColumns
{
    [builder addOpeningTag: kTagColgroup attributes: nil];
    
    for (NSInteger column = 0; column < numberOfColumns; ++column) {
        NSDictionary *columnAttributes =
            [self.dataSource tableReportComposer: self attributesForColumn: column];
        
        [builder addTag: kTagCol attributes: columnAttributes text: nil];
    }
    
    [builder addClosingTag: kTagColgroup];

}


- (void)composeHeaderRowWithBuilder:(id<HtmlBuilder>)builder numberOfColumns:(NSInteger)numberOfColumns
{
    [builder addOpeningTag: kTagRow attributes: nil];
    
    for (NSInteger column = 0; column < numberOfColumns; ++column) {
        NSDictionary *headerAttributes =
            [self.dataSource tableReportComposer: self attributesForHeaderCellInColumn: column];
        
        NSString *headerText =
            [self.dataSource tableReportComposer: self textForHeaderCellInColumn: column];
        
        [builder addTag: kTagHeader attributes: headerAttributes text: headerText];
    }
    
    [builder addClosingTag: kTagRow];
}


- (void)composeRowsWithBuilder:(id<HtmlBuilder>)builder numberOfColumns:(NSInteger)numberOfColumns
{
    NSInteger numberOfRows = [self.dataSource numberOfRowsInHtmlTableReportComposer: self];
    
    for (NSInteger row = 0; row < numberOfRows; ++row) {
        
        [builder addOpeningTag: kTagRow attributes: nil];
        for (NSInteger column = 0; column < numberOfColumns; ++column) {
            NSDictionary *cellAttributes =
                [self.dataSource tableReportComposer: self
                    attributesForCellInColumn: column
                    row: row];
            
            NSString *cellText =
                [self.dataSource tableReportcomposer: self
                    textForCellInColumn: column
                    row: row];
            
            [builder addTag: kTagCell attributes: cellAttributes text: cellText];
        }
        [builder addClosingTag: kTagRow];
    }
}

@end
