//
//  AnalyzerTableViewCell.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerTableViewCell.h"


#pragma mark -
#pragma mark AnalyzerTableViewCell private

@interface AnalyzerTableViewCell()
{
    IBOutlet UILabel *_groupNameLabel;
    IBOutlet UILabel *_scoreLabel;
    IBOutlet UILabel *_indexLabel;
    
    IBOutlet NSLayoutConstraint *_lcGroupNameLabelLeft;
}

@end


#pragma mark -
#pragma mark AnalyzerTableViewCell implementation

@implementation AnalyzerTableViewCell

#pragma mark -
#pragma mark properties

- (void) setGroupNameOffset: (CGFloat) groupNameOffset
{
    _groupNameOffset = groupNameOffset;
    _lcGroupNameLabelLeft.constant = _groupNameOffset + 20.0;
    [self setNeedsUpdateConstraints];
}

@end
