//
//  JSONTestRecordSerialization.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JSONTestRecordSerialization.h"


#pragma mark -
#pragma mark Static constatnts

static NSString * const kJSONKeyVersion         = @"version";
static NSString * const kJSONKeyName            = @"name";
static NSString * const kJSONKeyGender          = @"gender";
static NSString * const kJSONKeyAgeGroup        = @"ageGroup";
static NSString * const kJSONKeyDate            = @"date";
static NSString * const kJSONKeyAnswers         = @"answers";
static NSString * const kJSONKeyStatemet        = @"statement";
static NSString * const kJSONKeyStatementID     = @"id";
static NSString * const kJSONKeyStatementAnswer = @"answer";

static NSString * const kJSONValueGenderMale   = @"male";
static NSString * const kJSONValueGenderFemale = @"female";

static NSString * const kJSONValueAgeGroupAdult = @"adult";
static NSString * const kJSONValueAgeGroupTeen  = @"teen";

static NSString * const kJSONValueUnknown = @"unknown";


#pragma mark -
#pragma mark JSONTestRecordSerialization implementation

@implementation JSONTestRecordSerialization

#pragma mark -
#pragma mark methods

+ (NSData *) dataWithTestRecord: (id<TestRecord>) testRecord
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    json[kJSONKeyVersion]  = [self version];
    json[kJSONKeyName]     = nil2Null(testRecord.person.name);
    json[kJSONKeyGender]   = nil2Null([self   encodeGender: testRecord.person.gender]);
    json[kJSONKeyAgeGroup] = nil2Null([self encodeAgeGroup: testRecord.person.ageGroup]);
    json[kJSONKeyDate]     = nil2Null([[self dateFormatter] stringFromDate: testRecord.date]);
    
    NSError *error = nil;
    NSData  *data  = [NSJSONSerialization dataWithJSONObject: json
                                                     options: NSJSONWritingPrettyPrinted
                                                       error: &error];
    return data;
}


+ (id<TestRecord>) testRecordFromData: (NSData *) data
{
    id<TestRecord> record     = nil;
    NSError       *error      = nil;
    NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData: data
                                                                options: 0
                                                                  error: &error];
    
    if ([dictionary isKindOfClass: [NSDictionary class]])
    {
        record = [TestRecord new];
        
        record.person.name     = null2Nil(dictionary[kJSONKeyName]);
        record.person.gender   = [self   decodeGender: dictionary[kJSONKeyGender]];
        record.person.ageGroup = [self decodeAgeGroup: dictionary[kJSONKeyAgeGroup]];
        record.date            = [[self dateFormatter] dateFromString: null2Nil(
                                                                                dictionary[kJSONKeyDate])];
    }
    
    return record;
}


+ (NSString *) version
{
    return @"1.0";
}


#pragma mark -
#pragma mark private

+ (id) encodeGender: (Gender) gender
{
    switch (gender)
    {
        case GenderFemale:  return kJSONValueGenderFemale; break;
        case GenderMale:    return kJSONValueGenderMale;   break;
        case GenderUnknown: return kJSONValueUnknown;      break;
    }
}


+ (Gender) decodeGender: (id) genderJSON
{
    genderJSON = null2Nil(genderJSON);
    
    if ([genderJSON isKindOfClass: [NSString class]])
    {
        if ([genderJSON isEqualToString: kJSONValueGenderMale])
            return GenderMale;
        
        else if ([genderJSON isEqualToString: kJSONValueGenderFemale])
            return GenderFemale;
        
        else
            return GenderUnknown;
    }
    else return GenderUnknown;
}


+ (id) encodeAgeGroup: (AgeGroup) ageGroup
{
    switch (ageGroup)
    {
        case AgeGroupAdult:   return kJSONValueAgeGroupAdult; break;
        case AgeGroupTeen:    return kJSONValueAgeGroupTeen;  break;
        case AgeGroupUnknown: return kJSONValueUnknown;       break;
    }
}


+ (AgeGroup) decodeAgeGroup: (id) ageGroupJSON
{
    ageGroupJSON = null2Nil(ageGroupJSON);
    
    if ([ageGroupJSON isKindOfClass: [NSString class]])
    {
        if ([ageGroupJSON isEqualToString: kJSONValueAgeGroupAdult])
            return AgeGroupAdult;
        
        else if ([ageGroupJSON isEqualToString: kJSONValueAgeGroupTeen])
            return AgeGroupTeen;
        
        else
            return AgeGroupUnknown;
    }
    else return AgeGroupUnknown;
}


+ (NSDateFormatter *) dateFormatter
{
    static dispatch_once_t predicate = 0;
    __strong static NSDateFormatter *formatter = nil;
    
    dispatch_once(&predicate,
                  ^{
                      formatter = [NSDateFormatter new];
                      formatter.dateStyle = NSDateFormatterMediumStyle;
                      formatter.timeStyle = NSDateFormatterNoStyle;
                  });
    
    return formatter;
}


@end
