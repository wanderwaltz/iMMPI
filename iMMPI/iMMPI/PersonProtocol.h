//
//  Person.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Person protocol

/*! Encapsulates personal information of a person taking MMPI test.
 
 Gender and the age group are relevant for selecting a proper questionnaire for the person.
 */
@protocol Person<NSObject>
@required

/// Full name of a person
@property (strong, nonatomic) NSString *name;


/// Gender of a person
@property (assign, nonatomic) Gender gender;


/// Age group of a person
@property (assign, nonatomic) AgeGroup ageGroup;

@end

