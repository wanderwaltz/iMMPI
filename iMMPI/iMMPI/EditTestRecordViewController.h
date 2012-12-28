//
//  EditTestRecordViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


#pragma mark -
#pragma mark EditTestRecordViewControllerDelegate protocol

@class EditTestRecordViewController;

@protocol EditTestRecordViewControllerDelegate<NSObject>
@required

- (void) editTestRecordViewController: (EditTestRecordViewController *) controller
               didFinishEditingRecord: (id<TestRecord>) record;

@end


#pragma mark -
#pragma mark EditTestRecordViewController interface

@interface EditTestRecordViewController : UITableViewController

@property (weak,   nonatomic) id<EditTestRecordViewControllerDelegate> delegate;
@property (strong, nonatomic) id<TestRecord> record;

@end
