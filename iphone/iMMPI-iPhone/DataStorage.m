//
//  DataStorage.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "DataStorage.h"
#import "PersonJsonData.h"

#pragma mark -
#pragma mark DataStorage implementation

@implementation DataStorage

+ (id<PersonRecordProtocol>) createPersonRecord
{
    return [PersonJsonData instance];
}

@end
