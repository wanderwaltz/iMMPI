//
//  AnalyzerTableViewCell.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark AnalyzerTableViewCell interface

@interface AnalyzerTableViewCell : UITableViewCell
@property (readonly, nonatomic) UILabel *groupNameLabel;
@property (readonly, nonatomic) UILabel *scoreLabel;

@property (assign, nonatomic) CGFloat groupNameOffset;

@end
