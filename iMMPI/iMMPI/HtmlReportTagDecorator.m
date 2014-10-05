//
//  HtmlReportTagDecorator.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "HtmlReportTagDecorator.h"
#import "HtmlBuilder.h"

@interface HtmlReportTagDecorator()
@property (nonatomic, copy, readonly) NSString *tag;
@property (nonatomic, strong, readonly) id<HtmlBuilder> htmlBuilder;
@property (nonatomic, strong, readonly) id<AnalyzerReportComposer> childComposer;
@end

@implementation HtmlReportTagDecorator

- (instancetype)init
{
    return [self initWithTag: nil htmlBuilder: nil contentComposer: nil];
}


- (instancetype)initWithTag:(NSString *)tag
                    htmlBuilder:(id<HtmlBuilder>)htmlBuilder
                    contentComposer:(id<AnalyzerReportComposer>)composer
{
    NSParameterAssert(composer != nil);
    NSParameterAssert(htmlBuilder != nil);
    NSParameterAssert(tag != nil);
    NSParameterAssert(tag.length > 0);
    if ((tag.length == 0) || !composer || !htmlBuilder) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _tag = [tag copy];
    _htmlBuilder = htmlBuilder;
    _childComposer = composer;
    
    return self;
}


- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    [self.htmlBuilder open];
    
    NSString *content = [self.childComposer composeReportForTestRecord: record];

    [self.htmlBuilder addTag: self.tag attributes: nil text: content];
    
    return [self.htmlBuilder close];
}

@end
