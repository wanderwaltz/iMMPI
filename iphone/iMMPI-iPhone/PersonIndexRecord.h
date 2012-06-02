//
//  PersonIndexRecordData.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "JsonDataWrapper.h"
#import "Person.h"

#pragma mark -
#pragma mark PersonIndexJsonData interface

@interface PersonIndexRecord : JsonDataWrapper
{
    NSString *_sectionIdentifier;
}

@property (strong,   nonatomic) NSString *fullName;
@property (readonly, nonatomic) NSString *sectionIdentifier;

+ (id) indexRecordForPerson: (Person *) person NS_RETURNS_NOT_RETAINED;
- (id) initWithPerson:       (Person *) person NS_RETURNS_RETAINED;

@end
