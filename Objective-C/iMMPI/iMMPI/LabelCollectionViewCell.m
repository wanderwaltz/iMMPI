//
//  LabelCollectionViewCell.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "LabelCollectionViewCell.h"


#pragma mark -
#pragma mark LabelCollectionViewCell implementation

@implementation LabelCollectionViewCell

#pragma mark -
#pragma mark initialization methods

- (void) awakeFromNib
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
