//
//  StoryboardManagedViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 07.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Storyboard.h"


#pragma mark -
#pragma mark StoryboardManagedViewController interface

@interface StoryboardManagedViewController : UIViewController<StoryboardManagedViewControllerProtocol>
@property (strong, nonatomic) id<SegueHandler> segueHandler;

@end
