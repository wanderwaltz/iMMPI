//
//  AnalyserTableViewCell.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark AnalyserTableViewCell interface

@interface AnalyserTableViewCell : UITableViewCell
@property (readonly, nonatomic) UILabel *groupNameLabel;

@property (assign, nonatomic) CGFloat groupNameOffset;

@end
