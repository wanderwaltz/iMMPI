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

typedef NS_ENUM(NSInteger, Gender) {
    GenderUnknown,
    GenderMale,
    GenderFemale
};


typedef NS_ENUM(NSInteger, AgeGroup) {
    AgeGroupUnknown,
    AgeGroupTeen,
    AgeGroupAdult
};


typedef NS_ENUM(NSInteger, AnswerType) {
    AnswerTypeUnknown,
    AnswerTypePositive,
    AnswerTypeNegative
};


#pragma mark -
#pragma mark protocols

#import "PersonProtocol.h"
#import "TestAnswersProtocol.h"
#import "TestRecordProtocol.h"
#import "QuestionnaireProtocol.h"
#import "AnalyzerGroup.h"
#import "AnalyzerProtocol.h"

#import "MutableTableViewModel.h"
#import "TestRecordStorageProtocol.h"

#pragma mark -
#pragma mark classes

#import "Questionnaire.h"

#import "TestRecord.h"
#import "Person.h"

#import "TestAnswers.h"
#import "Answer.h"

#import "Analyzer.h"

#import "JSONTestRecordSerialization.h"

#import "JSONTestRecordsStorage.h"

#import "TestRecordModelByDate.h"
#import "TestRecordModelGroupedByName.h"

#endif
