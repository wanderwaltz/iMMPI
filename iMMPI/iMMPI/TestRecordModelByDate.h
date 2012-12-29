//
//  TestRecordModelByDate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

// TODO: sorting/sectioning by date

#pragma mark -
#pragma mark TestRecordModelByDate interface

@interface TestRecordModelByDate : NSObject<MutableTableViewModel>

- (id<TestRecord>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (BOOL) addNewObject: (id<TestRecord>) object;
- (BOOL) updateObject: (id<TestRecord>) object;

@end
