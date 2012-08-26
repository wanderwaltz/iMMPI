//
//  PersonTableViewCell.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark PersonTableViewCell interface

@interface PersonTableViewCell : UITableViewCell
{
    IBOutlet UILabel  *_lastNameLabel;
    IBOutlet UILabel *_firstNameLabel;
}

@property (readonly, nonatomic) UILabel *firstNameLabel;
@property (readonly, nonatomic) UILabel *lastNameLabel;

@end
