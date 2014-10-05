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

- (NSString *)composeReport
{
    id<HtmlBuilder> builder = self.htmlBuilder;
    [builder open];
    
    NSDictionary *tableAttributes = [self.dataSource tableAttributesForHtmlTableReportComposer: self];
    [builder addOpeningTag: kTagTable attributes: tableAttributes];
    
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsInHtmlTableReportComposer: self];
    
    { // Building colgroups
        [builder addOpeningTag: kTagColgroup attributes: nil];
        
        for (NSInteger column = 0; column < numberOfColumns; ++column) {
            NSDictionary *columnAttributes =
                [self.dataSource tableReportComposer: self attributesForColumn: column];
            
            [builder addTag: kTagCol attributes: columnAttributes text: nil];
        }
        
        [builder addClosingTag: kTagColgroup];
    }
    
    
    { // Building table header
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
    
    
    [builder addClosingTag: kTagTable];
    
    return [builder close];
}

@end
