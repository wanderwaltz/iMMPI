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
                                                         options: 0
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
    }
    
    [statements sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"statementID" ascending: YES]]];
    
    self = [super init];
    
    if (self != nil)
    {
        _statements = [statements copy];
    }
    return self;
}


@end


#pragma mark -
#pragma mark Error messages

static id _logFileNameNil(Gender gender, AgeGroup ageGroup)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"no questionnaire file name found for the given gender/ageGroup combination.",
          gender, ageGroup);
    return nil;
}


static id _logFileNotFound(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"%@.%@ not found in the application bundle.",
          gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logFileCannotBeRead(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"%@.%@ cannot be read.",
          gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logErrorParsingJSON(Gender gender, AgeGroup ageGroup, NSString *fileName, NSError *error)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"failed to parse %@.%@ with error: %@.",
          gender, ageGroup, fileName, kQuestionnaireFilePathExtension, error);
    return nil;
}


static id _logRootObjectNotDictionary(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"expected root object of %@.%@ to be of dictionary class.",
          gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logStatementsNotFound(Gender gender, AgeGroup ageGroup, NSString *fileName)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"'%@' not found in root object of %@.%@.",
          gender, ageGroup, kJSONKey_Statements, fileName, kQuestionnaireFilePathExtension);
    return nil;
}


static id _logStatementsNotArray(Gender gender, AgeGroup ageGroup)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"expected '%@' to be of an array class.",
          gender, ageGroup, kJSONKey_Statements);
    return nil;
}


static id _logStatementNotDictionary(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"unexpected object '%@' in '%@' array.",
          gender, ageGroup, statement, kJSONKey_Statements);
    return nil;
}


static id _logStatementIDNotFound(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"statement '%@' does not have '%@' value.",
          gender, ageGroup, statement, kJSONKey_StatementID);
    return nil;
}


static id _logStatementTextNotFound(Gender gender, AgeGroup ageGroup, id statement)
{
    NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
          @"statement '%@' does not have '%@' value.",
          gender, ageGroup, statement, kJSONKey_StatementText);
    return nil;
}