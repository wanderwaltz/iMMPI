//
//  ProgressAlertView.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 17.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark ProgressAlertView interface

/*! An UIAlertView subclass which (if initialized with the new designated initializer) will be presented without buttons, but with UIProgressView to indicate that some asynchronous long action is taking place. 
 */
@interface ProgressAlertView : UIAlertView
@property(readonly, nonatomic) UIProgressView *progressView;

// Designated initialzier
- (id) initWithTitle: (NSString *) title;

@end
