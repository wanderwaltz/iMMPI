//
//  SegueSourceEditRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueSourceEditRecord protocol

@protocol EditTestRecordViewControllerDelegate;

@protocol SegueSourceEditRecord <NSObject>
@required

- (NSString *) titleForEditingTestRecord: (id<TestRecordProtocol>) record withSender: (id) sender;

- (id<TestRecordProtocol>) testRecordToEditWithSender: (id) sender;
- (id<EditTestRecordViewControllerDelegate>) delegateForEditingTestRecordWithSender: (id) sender;

@end
