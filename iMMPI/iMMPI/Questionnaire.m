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


#pragma mark -
#pragma mark Questionnaire private

@interface Questionnaire()
{
    NSDictionary *_json;
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
    {
        NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
              @"no questionnaire file name found for the given gender/ageGroup combination.",
              gender, ageGroup);
        return nil;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource: fileName
                                                     ofType: kQuestionnaireFilePathExtension];
    
    if (path.length == 0)
    {
        NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
              @"%@.%@ not found in the application bundle.",
              gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
        return nil;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile: path];
    
    if (jsonData == nil)
    {
        NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
              @"%@.%@ cannot be read.",
              gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
        return nil;
    }
    
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: jsonData
                                                         options: 0
                                                           error: &error];
    
    if (json == nil)
    {
        NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
              @"failed to parse %@.%@ with error: %@.",
              gender, ageGroup, fileName, kQuestionnaireFilePathExtension, error);
        return nil;
    }
    
    
    if (![json isKindOfClass: [NSDictionary class]])
    {
        NSLog(@"Failed to create Questionnaire object with gender %d and ageGroup %d: "
              @"expected root object of %@.%@ to be of dictionary class.",
              gender, ageGroup, fileName, kQuestionnaireFilePathExtension);
        return nil;
    }
    
    
    self = [super init];
    
    if (self != nil)
    {
        _json = json;
    }
    return self;
}


@end
