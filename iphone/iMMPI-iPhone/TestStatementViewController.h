//
//  TestStatementViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"

#pragma mark -
#pragma mark Forward declarations

@class TestStatementViewController;


#pragma mark -
#pragma mark TestStatementViewControllerDelegate protocol

@protocol TestStatementViewControllerDelegate <NSObject>
@optional

- (void) testStatementViewControllerDidAnswerYes:          (TestStatementViewController *) controller;
- (void) testStatementViewControllerDidAnswerNo:           (TestStatementViewController *) controller;
- (void) testStatementViewControllerDidExit:               (TestStatementViewController *) controller;
- (void) testStatementViewControllerDidSelectBrowse:       (TestStatementViewController *) controller;
- (void) testStatementViewControllerGoToNextStatement:     (TestStatementViewController *) controller;
- (void) testStatementViewControllerGoToPreviousStatement: (TestStatementViewController *) controller;

@end


#pragma mark -
#pragma mark TestStatementViewController interface

@interface TestStatementViewController : BaseViewController
{
    __weak id<TestStatementViewControllerDelegate> _delegate;
}

@property (weak, nonatomic) id<TestStatementViewControllerDelegate> delegate;

- (IBAction) exitButtonAction:   (id) sender;
- (IBAction) browseButtonAction: (id) sender;

- (IBAction) agreeButtonAction:    (id) sender;
- (IBAction) disagreeButtonAction: (id) sender;

- (IBAction) nextStatementAction:     (UIGestureRecognizer *) recognizer;
- (IBAction) previousStatementAction: (UIGestureRecognizer *) recognizer;

@end
