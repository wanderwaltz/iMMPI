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

@protocol Person<NSObject>
@required

@property (strong, nonatomic) NSString    *name;
@property (assign, nonatomic) Gender     gender;
@property (assign, nonatomic) AgeGroup ageGroup;

@end

