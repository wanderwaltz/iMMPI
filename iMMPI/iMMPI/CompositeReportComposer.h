//
//  CompositeReportComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzerReportComposer.h"

@interface CompositeReportComposer : NSObject<AnalyzerReportComposer>

- (instancetype)initWithChildComposers:(NSArray *)childReports separator:(NSString *)separator;

@end
