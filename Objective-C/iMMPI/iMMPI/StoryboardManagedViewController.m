//
//  StoryboardManagedViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 07.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "StoryboardManagedViewController.h"


#pragma mark -
#pragma mark StoryboardManagedViewController implementation

@implementation StoryboardManagedViewController

#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue
                  sender: (id) sender
{
    if ([_segueHandler canHandleSegue: segue sender: sender])
    {
        [_segueHandler handleSegue: segue sender: sender];
    }
}

@end
