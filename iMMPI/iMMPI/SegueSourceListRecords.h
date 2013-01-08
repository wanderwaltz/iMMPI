//
//  SegueSourceListRecords.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueSourceListRecords protocol

@protocol SegueSourceListRecords <NSObject>
@required

- (id<MutableTableViewModel>) modelForListRecordsWithSender: (id) sender;
- (id<TestRecordStorage>)   storageForListRecordsWithSender: (id) sender;
- (NSString *)                titleForListRecordsWithSender: (id) sender;

@end
