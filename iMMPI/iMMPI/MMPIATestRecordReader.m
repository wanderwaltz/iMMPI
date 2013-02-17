//
//  MMPIATestRecordReader.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 17.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "MMPIATestRecordReader.h"

#pragma mark -
#pragma mark Constants

NSString * const kMMPIATestRecordReaderDirectoryDefault = @"Import";


#pragma mark -
#pragma mark Static constants

static NSString * const kQuestionnaireMaleAdult   = @"MALE";
static NSString * const kQuestionnaireFemaleAdult = @"FEMALE";
static NSString * const kQuestionnaireMaleTeen    = @"MALE TEEN";
static NSString * const kQuestionnaireFemaleTeen  = @"FEMALE TEEN";


static const int32_t kInsaneStringLength = 1000;
static const int32_t kInsaneAnswersCount =  567; // Actually it is 566, but whatever


#pragma mark -
#pragma mark MMPIATestRecordReader private

@interface MMPIATestRecordReader()
{
    NSString *_storedRecordsPath;
    
    NSDate *dec30_1899;
}

@end


#pragma mark -
#pragma mark MMPIATestRecordReader implementation

@implementation MMPIATestRecordReader


#pragma mark -
#pragma mark initialization methods

- (id) initWithDirectoryName: (NSString *) storageDirectoryName
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *storedRecordsPath = [[directories lastObject] stringByAppendingPathComponent:
                                   storageDirectoryName];
    
    FRB_AssertNotNil(storedRecordsPath);
    
    if (![self createFolderAtPathIfNeeded: storedRecordsPath])
        return nil;
    
    self = [super init];
    
    if (self != nil)
    {
        _storedRecordsPath = storedRecordsPath;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *dec30_1899_Components = [NSDateComponents new];
        
        dec30_1899_Components.year  = 1899;
        dec30_1899_Components.month = 12;
        dec30_1899_Components.day   = 30;
        
        dec30_1899 = [calendar dateFromComponents: dec30_1899_Components];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) readRecordFilesInBackgroundWithCallback:
        (void (^)(id<TestRecordProtocol> record, NSString *fileName,
                  NSUInteger totalFiles, NSUInteger recordsRead)) callback                                      completion:
            (void (^)(NSUInteger filesProcessed, NSUInteger recordsRead)) completion
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath: _storedRecordsPath
                                                         error: &error];
    
    if (error == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSUInteger recordsRead = 0;
            
            for (NSString *fileName in contents)
            {
                NSString *path = [_storedRecordsPath stringByAppendingPathComponent: fileName];
                
                id<TestRecordProtocol> testRecord =
                [self tryReadingTestRecordFromMMPIAFileWithPath: path];
                
                if (testRecord != nil)
                {
                    recordsRead++;
                    
                    if (callback != nil)
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            callback(testRecord, fileName, contents.count, recordsRead);
                        });
                    }
                }
                
                NSError *error = nil;
                
                BOOL deleted = [fileManager removeItemAtPath: path
                                                       error: &error];
                
                if (!deleted)
                {
                    NSLog(@"Failed to delete file at path: '%@' with error: %@", path, error);
                }
            }
            
            if (completion != nil)
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(contents.count, recordsRead);
                });
        });
    }
    else if (completion != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NSNotFound, 0);
        });
    }
}


#pragma mark -
#pragma mark private

