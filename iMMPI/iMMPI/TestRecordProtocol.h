//
//  TestRecordProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark TestRecord protocol

@protocol TestRecord<NSObject>
@required

@property (strong, nonatomic) id<Person>      person;
@property (strong, nonatomic) id<TestAnswers> testAnswers;

@end
