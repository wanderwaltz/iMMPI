//
//  DataStorage.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonIndexModel.h"
#import "Person.h"


#pragma mark -
#pragma mark DataStorage interface

@interface DataStorage : NSObject
{
    PersonIndexModel *_personIndexModel;
    
    NSMutableArray *_documents;
}

#pragma mark data objects factory methods

+ (Person *) createPersonRecord NS_RETURNS_NOT_RETAINED; 
+ (PersonIndexRecord *) createIndexRecordForPerson: (Person *) person NS_RETURNS_NOT_RETAINED;

+ (PersonIndexModel *) personIndexModel NS_RETURNS_NOT_RETAINED;
+ (void) storePersonRecord: (Person *) person;

+ (void) loadLocalDocuments;

@end
