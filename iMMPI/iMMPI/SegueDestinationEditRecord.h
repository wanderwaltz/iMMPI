//
//  SegueDestinationEditRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueDestinationEditRecord protocol

@protocol EditTestRecordViewControllerDelegate;

@protocol SegueDestinationEditRecord<NSObject>
@required

- (void)setTitleForEditingTestRecord:(NSString *)title
            NS_SWIFT_NAME(setTitleForEditingTestRecord(_:));

- (void)setTestRecordToEdit:(id<TestRecordProtocol>)record
            NS_SWIFT_NAME(setTestRecordToEdit(_:));

- (void)setDelegateForEditingTestRecord:(id<EditTestRecordViewControllerDelegate>)delegate
            NS_SWIFT_NAME(setDelegateForEditingTestRecord(_:));

@end

NS_ASSUME_NONNULL_END
