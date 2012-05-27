//
//  PersonRecordData.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonRecordProtocol.h"
#import "JsonDataWrapper.h"

#pragma mark -
#pragma mark PersonJsonData interface

@interface PersonJsonData : JsonDataWrapper<PersonRecordProtocol>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate   *birthDate;

@end
