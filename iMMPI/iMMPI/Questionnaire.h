//
//  Questionnaire.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"
#import "QuestionnaireProtocol.h"
#import "Statement.h"


#pragma mark -
#pragma mark Questionnaire interface

/*! 
 Questionnaire class encapsulates an ordered array of MMPI test statements.
 
 Questionnaries are stored in json format in the application bundle. There are separate sets of questions depending on the gender and age group of the person, and these are stored in separate files.
 */
@interface Questionnaire : NSObject<QuestionnaireProtocol>

/*! 
 A class method for creating Questionnarie objects.
 
 @see -initWithGender:ageGroup:
 
 @param gender    Gender value of the Questionnaire
 @param ageGroup  Age group value of the Questionnaire
 */
+ (id) newForGender: (Gender) gender
           ageGroup: (AgeGroup) ageGroup;


/*! 
 Initializes a Questionnarie object with the gender and age group values.
 
 This method does load and parse the json file corresponding the provided gender and age group values. If something goes wrong while loading data, returns nil and posts a log message to the debugger console.
 
 @param gender    Gender value of the Questionnaire
 @param ageGroup  Age group value of the Questionnaire
 */
- (id) initWithGender: (Gender)   gender
             ageGroup: (AgeGroup) ageGroup;

/// Returns the number of statements included in the questionnaire.
- (NSUInteger) statementsCount;


/*! This method return a statement with a given index.
 
 @return For each index starting from 0 to statementsCount this method is expected to return an object conforming to StatementProtocol. If index is outside of this range, an out of range exception is raised.
 
 @param index Index of statement to return.
 */
- (id<StatementProtocol>) statementAtIndex: (NSUInteger) index;

@end
