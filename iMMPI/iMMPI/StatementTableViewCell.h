//
//  StatementTableViewCell.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark StatementTableViewCellDelegate protocol

@class StatementTableViewCell;


@protocol StatementTableViewCellDelegate<NSObject>
@optional

- (void) statementTableViewCell: (StatementTableViewCell *) cell
        segmentedControlChanged: (NSInteger) selectedSegmentIndex;

@end


#pragma mark -
#pragma mark StatementTableViewCell interface

@interface StatementTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StatementTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *statementIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *statementTextLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *statementSegmentedControl;

@end
