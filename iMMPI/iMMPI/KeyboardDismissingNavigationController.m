//
//  KeyboardDismissingNavigationController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "KeyboardDismissingNavigationController.h"

#pragma mark -
#pragma mark KeyobardDismissingNavigationController implementation

@implementation KeyboardDismissingNavigationController

- (BOOL) disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end
