//
//  StatementTableViewCell.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "StatementTableViewCell.h"


#pragma mark -
#pragma mark StatementTableViewCell implementation

@implementation StatementTableViewCell

#pragma mark -
#pragma mark initialization methods

- (void) awakeFromNib
{
    [_statementSegmentedControl addTarget: self
                                   action: @selector(segmentedControlValueChanged:)
                         forControlEvents: UIControlEventValueChanged];
}


#pragma mark -
#pragma mark actions

- (void) segmentedControlValueChanged: (UISegmentedControl *) segmentedControl
{
    if ([_delegate respondsToSelector: @selector(statementTableViewCell:segmentedControlChanged:)])
    {
        [_delegate statementTableViewCell: self
                  segmentedControlChanged: segmentedControl.selectedSegmentIndex];
    }
}

@end
