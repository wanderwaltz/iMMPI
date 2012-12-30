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

/*! Encapsulates information about a single test session.
 
 Test session consists of a person taking test, his/her answers for the test and the date of the test session.
 */
@protocol TestRecordProtocol<NSObject>
@required

/// Person who took the test
@property (strong, nonatomic) id<PersonProtocol> person;


/// Answers of the person
@property (strong, nonatomic) id<TestAnswersProtocol> testAnswers;


/// Date of the test session
@property (strong, nonatomic) NSDate *date;

@end
