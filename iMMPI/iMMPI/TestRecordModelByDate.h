//
//  TestRecordModelByDate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark TestRecordModelByDateDelegate protocol

@class TestRecordModelByDate;

@protocol TestRecordModelByDateDelegate <NSObject>
@optional

- (BOOL) testRecordModelByDate: (TestRecordModelByDate *) model
            shouldAddNewObject: (id<TestRecordProtocol>) record;

- (void) testRecordModelByDate: (TestRecordModelByDate *) model
               didAddNewObject: (id<TestRecordProtocol>) record;

- (BOOL) testRecordModelByDate: (TestRecordModelByDate *) model
            shouldUpdateObject: (id<TestRecordProtocol>) record;

- (void) testRecordModelByDate: (TestRecordModelByDate *) model
               didUpdateObject: (id<TestRecordProtocol>) record;

@end


#pragma mark -
#pragma mark TestRecordModelByDate interface

@interface TestRecordModelByDate : NSObject<MutableTableViewModel>
@property (weak, nonatomic) id<TestRecordModelByDateDelegate> delegate;

- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (BOOL) addNewObject: (id<TestRecordProtocol>) record;
- (BOOL) updateObject: (id<TestRecordProtocol>) record;

@end
