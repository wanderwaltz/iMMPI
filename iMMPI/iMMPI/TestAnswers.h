//
//  TestAnswers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"
#import "Answer.h"


#pragma mark -
#pragma mark TestAnswers interface

/*!
 Encapsulates a mutable set of Answer objects.
 */
@interface TestAnswers : NSObject<TestAnswersProtocol>

/*! Sets an AnswerType for a statement with a given ID
 
 @param answerType  answer type (agree, disagree, undefined - see source for the exact enum values)
 @param statementID ID of the statement to relate the answer with
 */
- (void) setAnswerType: (AnswerType) answerType
        forStatementID: (NSInteger) statementID;


/*! Returns answer type for statement with the provided ID

 @param statementID ID of the statement related to the answer
 
 @return AnswerType for a recorded answer. If the statement has not yet been answered, returns AnswerTypeUnknown.
 */
- (AnswerType) answerTypeForStatementID: (NSInteger) statementID;



/*! This method enumerates all answers with type != AnswerTypeUnknown.
 
 Ordering of the enumerating answers is undefined.
 
 @param block Block to be called on each answer/statementID pair where answer != AnswerTypeUnknown
 */
- (void) enumerateAnswers: (void(^)(NSInteger statementID, AnswerType answer)) block;

@end
