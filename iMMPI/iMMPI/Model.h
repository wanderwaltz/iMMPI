//
//  Model.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef iMMPI_Model_h
#define iMMPI_Model_h

#import "Questionnaire.h"
#import "Statement.h"

#pragma mark -
#pragma mark Typedefs

typedef enum
{
    GenderMale,
    GenderFemale,
    GenderUnknown,
} Gender;


typedef enum
{
    AgeGroupTeen,
    AgeGroupAdult,
    AgeGroupUnknown
} AgeGroup;

#endif
