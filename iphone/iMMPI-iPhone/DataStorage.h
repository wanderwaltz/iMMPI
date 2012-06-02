//
//  DataStorage.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonIndexRecord.h"
#import "Person.h"


#pragma mark -
#pragma mark DataStorage interface

@interface DataStorage : NSObject
{
    NSMutableArray *_documents;
}

@property (readonly, nonatomic) NSArray *personsListElements;

+ (Person *) createPersonRecord NS_RETURNS_NOT_RETAINED; 
+ (PersonIndexRecord *) createIndexRecordForPerson: (Person *) person NS_RETURNS_NOT_RETAINED;

+ (void) storePersonRecord: (Person *) person;

+ (void) loadLocalDocuments;

+ (id) shared NS_RETURNS_NOT_RETAINED;

@end
