//
//  Person.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Person.h"

#pragma mark -
#pragma mark Person implementation

@implementation Person

#pragma mark -
#pragma mark attributes

@dynamic firstName;
@dynamic lastName;
@dynamic patronymicName;
@dynamic birthDate;

@end
