//
//  StatementTableViewCell.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark StatementTableViewCell interface

@interface StatementTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *statementIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *statementTextLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *statementSegmentedControl;

@end
