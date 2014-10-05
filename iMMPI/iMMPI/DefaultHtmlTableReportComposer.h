//
//  DefaultHtmlTableReportComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HtmlTableReportComposer.h"

@protocol HtmlBuilder;

@interface DefaultHtmlTableReportComposer : NSObject<HtmlTableReportComposer>

- (instancetype)initWithHtmlBuilder:(id<HtmlBuilder>)htmlBuilder;

@end
