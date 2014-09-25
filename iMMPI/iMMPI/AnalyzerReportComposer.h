//
//  AnalyzerReportGeneratorProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 25.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestRecordProtocol;

@protocol AnalyzerReportComposer <NSObject>

- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record;

@end
