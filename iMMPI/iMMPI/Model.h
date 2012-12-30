//
//  Model.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef iMMPI_Model_h
#define iMMPI_Model_h

#import <Foundation/Foundation.h>


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
#pragma mark protocols

#import "PersonProtocol.h"
#import "TestAnswersProtocol.h"
#import "TestRecordProtocol.h"
#import "StatementProtocol.h"
#import "QuestionnaireProtocol.h"
#import "AnalyserGroup.h"
#import "AnalyserProtocol.h"

#import "MutableTableViewModel.h"
#import "TestRecordStorageProtocol.h"

#pragma mark -
#pragma mark classes

#import "Questionnaire.h"
#import "Statement.h"

#import "TestRecord.h"
#import "Person.h"

#import "TestAnswers.h"
#import "Answer.h"

#import "Analyser.h"

#import "JSONTestRecordSerialization.h"

#import "JSONTestRecordsStorage.h"

#import "TestRecordModelByDate.h"

#endif
