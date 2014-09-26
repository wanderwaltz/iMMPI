//
//  HtmlReportTagDecorator.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzerReportComposer.h"

@interface HtmlReportTagDecorator : NSObject<AnalyzerReportComposer>

- (instancetype)initWithTag:(NSString *)tag contentComposer:(id<AnalyzerReportComposer>)composer;

@end
