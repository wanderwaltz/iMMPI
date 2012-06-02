//
//  AppDelegate.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "DataStorage.h"

#pragma mark -
#pragma mark AppDelegate implementation

@implementation AppDelegate

#pragma mark -
#pragma mark Properties

@synthesize window               =               _window;
@synthesize navigationController = _navigationController;

#pragma mark -
#pragma mark initialization

- (void) createWindow
{
    _window = [UIWindow createFullscreenWindow];
    _window.rootViewController = _navigationController;
}


- (void) createHomeViewController
{
    HomeViewController *controller = [HomeViewController instance];
    _navigationController = [controller embedInNavigationController];
}


#pragma mark -
#pragma mark Application lifecycle

         - (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary  *) launchOptions
{
    [self createHomeViewController];
    [self createWindow];
    [_window makeKeyAndVisible];
    
    OnMainThread(^{
        [DataStorage loadLocalDocuments]; 
    });
    
    return YES;
}

@end
