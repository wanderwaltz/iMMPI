//
//  JSONTestRecordSerialization.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordSerialization interface

@interface JSONTestRecordSerialization : NSObject

+ (NSData *)               dataWithTestRecord: (id<TestRecordProtocol>) testRecord;
+ (id<TestRecordProtocol>) testRecordFromData: (NSData *) data;

+ (NSString *) version;

@end
