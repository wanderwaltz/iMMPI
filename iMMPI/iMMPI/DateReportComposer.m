//
//  DateReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "DateReportComposer.h"
#import "TestRecordProtocol.h"

@interface DateReportComposer()
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@end

@implementation DateReportComposer

- (instancetype)init
{
    return [self initWithDateFormatter: nil];
}

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    NSParameterAssert(dateFormatter != nil);
    if (!dateFormatter) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }

    _dateFormatter = dateFormatter;
    
    return self;
}


- (NSString *)composeReportForTestRecord:(id<TestRecordProtocol>)record
{
    return [self.dateFormatter stringFromDate: [record date]];
}

@end
