//
//  AppDelegate.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: check intellectual scale X (especially that the invalid statements are ignored)
// TODO: add html details for intellectual scale X
// TODO: check Ригидность and Стабильность профиля to invert the matches-median value

#pragma mark -
#pragma mark AppDelegate interface

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
