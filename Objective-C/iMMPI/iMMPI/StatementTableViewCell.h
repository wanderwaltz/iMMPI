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

/*! A delegate for StatementTableViewCell objects.
 */
@protocol StatementTableViewCellDelegate<NSObject>
@optional

/*! A method which is called when the segmented control of the corresponding StatementTableViewCell changes its selected segment index.
 
 @param cell The StatementTableViewCell which sends the change message.
 @param selectedSegmentIndex Index of the selected segment of the UISegmentedControl (usually segmented controls with only two segments are used - for positive/negative answers).
 */
- (void) statementTableViewCell: (StatementTableViewCell *) cell
        segmentedControlChanged: (NSInteger) selectedSegmentIndex;

@end


#pragma mark -
#pragma mark StatementTableViewCell interface

/*! A UITableViewCell subclass suited for displaying StatementProtocol data.
 */
@interface StatementTableViewCell : UITableViewCell

/// Delegate which receives notifications about the cell's state changes
@property (weak, nonatomic) id<StatementTableViewCellDelegate> delegate;


/// Label which is used to display the ID of the statement
@property (strong, nonatomic) IBOutlet UILabel *statementIDLabel;


/// Label which is used to display the text of the statement
@property (strong, nonatomic) IBOutlet UILabel *statementTextLabel;


/// Label which is used to display the user provided answer (positive/negative) to the statement in textual form
@property (strong, nonatomic) IBOutlet UILabel *statementAnswerLabel;


/// Segmented control which is used to display the user privided answer (positive/negative) to the statement (usually 0 is negative, 1 is positive)
@property (strong, nonatomic) IBOutlet UISegmentedControl *statementSegmentedControl;


/// Reuse identifier of the cell. It is assumed that the same reuse identifier will be set in storyboards for the corresponding prototype cells.
+ (NSString *) reuseIdentifier;

@end
