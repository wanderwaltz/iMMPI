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

/*! A concrete implementation of TestRecordProtocol.
 
 Initializing this class instance with -init method will also create a Person object and set it as the person property value. testAnswers property will be initialized with empty TestAnswers object; date property defaults to the current date/time.
 */
@interface TestRecord : NSObject<TestRecordProtocol>

@property (strong, nonatomic) id<PersonProtocol> person;
@property (strong, nonatomic) id<TestAnswersProtocol> testAnswers;

@property (strong, nonatomic) NSDate *date;

@end
