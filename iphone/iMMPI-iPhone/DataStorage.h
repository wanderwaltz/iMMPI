//
//  DataStorage.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonIndexRecord.h"
#import "Person.h"
#import "MMPIDocument.h"


#pragma mark -
#pragma mark DataStorage interface

@interface DataStorage : NSObject
{
    NSMutableArray *_documents;
}

@property (readonly, nonatomic) NSArray *personsListElements;

+ (MMPIDocument *) documentForPersonsListElement: (id) element NS_RETURNS_NOT_RETAINED;

+ (Person *) createPersonRecord NS_RETURNS_NOT_RETAINED; 
+ (PersonIndexRecord *) createIndexRecordForPerson: (Person *) person NS_RETURNS_NOT_RETAINED;

+ (void) createDocumentForPerson: (Person *) person;

+ (void) loadLocalDocuments;

+ (id) shared NS_RETURNS_NOT_RETAINED;

@end
