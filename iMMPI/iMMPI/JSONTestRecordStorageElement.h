//
//  JSONTestRecordStorageElement.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordStorageElement interface

@interface JSONTestRecordStorageElement : NSObject

@property (strong, nonatomic) id<TestRecordProtocol> record;
@property (strong, nonatomic) NSString *fileName;

@end
