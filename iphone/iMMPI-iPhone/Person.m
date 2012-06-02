//
//  PersonRecordData.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Person.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kFirstNameJsonKey = @"First Name";
static NSString * const kLastNameJsonKey  =  @"Last Name";
static NSString * const kBirthDateJsonKey = @"Birth Date";

#pragma mark -
#pragma mark Person implementation

@implementation Person

- (NSString *) firstName
{
    return [_jsonData stringForKey: kFirstNameJsonKey];
}


- (void) setFirstName: (NSString *) firstName
{
    [_jsonData setString: firstName 
                  forKey: kFirstNameJsonKey];
}


- (NSString *) lastName
{
    return [_jsonData stringForKey: kLastNameJsonKey];
}


- (void) setLastName: (NSString *) lastName
{
    [_jsonData setString: lastName 
                  forKey: kLastNameJsonKey];
}


- (NSDate *) birthDate
{
    return [_jsonData dateForKey: kBirthDateJsonKey];
}


- (void) setBirthDate: (NSDate *) birthDate
{
    [_jsonData setDate: birthDate 
                forKey: kBirthDateJsonKey];
}

@end
