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

- (void) setLastName: (NSString *) lastName
{
    [self willChangeValueForKey: @"lastName"];
    [self setPrimitiveValue: lastName forKey: @"lastName"];
    [self didChangeValueForKey:  @"lastName"];
    
    [self setPrimitiveValue: nil forKey: @"nameSectionID"];
}


#pragma mark -
#pragma mark transient properties

- (NSString *) nameSectionID
{
    [self willAccessValueForKey: @"nameSectionID"];
    
    NSString *letter = [self primitiveValueForKey: @"nameSectionID"];
    
    [self didAccessValueForKey: @"nameSectionID"];
    
    if (letter == nil)
    {
        letter = [self primitiveValueForKey: @"lastName"];
        
        if (letter.length > 0)
        {
            NSRange range = [letter rangeOfComposedCharacterSequenceAtIndex: 0];
            letter = [letter substringWithRange: range];
            letter = [letter uppercaseString];
        }
        
        if ([letter rangeOfCharacterFromSet:
             [NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
        {
            letter = @"#";
        }
        
        [self setPrimitiveValue: letter forKey: @"nameSectionID"];
    }
    
    return letter;
}


#pragma mark -
#pragma mark custom properties

- (NSString *) fullName
{
    NSMutableArray *names = [NSMutableArray arrayWithCapacity: 3];
    
    if (self.firstName.length > 0)      [names addObject: self.firstName];
    if (self.patronymicName.length > 0) [names addObject: self.patronymicName];
    if (self.lastName.length > 0)       [names addObject: self.lastName];
    
    return [names componentsJoinedByString: @" "];
}


- (NSString *) fullFirstName
{
    NSMutableArray *names = [NSMutableArray arrayWithCapacity: 3];
    
    if (self.firstName.length > 0)      [names addObject: self.firstName];
    if (self.patronymicName.length > 0) [names addObject: self.patronymicName];
    
    return [names componentsJoinedByString: @" "];
}


#pragma mark -
#pragma mark KV-dependencies

+ (NSSet *) keyPathsForValuesAffectingNameSectionID
{
    return [NSSet setWithObject: @"lastName"];
}


@end
