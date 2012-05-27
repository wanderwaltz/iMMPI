//
//  DataStorage.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonRecordProtocol.h"

#pragma mark -
#pragma mark DataStorage interface

@interface DataStorage : NSObject

+ (id<PersonRecordProtocol>) createPersonRecord; 

@end
