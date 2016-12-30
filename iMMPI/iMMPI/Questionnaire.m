//
//  Questionnaire.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Questionnaire.h"

#pragma mark -
#pragma mark Static globals

static NSDictionary *kQuestinnaireFileNames = nil;

static NSString * const kQuestionnaireFilePathExtension = @"json";

static NSString * const kJSONKey_Statements    = @"statements";
static NSString * const kJSONKey_StatementID   = @"id";
static NSString * const kJSONKey_StatementText = @"text";


#pragma mark -
#pragma mark Static error message functions

/* All these functions log a message to the debug console and return nil (returning nil is necessary to be able to use these functions in return statements).
 */
static id _logFileNameNil            (Gender gender, AgeGroup ageGroup);
static id _logFileNotFound           (Gender gender, AgeGroup ageGroup, NSString *fileName);
static id _logFileCannotBeRead       (Gender gender, AgeGroup ageGroup, NSString *fileName);
static id _logErrorParsingJSON       (Gender gender, AgeGroup ageGroup, NSString *fileName, NSError *error);
static id _logRootObjectNotDictionary(Gender gender, AgeGroup ageGroup, NSString *fileName);
static id _logStatementsNotFound     (Gender gender, AgeGroup ageGroup, NSString *fileName);
static id _logStatementsNotArray     (Gender gender, AgeGroup ageGroup);
static id _logStatementNotDictionary (Gender gender, AgeGroup ageGroup, id statement);
static id _logStatementIDNotFound    (Gender gender, AgeGroup ageGroup, id statement);
static id _logStatementTextNotFound  (Gender gender, AgeGroup ageGroup, id statement);


#pragma mark -
#pragma mark Questionnaire private

@interface Questionnaire()
{
    NSArray *_statements;
    NSDictionary *_statementsByID;
}

@end


#pragma mark -
#pragma mark Questionnaire interface

@implementation Questionnaire

#pragma mark -
#pragma mark class initialization

+ (void) initialize
{
    kQuestinnaireFileNames =
    @{
    
        @(GenderMale) :
        @{
            @(AgeGroupAdult) : @"mmpi.male.adult",
            @(AgeGroupTeen)  : @"mmpi.male.teen"
        },
    
        @(GenderFemale) :
        @{
            @(AgeGroupAdult) : @"mmpi.female.adult",
            @(AgeGroupTeen)  : @"mmpi.female.teen"
        }
    };
}


#pragma mark -
#pragma mark initialization methods

+ (id) newForGender: (Gender) gender
           ageGroup: (AgeGroup) ageGroup
{
    return [[self alloc] initWithGender: gender
                               ageGroup: ageGroup];
}

- (id) initWithGender: (Gender)   gender
             ageGroup: (AgeGroup) ageGroup
{
    NSString *fileName = (kQuestinnaireFileNames[@(gender)])[@(ageGroup)];
    if (fileName.length == 0)
        return _logFileNameNil(gender, ageGroup);
    

    
    NSString *path = [[NSBundle mainBundle] pathForResource: fileName
                                                     ofType: kQuestionnaireFilePathExtension];
    if (path.length == 0)
        return _logFileNotFound(gender, ageGroup, fileName);
    
    
    
    NSData *jsonData = [NSData dataWithContentsOfFile: path];
    if (jsonData == nil)
        return _logFileCannotBeRead(gender, ageGroup, fileName);
    
    
    
    NSError     *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: jsonData
                                                         options: (NSJSONReadingOptions)0
                                                           error: &error];
    if (json == nil)
        return _logErrorParsingJSON(gender, ageGroup, fileName, error);
    
    if (![json isKindOfClass: [NSDictionary class]])
        return _logRootObjectNotDictionary(gender, ageGroup, fileName);
    
    
    
    
    NSArray *jsonStatements = json[kJSONKey_Statements];
    if (jsonStatements == nil)
        return _logStatementsNotFound(gender, ageGroup, fileName);
    
    if (![jsonStatements isKindOfClass: [NSArray class]])
        return _logStatementsNotArray(gender, ageGroup);
    
    
        
    NSMutableArray *statements = [NSMutableArray arrayWithCapacity: jsonStatements.count];
    NSMutableDictionary *statementsByID = [NSMutableDictionary dictionaryWithCapacity: jsonStatements.count];
    
    for (NSDictionary *jsonStatement in jsonStatements)
    {
        if (![jsonStatement isKindOfClass: [NSDictionary class]])
            return _logStatementNotDictionary(gender, ageGroup, jsonStatement);
        
        
        id statementID   = jsonStatement[kJSONKey_StatementID];
        id statementText = jsonStatement[kJSONKey_StatementText];
        
        if (statementID == nil)
            return _logStatementIDNotFound(gender, ageGroup, jsonStatement);
        
        if (![statementText isKindOfClass: [NSString class]])
            return _logStatementTextNotFound(gender, ageGroup, jsonStatement);
        
        
        Statement *statement  = [Statement new];
        statement.text        = statementText;
        statement.statementID = [statementID intValue];
        
        [statements addObject: statement];
        statementsByID[@(statement.statementID)] = statement;
    }
    
    [statements sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"statementID" ascending: YES]]];
    
    self = [super init];
    
    if (self != nil)
    {
        _statements     = [statements     copy];
        _statementsByID = [statementsByID copy];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (NSUInteger) statementsCount
{
    return _statements.count;
}


- (id<StatementProtocol>) statementAtIndex: (NSUInteger) index
{
    if (index < _statements.count) {
        return _statements[index];
    }
    else {
        return nil;
    }
}

- (id<StatementProtocol>) statementWithID: (NSUInteger) statementID
{
    return _statementsByID[@(statementID)];
}

@end


#pragma mark -
#pragma mark Error messages

static id _logFileNameNil(Gender gender, AgeGroup ageGroup)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"no questionnaire file name found for the given gender/ageGroup combination.",
          (long)gender, (long)ageGroup);
    return nil;
}


static id _logFileNotFound(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"%@.%@ not found in the application bundle.",
          (long)gender, (long)ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logFileCannotBeRead(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"%@.%@ cannot be read.",
          (long)gender, (long)ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logErrorParsingJSON(Gender gender, AgeGroup ageGroup, NSString *fileName, NSError *error)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"failed to parse %@.%@ with error: %@.",
          (long)gender, (long)ageGroup, fileName, kQuestionnaireFilePathExtension, error);
    return nil;
}


static id _logRootObjectNotDictionary(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"expected root object of %@.%@ to be of dictionary class.",
          (long)gender, (long)ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logStatementsNotFound(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"'%@' not found in root object of %@.%@.",
          (long)gender, (long)ageGroup, kJSONKey_Statements, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logStatementsNotArray(Gender gender, AgeGroup ageGroup)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"expected '%@' to be of an array class.",
          (long)gender, (long)ageGroup, kJSONKey_Statements);
    return nil;
}


static id _logStatementNotDictionary(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"unexpected object '%@' in '%@' array.",
          (long)gender, (long)ageGroup, statement, kJSONKey_Statements);
    return nil;
}


static id _logStatementIDNotFound(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"statement '%@' does not have '%@' value.",
          (long)gender, (long)ageGroup, statement, kJSONKey_StatementID);
    return nil;
}


static id _logStatementTextNotFound(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %ld and ageGroup %ld: "
          @"statement '%@' does not have '%@' value.",
          (long)gender, (long)ageGroup, statement, kJSONKey_StatementText);
    return nil;
}
