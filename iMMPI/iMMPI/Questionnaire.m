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

static NSDictionary *QuestinnaireFileNames = nil;


#pragma mark -
#pragma mark Questionnaire interface

@implementation Questionnaire

#pragma mark -
#pragma mark class initialization

+ (void) initialize
{
    QuestinnaireFileNames =
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
    self = [super init];
    
    if (self != nil)
    {
        //NSString *fileName = (QuestinnaireFileNames[@()])[@()];
    }
    return self;
}


@end
