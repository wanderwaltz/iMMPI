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

#import "TestRecordStorageProtocol.h"

#pragma mark -
#pragma mark classes

#import "JSONTestRecordsStorage.h"

#endif
