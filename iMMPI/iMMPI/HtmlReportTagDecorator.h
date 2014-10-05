//
//  HtmlReportTagDecorator.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzerReportComposer.h"

@protocol HtmlBuilder;

@interface HtmlReportTagDecorator : NSObject<AnalyzerReportComposer>

- (instancetype)initWithTag:(NSString *)tag
                    htmlBuilder:(id<HtmlBuilder>)htmlBuilder
                    contentComposer:(id<AnalyzerReportComposer>)composer;

@end
