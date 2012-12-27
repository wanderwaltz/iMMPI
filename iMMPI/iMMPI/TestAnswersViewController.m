//
//  TestAnswersViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswersViewController.h"
#import "Questionnaire.h"

#import "StatementTableViewCell.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kAnswerCellIdentifier = @"AnswerCell";


#pragma mark -
#pragma mark TestAnswersViewController private

@interface TestAnswersViewController()<StatementTableViewCellDelegate>
{
    id<Questionnaire> _questionnaire;
    id<TestAnswers>   _answers;
}

@end


#pragma mark -
#pragma mark TestAnswersViewController implementation

@implementation TestAnswersViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _questionnaire = [Questionnaire newForGender: GenderMale
                                            ageGroup: AgeGroupAdult];
        
        _answers = [TestAnswers new];
    }
    return self;
}


#pragma mark -
#pragma mark private

- (id<Statement>) statementAtIndexPath: (NSIndexPath *) indexPath
{
    return [_questionnaire statementAtIndex: indexPath.row];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_questionnaire statementsCount];
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    StatementTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:
                                        kAnswerCellIdentifier];
    FRB_AssertClass(cell, StatementTableViewCell);
    
    id<Statement> statement = [self statementAtIndexPath: indexPath];
    FRB_AssertNotNil(statement);
    
    cell.delegate                = self;
    cell.statementIDLabel.text   = [NSString stringWithFormat: @"%d", statement.statementID];
    cell.statementTextLabel.text = statement.text;
    
    switch ([_answers answerTypeForStatementID: statement.statementID])
    {
        case AnswerTypePositive: cell.statementSegmentedControl.selectedSegmentIndex = 1; break;
        case AnswerTypeNegative: cell.statementSegmentedControl.selectedSegmentIndex = 0; break;
            
        case AnswerTypeUnknown:
            cell.statementSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment; break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark StatementTableViewCellDelegate

- (void) statementTableViewCell: (StatementTableViewCell *) cell
        segmentedControlChanged: (NSInteger) selectedSegmentIndex
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    
    if (indexPath)
    {
        Statement *statement = [self statementAtIndexPath: indexPath];
        FRB_AssertNotNil(statement);
        
        switch (selectedSegmentIndex)
        {
            case 0: [_answers setAnswerType: AnswerTypeNegative
                             forStatementID: statement.statementID]; break;
                
            case 1: [_answers setAnswerType: AnswerTypePositive
                             forStatementID: statement.statementID]; break;
                
            default: [_answers setAnswerType: AnswerTypeUnknown
                              forStatementID: statement.statementID]; break;
        }
    }
}

@end
