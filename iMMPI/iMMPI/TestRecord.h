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
 
 Initializing this class instance with -init method will also create a Person object and set it as the person property value. Note that testAnswers will not be created by default, and this property value will be nil; date property defaults to the current date/time.
 */
@interface TestRecord : NSObject<TestRecord>

@property (strong, nonatomic) id<Person> person;
@property (strong, nonatomic) id<TestAnswers> testAnswers;

@property (strong, nonatomic) NSDate *date;

@end
