//
//  TestStatementViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestStatementViewController.h"

#pragma mark -
#pragma mark TestStatementViewController implementation

@implementation TestStatementViewController

#pragma mark -
#pragma mark Properties

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Actions

- (void) exitButtonAction: (id) sender
{
    [self exit];
}


- (void) browseButtonAction: (id) sender
{
    [self browseStatements];
}


- (void) agreeButtonAction: (id) sender
{
    [self answerYes];
}


- (void) disagreeButtonAction: (id) sender
{
    [self answerNo];
}


- (void) nextStatementAction: (UIGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        [self goToNextStatement];
    }
}


- (void) previousStatementAction: (UIGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        [self goToPreviousStatement];
    }
}


#pragma mark -
#pragma mark Delegate callbacks

- (void) exit
{
    [[(id)_delegate ifResponds] testStatementViewControllerDidExit: self];
}


- (void) browseStatements
{
    [[(id)_delegate ifResponds] testStatementViewControllerDidSelectBrowse: self];
}


- (void) answerYes
{
    [[(id)_delegate ifResponds] testStatementViewControllerDidAnswerYes: self];
}


- (void) answerNo
{
    [[(id)_delegate ifResponds] testStatementViewControllerDidAnswerNo: self];
}


- (void) goToNextStatement
{
    [[(id)_delegate ifResponds] testStatementViewControllerGoToNextStatement: self];
}


- (void) goToPreviousStatement
{
    [[(id)_delegate ifResponds] testStatementViewControllerGoToPreviousStatement: self];
}

@end
