//
//  PersonNameReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "PersonNameReportComposer.h"
#import "TestRecordProtocol.h"

@implementation PersonNameReportComposer

- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    return [record personName];
}

@end
