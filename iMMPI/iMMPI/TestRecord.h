//
//  TestRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"
#import "TestAnswers.h"


#pragma mark -
#pragma mark TestRecord interface

/*! A concrete implementation of TestRecord protocol.
 */
@interface TestRecord : NSObject<TestRecord>

@property (strong, nonatomic) id<Person> person;
@property (strong, nonatomic) id<TestAnswers> testAnswers;

@property (strong, nonatomic) NSDate *date;

@end
