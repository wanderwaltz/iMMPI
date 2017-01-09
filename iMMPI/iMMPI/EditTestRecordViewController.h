//
//  EditTestRecordViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark EditTestRecordViewControllerDelegate protocol

@class EditTestRecordViewController;

@protocol EditTestRecordViewControllerDelegate<NSObject>
@required

- (void)editTestRecordViewController:(EditTestRecordViewController *)controller
              didFinishEditingRecord:(id<TestRecordProtocol> _Nullable)record
                NS_SWIFT_NAME(editTestRecordViewController(_:didFinishEditing:));

@end


#pragma mark -
#pragma mark EditTestRecordViewController interface

@interface EditTestRecordViewController : StoryboardManagedTableViewController
<SegueDestinationEditRecord>

@property (weak, nonatomic) id<EditTestRecordViewControllerDelegate> _Nullable delegate;
@property (strong, nonatomic) id<TestRecordProtocol> _Nullable record;

@end

NS_ASSUME_NONNULL_END
