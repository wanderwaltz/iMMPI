//
//  Statement.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Statement interface

/*!
 A single statement of the Questionnaire.
 */
@interface Statement : NSObject

/// Text of the statement.
@property (copy, nonatomic) NSString *text;

/*! ID of the statement
 
 Statements are sorted by ID when presented to the user. ID is also
 used when analyzing test results.
 */
@property (assign, nonatomic) NSInteger statementID;

@end
