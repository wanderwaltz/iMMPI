//
//  Answer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

#pragma mark -
#pragma mark Answer interface

/*!
 A single answer in TestAnswers set.
 */
@interface Answer : NSObject

/// ID of Statement related to the answer
@property (assign, nonatomic) NSInteger  statementID;

/// Type of the answer
@property (assign, nonatomic) AnswerType answerType;

@end
