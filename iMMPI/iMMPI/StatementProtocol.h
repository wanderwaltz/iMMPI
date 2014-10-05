//
//  StatementProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark Statement protocol

/*! A single statement of the questionnaire. 
 
 @see QuestionnaireProtocol
 */
@protocol StatementProtocol<NSObject>
@required


/*! ID of the statement
 
 ID is used when analyzing test results and querying an answer from TestAnswers object.
 */
@property (assign, nonatomic) NSInteger statementID;

/// Text of the statement.
@property (copy, nonatomic) NSString *text;

@end
