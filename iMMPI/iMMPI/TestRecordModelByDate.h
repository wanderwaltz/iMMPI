//
//  TestRecordModelByDate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark TestRecordModelByDate interface

@interface TestRecordModelByDate : NSObject<MutableTableViewModel>

- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (BOOL) addNewObject: (id<TestRecordProtocol>) object;
- (BOOL) updateObject: (id<TestRecordProtocol>) object;

@end
