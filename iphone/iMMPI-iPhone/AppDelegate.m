//
//  AppDelegate.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "AppDelegate.h"

#pragma mark -
#pragma mark AppDelegate implementation

@implementation AppDelegate

#pragma mark -
#pragma mark Properties

@synthesize window = _window;

#pragma mark -
#pragma mark Application lifecycle

         - (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary  *) launchOptions
{
    _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
