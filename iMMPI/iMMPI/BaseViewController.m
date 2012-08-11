//
//  BaseViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "BaseViewController.h"

#pragma mark -
#pragma mark BaseViewController implementation

@implementation BaseViewController

#pragma mark -
#pragma mark view lifecycle

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    }
    else return YES;
}

@end
