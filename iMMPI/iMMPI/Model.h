//
//  Model.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef iMMPI_Model_h
#define iMMPI_Model_h

#pragma mark -
#pragma mark Typedefs

typedef enum : NSInteger
{
    GenderUnknown,
    GenderMale,
    GenderFemale
} Gender;


typedef enum : NSInteger
{
    AgeGroupUnknown,
    AgeGroupTeen,
    AgeGroupAdult
} AgeGroup;


typedef enum : NSInteger
{
    AnswerTypeUnknown,
    AnswerTypePositive,
    AnswerTypeNegative
} AnswerType;


#pragma mark -
#pragma mark imports

#import <Foundation/Foundation.h>

#import "Questionnaire.h"
#import "Statement.h"

#import "TestAnswers.h"
#import "Answer.h"


#endif
