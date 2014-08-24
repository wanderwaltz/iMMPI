//
//  ProgressAlertView.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 17.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "ProgressAlertView.h"


#pragma mark -
#pragma mark ProgressAlertView implementation

@implementation ProgressAlertView

#pragma mark -
#pragma mark initialization methods

- (id) initWithTitle: (NSString *) title
{
    self = [super initWithTitle: title
                        message: @"   \n   " // Need some placeholder text or the label
                       delegate: nil         // won't be properly initialized and setting
              cancelButtonTitle: nil         // the text later won't have effect.
              otherButtonTitles: nil];
    
    if (self != nil)
    {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleBar];
        [self addSubview: _progressView];
    }
    return self;
}


#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    [_progressView setFrame: CGRectMake(20.0, self.bounds.size.height-64.0,
                                        self.bounds.size.width - 40.0, 10.0)];
}


@end
