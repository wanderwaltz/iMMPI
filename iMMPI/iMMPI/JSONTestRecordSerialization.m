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

static NSString * const kJSONKeyFileName        = @"fileName";
static NSString * const kJSONKeyDirectory       = @"directory";



static NSString * const kJSONValueGenderMale   = @"male";
static NSString * const kJSONValueGenderFemale = @"female";

static NSString * const kJSONValueAgeGroupAdult = @"adult";
static NSString * const kJSONValueAgeGroupTeen  = @"teen";

static NSString * const kJSONValueUnknown = @"unknown";

static NSString * const kJSONValueAnswerTypePositive = @"YES";
static NSString * const kJSONValueAnswerTypeNegative = @"NO";


#pragma mark -
#pragma mark JSONTestRecordSerialization implementation

@implementation JSONTestRecordSerialization

#pragma mark -
#pragma mark methods

+ (NSData *) dataWithTestRecord: (id<TestRecordProtocol>) testRecord
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    json[kJSONKeyVersion]  = [self version];
    json[kJSONKeyName]     = nil2Null(testRecord.person.name);
    json[kJSONKeyGender]   = nil2Null([self   encodeGender: testRecord.person.gender]);
    json[kJSONKeyAgeGroup] = nil2Null([self encodeAgeGroup: testRecord.person.ageGroup]);
    json[kJSONKeyDate]     = nil2Null([[self dateFormatter] stringFromDate: testRecord.date]);
    
    NSMutableArray *answers = [NSMutableArray array];
    
    json[kJSONKeyAnswers] = answers;
    
    [testRecord.testAnswers enumerateAnswers:
     ^(NSInteger statementID, AnswerType answer) {
         [answers addObject: @{
       kJSONKeyStatementID : @(statementID),
    kJSONKeyStatementAnswer: [self encodeAnswerType: answer]
          }];
     }];
    
    NSError *error = nil;
    NSData  *data  = [NSJSONSerialization dataWithJSONObject: json
                                                     options: NSJSONWritingPrettyPrinted
                                                       error: &error];
    return data;
}


+ (id<TestRecordProtocol>) testRecordFromData: (NSData *) data
{
    id<TestRecordProtocol> record     = nil;
    NSError       *error      = nil;
    NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData: data
                                                                options: (NSJSONReadingOptions)0
                                                                  error: &error];
    
    if ([dictionary isKindOfClass: [NSDictionary class]])
    {
        record = [TestRecord new];
        
        record.person.name     = dictionary[kJSONKeyName] ?: @"";
        record.person.gender   = [self   decodeGender: dictionary[kJSONKeyGender]];
        record.person.ageGroup = [self decodeAgeGroup: dictionary[kJSONKeyAgeGroup]];
        record.date            = [[self dateFormatter] dateFromString: dictionary[kJSONKeyDate] ?: @""] ?: [NSDate date];
        
        NSArray *answers = dictionary[kJSONKeyAnswers];
        
        if ((answers != nil) && [answers isKindOfClass: [NSArray class]])
        {
            for (NSDictionary *answer in answers)
            {
                if ([answer isKindOfClass: [NSDictionary class]])
                {
                    id statementIDJSON = answer[kJSONKeyStatementID];
                    
                    if ([statementIDJSON isKindOfClass: [NSNumber class]])
                    {
                        [record.testAnswers setAnswerType: [self decodeAnswerType: answer[kJSONKeyStatementAnswer]]
                                           forStatementID: [statementIDJSON integerValue]];
                    }
                }
            }
        }
    }
    
    return record;
}


+ (NSString *) version
{
    return @"1.0";
}


+ (NSData  *) indexDataForRecordProxies: (NSArray *) recordProxies
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (JSONTestRecordProxy *proxy in recordProxies)
    {
        NSParameterAssert([proxy isKindOfClass: [JSONTestRecordProxy class]]);
        NSParameterAssert(proxy.fileName.length   > 0);
        NSParameterAssert(proxy.directory.length  > 0);
        NSParameterAssert(proxy.personName.length > 0);
        NSParameterAssert(proxy.date != nil);
        
        [array addObject:
         @{
           kJSONKeyName      : nil2Null(proxy.personName),
           kJSONKeyFileName  : nil2Null(proxy.fileName),
           kJSONKeyDirectory : nil2Null(proxy.directory),
           kJSONKeyDate      : nil2Null([[self dateFormatter] stringFromDate: proxy.date])
           }];
    }
    
    NSError *error = nil;
    NSData  *data  = [NSJSONSerialization dataWithJSONObject: array
                                                     options: NSJSONWritingPrettyPrinted
                                                       error: &error];
    return data;
}


+ (NSArray *) recordProxiesFromIndexData: (NSData  *) data
{
    NSMutableArray *proxies     = [NSMutableArray array];
    NSError        *error       = nil;
    NSArray        *jsonProxies = [NSJSONSerialization JSONObjectWithData: data
                                                                  options: (NSJSONReadingOptions)0
                                                                    error: &error];
    
    for (NSDictionary *dictionary in jsonProxies)
    {
        JSONTestRecordProxy *proxy =
            [[JSONTestRecordProxy alloc] initWithFileName: null2Nil(dictionary[kJSONKeyFileName])
                                                directory: null2Nil(dictionary[kJSONKeyDirectory])];
        
        proxy.personName = null2Nil(dictionary[kJSONKeyName]);
        proxy.date       = [[self dateFormatter] dateFromString: dictionary[kJSONKeyDate] ?: @""] ?: [NSDate date];
        
        NSParameterAssert(proxy.personName.length > 0);
        NSParameterAssert(proxy.fileName.length   > 0);
        NSParameterAssert(proxy.directory.length  > 0);
        NSParameterAssert(proxy.date != nil);

        [proxies addObject: proxy];
    }
    
    return proxies;
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


+ (id) encodeAnswerType: (AnswerType) answerType
{
    switch (answerType)
    {
        case AnswerTypePositive: return kJSONValueAnswerTypePositive; break;
        case AnswerTypeNegative: return kJSONValueAnswerTypeNegative; break;
        case AnswerTypeUnknown:  return kJSONValueUnknown;            break;
    }
}


+ (AnswerType) decodeAnswerType: (id) answerTypeJSON
{
    answerTypeJSON = null2Nil(answerTypeJSON);
    
    if ([answerTypeJSON isKindOfClass: [NSString class]])
    {
        if ([answerTypeJSON isEqualToString: kJSONValueAnswerTypePositive])
            return AnswerTypePositive;
        
        else if ([answerTypeJSON isEqualToString: kJSONValueAnswerTypeNegative])
            return AnswerTypeNegative;
        
        else
            return AnswerTypeUnknown;
    }
    else return AnswerTypeUnknown;
}


+ (NSDateFormatter *) dateFormatter
{
    static dispatch_once_t predicate = 0;
    __strong static NSDateFormatter *formatter = nil;
    
    dispatch_once(&predicate,
                  ^{
                      formatter = [NSDateFormatter new];

                      formatter.dateStyle = NSDateFormatterNoStyle;
                      formatter.timeStyle = NSDateFormatterNoStyle;
                      
                      formatter.dateFormat = @"dd-MM-yyyy";
                  });
    
    return formatter;
}

@end
