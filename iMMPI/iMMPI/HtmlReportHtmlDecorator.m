//
//  HtmlReportBodyComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 25.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "HtmlReportHtmlDecorator.h"

@interface HtmlReportHtmlDecorator()
@property (nonatomic, strong, readonly) id<AnalyzerReportComposer> childComposer;
@end

@implementation HtmlReportHtmlDecorator

- (instancetype)init
{
    return [self initWithContentComposer: nil];
}

- (instancetype)initWithContentComposer:(id<AnalyzerReportComposer>)composer
{
    NSParameterAssert(composer != nil);
    if (!composer) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _childComposer = composer;
    _doctype = @"<!DOCTYPE html>";
    _meta = @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";
    
    return self;
}

- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendString: self.doctype ?: @""];
    [html appendString: self.meta ?: @""];
    [html appendString: @"<html>"];
    
    NSString *content = [self.childComposer composeReportForTestRecord: record];
    
    if (content.length > 0) {
        [html appendString: content];
    }
    
    [html appendString: @"</html>"];
    
    return [html copy];
}

@end
