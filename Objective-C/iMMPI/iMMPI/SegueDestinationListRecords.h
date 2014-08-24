//
//  SegueDestinationListRecords.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueDestinationListRecords protocol

@protocol SegueDestinationListRecords <NSObject>
@required

- (void)   setModelForListRecords: (id<MutableTableViewModel>) model;
- (void) setStorageForListRecords: (id<TestRecordStorage>) storage;
- (void)   setTitleForListRecords: (NSString *) title;


@optional

- (void) setSelectedTestRecord: (id<TestRecordProtocol>) testRecord;

@end
