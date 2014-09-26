//
//  CompositeReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "CompositeReportComposer.h"

@interface CompositeReportComposer()
@property (nonatomic, strong, readonly) NSArray *childReports;
@property (nonatomic, strong, readonly) NSString *separator;
@end

@implementation CompositeReportComposer

- (instancetype)init
{
    return [self initWithChildComposers: nil separator: nil];
}

- (instancetype)initWithChildComposers:(NSArray *)childReports
                             separator:(NSString *)separator
{
    NSParameterAssert(childReports.count > 0);
    NSArray *conformingReports = [childReports filter:^BOOL(id item) {
        return [item conformsToProtocol: @protocol(AnalyzerReportComposer)];
    }];
    NSParameterAssert(childReports.count == conformingReports.count);
    
    if ((childReports.count == 0) || (childReports.count != conformingReports.count)) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _childReports = [childReports copy];
    _separator = [separator copy] ?: @"";
    
    return self;
}


- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    NSArray *components = [self.childReports map:^NSString *(id<AnalyzerReportComposer> childComposer) {
        return [childComposer composeReportForTestRecord: record];
    }];
    
    return [components componentsJoinedByString: self.separator];
}

@end
