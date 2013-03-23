//
//  HTMLTestRecordSerialization.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark HTMLTestRecordSerialization interface

@interface HTMLTestRecordSerialization : NSObject

+ (NSData *) dataWithTestRecord: (id<TestRecordProtocol>) record;

@end
