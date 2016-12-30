//
//  QuestionnaireProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Questionnaire protocol

@protocol StatementProtocol;

NS_ASSUME_NONNULL_BEGIN
/*!
 QuestionnaireProtocol encapsulates an ordered array of MMPI test statements.
 
 Actual ordering depends on the implementation and is relevant only for presenting the statements list to the end-user. This ordering does not have any semantic meaning.
 */
@protocol QuestionnaireProtocol<NSObject>
@required

/// This method should return number of statements included in the certain questionnaire.
- (NSUInteger) statementsCount;


/*! This method should return a statement with a given index.
 
 @return For each index starting from 0 to statementsCount this method is expected to return an object conforming to Statement protocol. The return value is undefined for indexes outside of this range.
 
 @param index Index of statement to return.
 */
- (id<StatementProtocol> _Nullable) statementAtIndex: (NSUInteger) index;

- (id<StatementProtocol> _Nullable) statementWithID: (NSUInteger) statementID;

@end
NS_ASSUME_NONNULL_END
