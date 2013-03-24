//
//  AppDelegate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: fix parsing empty string of answers
// TODO: fix analyzer screen not showing properly for some of completed records

#pragma mark -
#pragma mark AppDelegate interface

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
