//
//  NewRecordFormViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"

#pragma mark -
#pragma mark Forward declarations

@class NewRecordFormViewController;


#pragma mark -
#pragma mark NewRecordFormViewControllerDelegate protocol

@protocol NewRecordFormViewControllerDelegate<NSObject>
@optional

- (void) newRecordFormViewControllerDidCancel: (NewRecordFormViewController *) controller;

- (void) newRecordFormViewController: (NewRecordFormViewController *) controller
                        didAddRecord: (id) record;

@end


#pragma mark -
#pragma mark NewRecordFormViewController interface

@interface NewRecordFormViewController : BaseViewController
{
    __weak id<NewRecordFormViewControllerDelegate> _delegate;
}

@property (weak, nonatomic) id<NewRecordFormViewControllerDelegate> delegate;

- (IBAction) cancelButtonAction: (id) sender;
- (IBAction) nextButtonAction:   (id) sender;

@end
