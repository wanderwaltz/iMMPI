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

/*  A table view cell used to display person's full name
    in a style similar to the Apple's Contacts app, i.e.
    last name in bold font, other names in normal font.
 
    The difference is that the last name is placed at
    the left side of the cell (Apple's implementation
    places the last name at the right)
 */
@interface PersonTableViewCell : UITableViewCell
{
    IBOutlet UILabel  *_lastNameLabel;
    IBOutlet UILabel *_firstNameLabel;
}

@property (readonly, nonatomic) UILabel *firstNameLabel;
@property (readonly, nonatomic) UILabel *lastNameLabel;

@end
