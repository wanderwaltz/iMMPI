//
//  TestRecordProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark TestRecord protocol

@protocol PersonProtocol;

/*! Encapsulates information about a single test session.
 
 Test session consists of a person taking test, his/her answers for the test and the date of the test session.
 */
@protocol TestRecordProtocol<NSObject>
@required

/// Person who took the test
@property (strong, nonatomic) id<PersonProtocol> person;

/// Shortcut for self.person.name
@property (copy, readonly, nonatomic) NSString *personName;


/// Answers of the person
@property (strong, nonatomic) id<TestAnswersProtocol> testAnswers;


/// Date of the test session
@property (strong, nonatomic) NSDate *date;

@end

NS_ASSUME_NONNULL_END