- (id<TestRecordProtocol>) tryReadingTestRecordFromMMPIAFileWithPath: (NSString *) path
{
    TestRecord *testRecord = nil;
    
    NSData *data = [NSData dataWithContentsOfFile: path];
    
    if (data != nil)
    {
        const void *bytes   = data.bytes; // This pointer will change its value
        const void *initialBytes = bytes; // This pointer will be fixed
                                          // Difference between these pointers will
                                          // be number of bytes read.
        
        NSString *questionnaireString = nil;
        NSString *firstNameString     = nil;
        NSString *lastNameString      = nil;
        NSString *middleNameString    = nil;
        NSString *birthYearString     = nil;
        
        NSMutableArray *answers = nil;
        
        NSDate *testDate = [NSDate date];
        
        int32_t genderValue = 0;
        
        // Try wrapping everything in a single @try...@catch block
        // to handle possible exceptions if we try to read a wrong
        // location from memory. Not sure if that will help, but
        // anyway return nil if any exception is catched.
        @try
        {
            // bytes pointer will shift further each time we read a string,
            // if some of the data could not be read properly, bytes will
            // be equal to nil and we stop processing the data and return nil too.
            
            // The original data format was very stiff and contained the following:
            
            // 1) Questionnaire type ('MALE', 'FEMALE', 'MALE TEEN' or 'FEMALE TEEN')
            bytes = [self readStringFromBuffer: bytes outString: &questionnaireString];
            if (bytes == nil) return nil;
            
            // 2) Last name (surname)
            bytes = [self readStringFromBuffer: bytes outString: &lastNameString];
            if (bytes == nil) return nil;
            
            // 3) First name
            bytes = [self readStringFromBuffer: bytes outString: &firstNameString];
            if (bytes == nil) return nil;
            
            // 4) Middle name (patronymic)
            bytes = [self readStringFromBuffer: bytes outString: &middleNameString];
            if (bytes == nil) return nil;
            
            // 5) Birth year in string form
            bytes = [self readStringFromBuffer: bytes outString: &birthYearString];
            if (bytes == nil) return nil;
            
            // 6) Integer (int32_t) representation of person's gender
            genderValue = (*(int32_t *)bytes);
            bytes      += sizeof(int32_t);
            
            // 7) Number of answers
            int32_t answersCount = (*(int32_t *)bytes);
            
            // Check for errorneous values, number of answers could not be more than 566
            // since that is the number of questions in a MMPI test we were using.
            if (answersCount >= kInsaneAnswersCount) return nil;
            bytes += sizeof(int32_t);
            
            answers = [NSMutableArray arrayWithCapacity: answersCount];
            
            // Answes were written as Boolean (int8_t) type
            for (NSUInteger i = 0; i < answersCount; ++i)
            {
                int8_t answer = (*(int8_t *)bytes);
                bytes += sizeof(int8_t);
                
                [answers addObject: @(answer)];
            }
            
            // Not every record contained test date, and originally it
            // was checked as EOF(F) where F was a file record. Now we
            // check if we have not read all the data yey.
            if (bytes - initialBytes < data.length)
            {
                // TDateTime type is a double floating point number
                double dateTime = (*(double *)bytes);
                testDate = [self dateFromDelphiTDateTime: dateTime];
            }
        }
        @catch (NSException *exception)
        {
            return nil;
        }
        
        // We've read all needed data without exceptions,
        // now we're safe to create a TestRecord instance.
        
        testRecord = [TestRecord new];
        
        testRecord.person.name = [self fullNameFromFirst: firstNameString
                                                  middle: middleNameString
                                                    last: lastNameString];
        
        testRecord.person.gender   = [self genderFromInteger: genderValue];
        testRecord.person.ageGroup = [self ageGroupFromQuestionnaireString: questionnaireString];
        
        testRecord.date = testDate;
        
        [answers enumerateObjectsUsingBlock:
         ^(NSNumber *answer, NSUInteger index, BOOL *stop) {
            [testRecord.testAnswers setAnswerType:
             ([answer intValue] == 0) ? AnswerTypeNegative : AnswerTypePositive
             
                                   forStatementID: index];
        }];
    }
    
    return testRecord;
}


- (NSString *) fullNameFromFirst: (NSString *) firstName
                          middle: (NSString *) middleName
                            last: (NSString *) lastName
{
    return [NSString stringWithFormat: @"%@ %@ %@",
            lastName, firstName, middleName];
}


- (Gender) genderFromInteger: (int32_t) genderValue
{
    // Original definition of the gender enum in the Delphi 6 project
    // was the following:
    //   Type TSex = (sexMale,sexFemale);
    return (genderValue == 0) ? GenderMale : GenderFemale;
}


- (AgeGroup) ageGroupFromQuestionnaireString: (NSString *) questionnaireString
{
    // Original answers record format did not store the age group of the
    // person, but did store the questionnaire type in form of strings
    // like 'MALE TEEN' or 'FEMALE', so we have to check the questionnaire
    // type to get the age group.
    
    if ([questionnaireString isEqualToString: kQuestionnaireMaleAdult] ||
       [questionnaireString isEqualToString: kQuestionnaireFemaleAdult])
        return AgeGroupAdult;
    
    else if ([questionnaireString isEqualToString: kQuestionnaireMaleTeen] ||
             [questionnaireString isEqualToString: kQuestionnaireFemaleTeen])
        return AgeGroupTeen;
    
    else
        return AgeGroupUnknown;
}


- (NSDate *) dateFromDelphiTDateTime: (double) TDateTime
{
    // Delphi 6 represents its TDateTime type as a double offset
    // in days from 30 Dec 1899 for some reason.
    return [dec30_1899 dateByAddingTimeInterval: TDateTime * 24 * 60 * 60];
}


/*! Reads an NSString from the provided buffer and returns the pointer to remaining (unread) bytes. The resulting string is returned using the outString parameter. If reading string failes for some reason, returns nil indicating that the data is corrupt and the remaining bytes should not be read.
 */
- (const void *) readStringFromBuffer: (const void *) bytes outString: (__autoreleasing NSString **) string
{
    // Delphi 6 project stored the length of the string as Integer type
    // first, which translates to int32_t here, then the String was written
    // byte by byte. Encoding problem has arised here with Cyrillic characters,
    // but the NSWindowsCP1251StringEncoding encoding seems to match perfectly
    
    // Current implementation of this method checks the string length value
    // for unexpected big numbers using kInsaneStringLength constant.
    NSUInteger offset = 0;
    
    int32_t length = (*(int32_t *)bytes);
    
    offset = sizeof(int32_t);
    
    if (length >= kInsaneStringLength)
    {
        return nil;
    }
    
    if (string != nil)
    {
        *string = [[NSString alloc] initWithBytes: bytes+4
                                           length: length
                                         encoding: NSWindowsCP1251StringEncoding];
    }
    
    offset += length;
    
    return bytes+offset;
}


- (BOOL) createFolderAtPathIfNeeded: (NSString *) path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSError *error = nil;
        
        BOOL created =
        [fileManager createDirectoryAtPath: path
               withIntermediateDirectories: YES
                                attributes: nil
                                     error: &error];
        
        if (!created)
        {
            NSLog(@"Failed to create directory at path '%@' with error: %@",
                  path, error);
            return NO;
        }
    }
    
    return YES;
}


@end
