//
//  AppDelegate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: popup windows with analyzer groups debug info
// TODO: emailing a report about specific analyzer groups
// TODO: transliteration of the file names included in the analysis report email

#pragma mark -
#pragma mark AppDelegate interface

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
