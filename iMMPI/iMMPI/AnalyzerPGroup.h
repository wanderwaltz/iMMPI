//
//  AnalyzerPGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerGroupBase.h"


#pragma mark -
#pragma mark AnalyzerPGroup interface

@interface AnalyzerPGroup : AnalyzerGroupBase

- (NSArray *) bracketsForRecord: (id<TestRecordProtocol>) record;

@end
