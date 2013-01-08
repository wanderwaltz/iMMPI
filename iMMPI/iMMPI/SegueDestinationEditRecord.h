//
//  SegueDestinationEditRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueDestinationEditRecord protocol

@protocol EditTestRecordViewControllerDelegate;

@protocol SegueDestinationEditRecord <NSObject>
@required

- (void) setTitleForEditingTestRecord: (NSString *) title;

- (void) setTestRecordToEdit:             (id<TestRecordProtocol>) record;
- (void) setDelegateForEditingTestRecord: (id<EditTestRecordViewControllerDelegate>) delegate;

@end
