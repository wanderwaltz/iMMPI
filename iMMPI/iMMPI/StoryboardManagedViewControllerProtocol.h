//
//  StoryboardManagedViewControllerProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"


#pragma mark -
#pragma mark StoryboardManagedViewController protocol

@protocol StoryboardManagedViewControllerProtocol <NSObject>
@required

@property (strong, nonatomic) id<SegueHandler> segueHandler;

@end
