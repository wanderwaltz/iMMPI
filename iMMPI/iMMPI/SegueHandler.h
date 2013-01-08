//
//  SegueHandler.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 07.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"


#pragma mark -
#pragma mark SegueHandler protocol

@protocol StoryboardManagedViewControllerProtocol;

@protocol SegueHandler <NSObject>
@required

- (BOOL) canHandleSegue: (UIStoryboardSegue *) segue sender: (id) sender;
- (void)    handleSegue: (UIStoryboardSegue *) segue sender: (id) sender;

- (id<SegueHandler>) segueHandlerForManagedViewController: (id<StoryboardManagedViewControllerProtocol>) controller
                                                    segue: (UIStoryboardSegue *) segue
                                                   sender: (id) sender;

@end
