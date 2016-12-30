//
//  AppDelegate.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AppDelegate.h"


#pragma mark -
#pragma mark AppDelegate implementation

@implementation AppDelegate

#pragma mark -
#pragma mark application lifecycle

         - (BOOL) application: (UIApplication *) application
didFinishLaunchingWithOptions: (NSDictionary  *) launchOptions
{
    FRB_AssertClass(self.window.rootViewController, UISplitViewController);
    [(UISplitViewController *)self.window.rootViewController setDelegate: self];
    
    return YES;
}


#pragma mark -
#pragma mark UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {

    NSAssert(svc.viewControllers.count == 2, @"Unexpected number of child view controllers in %@: %ld", svc, (long)svc.viewControllers.count);

    UIViewController *detailViewController = svc.viewControllers[1];
    FRB_AssertClass(detailViewController, UIViewController);

    detailViewController = SelfOrFirstChild(detailViewController);

    UIBarButtonItem *barButtonItem = svc.displayModeButtonItem;

    switch (displayMode) {
        case UISplitViewControllerDisplayModePrimaryHidden:
        case UISplitViewControllerDisplayModePrimaryOverlay: {
            barButtonItem.title = ___Records;

            if (detailViewController.navigationItem.leftBarButtonItem == nil)
                detailViewController.navigationItem.leftBarButtonItem = barButtonItem;
        } break;

        default: {
            if (detailViewController.navigationItem.leftBarButtonItem == barButtonItem)
                detailViewController.navigationItem.leftBarButtonItem = nil;
        } break;
    }
}

@end
