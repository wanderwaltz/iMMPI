//
//  Questionnaire.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.11.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


#pragma mark -
#pragma mark Questionnaire interface

@interface Questionnaire : NSObject

+ (id) newForGender: (Gender) gender
           ageGroup: (AgeGroup) ageGroup;

- (id) initWithGender: (Gender)   gender
             ageGroup: (AgeGroup) ageGroup;

@end
