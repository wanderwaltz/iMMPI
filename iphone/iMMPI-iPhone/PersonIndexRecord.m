//
//  PersonIndexRecordData.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "PersonIndexRecord.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kFullNameKey = @"Full Name";

#pragma mark -
#pragma mark PersonIndexJsonData implementation

@implementation PersonIndexRecord

#pragma mark -
#pragma mark PersonIndexRecordProtocol

@synthesize sectionIdentifier = _sectionIdentifier;

- (NSString *) sectionIdentifier
{
    if (_sectionIdentifier == nil)
    {
        _sectionIdentifier = [self sectionIDFromString: [self fullName]];
    }
    return _sectionIdentifier;
}


- (NSString *) fullName
{
    return [_jsonData stringForKey: kFullNameKey];
}


- (void) setFullName: (NSString *) fullName
{
    [_jsonData setString: fullName 
                  forKey: kFullNameKey];
    
    _sectionIdentifier = [self sectionIDFromString: fullName];
}


#pragma mark -
#pragma mark Private

- (NSString *) sectionIDFromString: (NSString *) string
{
    if (string.length > 0)
    {
        NSString *candidate = [[string substringToIndex: 1] uppercaseString];
        
        if ([candidate rangeOfCharacterFromSet:
             [NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound)
            return candidate;
        else
            return @"#";
    }
    else
        return @"#";
}


#pragma mark -
#pragma mark intialization methods

+ (id) indexRecordForPerson: (Person *) person
{
    return [[[self class] alloc] initWithPerson: person];
}


- (id) initWithPerson: (Person *) person
{
    self = [super init];
    
    if (self != nil)
    {
        NSString *fullName = [person lastName];
        if ([person firstName].length > 0)
            fullName = [fullName stringByAppendingFormat: @" %@", [person firstName]];
        
        [self setFullName: fullName];
    }
    return self;
}


#pragma mark -
#pragma mark Methods

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@ %@", [super description], [self fullName]];
}

@end
