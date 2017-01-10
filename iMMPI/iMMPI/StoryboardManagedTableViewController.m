//
//  StoryboardManagedTableViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 07.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "StoryboardManagedTableViewController.h"


#pragma mark -
#pragma mark StoryboardManagedTableViewController implementation

@implementation StoryboardManagedTableViewController

- (id<SegueHandler>)segueHandler
{
    if (_segueHandler == nil) {
        _segueHandler = [[MMPISegueHandler alloc] init];
    }

    return _segueHandler;
}


#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue
                  sender: (id) sender
{
    if ([self.segueHandler canHandleSegue: segue sender: sender])
    {
        [self.segueHandler handleSegue: segue sender: sender];
    }
}

@end
