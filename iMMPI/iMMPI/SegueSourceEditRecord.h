//
//  SegueSourceEditRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueSourceEditRecord protocol

@protocol EditTestRecordViewControllerDelegate;

@protocol SegueSourceEditRecord <NSObject>
@required

- (NSString *)titleForEditingTestRecord:(id<TestRecordProtocol>)record withSender:(id _Nullable)sender
NS_SWIFT_NAME(titleForEditing(_:with:));

- (id<TestRecordProtocol> _Nullable)testRecordToEditWithSender:(id _Nullable)sender
NS_SWIFT_NAME(testRecordToEdit(with:));

- (id<EditTestRecordViewControllerDelegate>)delegateForEditingTestRecordWithSender:(id _Nullable)sender
NS_SWIFT_NAME(delegateForEditingTestRecord(with:));

@end

NS_ASSUME_NONNULL_END
