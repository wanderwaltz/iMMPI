//
//  HtmlReportTagDecorator.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "HtmlReportTagDecorator.h"

@interface HtmlReportTagDecorator()
@property (nonatomic, copy, readonly) NSString *tag;
@property (nonatomic, strong, readonly) id<AnalyzerReportComposer> childComposer;
@end

@implementation HtmlReportTagDecorator

- (instancetype)init
{
    return [self initWithTag: nil contentComposer: nil];
}


- (instancetype)initWithTag:(NSString *)tag contentComposer:(id<AnalyzerReportComposer>)composer
{
    NSParameterAssert(composer != nil);
    NSParameterAssert(tag.length > 0);
    if ((tag.length == 0) || !composer) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _tag = [tag copy];
    _childComposer = composer;
    
    return self;
}


- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendFormat: @"<%@>", self.tag];

    NSString *content = [self.childComposer composeReportForTestRecord: record];
    if (content.length > 0) {
        [html appendString: content];
    }
    
    [html appendFormat: @"</%@>", self.tag];
    
    return [html copy];
}

@end
