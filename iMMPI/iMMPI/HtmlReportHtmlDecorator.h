//
//  HtmlReportBodyComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 25.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzerReportComposer.h"

@interface HtmlReportHtmlDecorator : NSObject<AnalyzerReportComposer>
@property (nonatomic, copy) NSString *doctype;
@property (nonatomic, copy) NSString *meta;

- (instancetype)initWithContentComposer:(id<AnalyzerReportComposer>)composer;

@end
