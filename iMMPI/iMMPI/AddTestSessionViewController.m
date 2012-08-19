//
//  NewTestSessionViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AddTestSessionViewController.h"


#pragma mark -
#pragma mark NewTestSessionViewController implementation

@implementation AddTestSessionViewController

#pragma mark -
#pragma mark actions

- (IBAction) cancelButtonAction: (id) sender
{
    [self delegate_cancel];
}


#pragma mark -
#pragma mark private: delegate callbacks

- (void) delegate_cancel
{
    if ([_delegate respondsToSelector: @selector(addTestSessionViewControllerDidCancel:)])
    {
        [_delegate addTestSessionViewControllerDidCancel: self];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    UIView *view = [self.view viewWithTag: textField.tag+1];
    
    if ([view isKindOfClass: [UITextField class]])
    {
        [view becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
