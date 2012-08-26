//
//  PersonTableViewCell.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "PersonTableViewCell.h"

#pragma mark -
#pragma mark PersonTableViewCell implementation

@implementation PersonTableViewCell

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    /*  Calculate the size needed to display last name in bold font
        at the left side of the content view, and then, if possible,
        lay out the other names (first name and patronymic) to the
        right.
     */
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    bounds = CGRectInset(bounds, 8.0, 4.0);
    
    CGSize constraint = CGSizeMake(bounds.size.width, bounds.size.height);
    
    CGSize lastNameSize = [_lastNameLabel.text sizeWithFont: _lastNameLabel.font
                                          constrainedToSize: constraint
                                              lineBreakMode: UILineBreakModeTailTruncation];
    
    CGSize spaceSize = [@" " sizeWithFont: _lastNameLabel.font];
    
    CGRect lastNameFrame = CGRectMake(CGRectGetMinX(bounds),
                                      CGRectGetMinY(bounds),
                                      lastNameSize.width,
                                      bounds.size.height);
    
    CGRect firstNameFrame = CGRectMake(CGRectGetMaxX(lastNameFrame)+spaceSize.width,
                                       CGRectGetMinY(bounds),
                                       CGRectGetMaxX(bounds)-CGRectGetMaxX(lastNameFrame)-spaceSize.width,
                                       bounds.size.height);
    
    lastNameFrame  = CGRectIntegral(lastNameFrame);
    firstNameFrame = CGRectIntegral(firstNameFrame);
    
    _firstNameLabel.frame = firstNameFrame;
    _lastNameLabel.frame  = lastNameFrame;
}

@end
