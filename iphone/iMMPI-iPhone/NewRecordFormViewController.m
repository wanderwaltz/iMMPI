//
//  NewRecordFormViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "NewRecordFormViewController.h"

#pragma mark -
#pragma mark NewRecordFormViewController implementation

@implementation NewRecordFormViewController

#pragma mark -
#pragma mark Properties

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Actions 

- (void) cancelButtonAction: (id) sender
{
    [self cancel];
}


- (void) nextButtonAction: (id) sender
{
    [self addRecord: nil];
}


#pragma mark -
#pragma mark Delegate callbacks

- (void) cancel
{
    [[(id)_delegate ifResponds] newRecordFormViewControllerDidCancel: self];
}


- (void) addRecord: (id) record
{
    [[(id)_delegate ifResponds] newRecordFormViewController: self 
                                               didAddRecord: record];
}

@end
