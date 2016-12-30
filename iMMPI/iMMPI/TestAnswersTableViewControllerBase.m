//
//  TestAnswersTableViewControllerBase.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswersTableViewControllerBase.h"


#pragma mark -
#pragma mark TestAnswersTableViewController implementation

@implementation TestAnswersTableViewControllerBase

#pragma mark -
#pragma mark methods

- (void) loadQuestionnaireAsyncIfNeeded: (dispatch_block_t) completion
{
    if ((_questionnaire == nil) && (_record != nil))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.questionnaire = [Questionnaire newForGender: self.record.person.gender
                                                    ageGroup: self.record.person.ageGroup];
            
            if (completion)
                dispatch_async(dispatch_get_main_queue(), completion);
        });
    }
}


- (void) loadQuestionnaireAsyncIfNeeded
{
    [self loadQuestionnaireAsyncIfNeeded:^{
        [self.tableView reloadData];
    }];
}


- (id<StatementProtocol>) statementAtIndexPath: (NSIndexPath *) indexPath
{
    if ((indexPath.section == 0) && (indexPath.row < (NSInteger)self.questionnaire.statementsCount))
        return [_questionnaire statementAtIndex: indexPath.row];
    else
        return nil;
}


- (BOOL) saveRecord
{
    if (_record != nil)
        return [_storage updateTestRecord: _record];
    else
        return NO;
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
                                        [StatementTableViewCell reuseIdentifier]];
    FRB_AssertClass(cell, StatementTableViewCell);
    
    id<StatementProtocol> statement = [self statementAtIndexPath: indexPath];
    FRB_AssertNotNil(statement);
    
    cell.delegate                = self;
    cell.statementIDLabel.text   = [NSString stringWithFormat: @"%ld", (long)statement.statementID];
    cell.statementTextLabel.text = statement.text;
    
    switch ([_record.testAnswers answerTypeForStatementID: statement.statementID])
    {
        case AnswerTypePositive:
        {
            cell.statementSegmentedControl.selectedSegmentIndex = 1;
            cell.statementAnswerLabel.text = ___YES;
        } break;
            
            
        case AnswerTypeNegative:
        {
            cell.statementSegmentedControl.selectedSegmentIndex = 0;
            cell.statementAnswerLabel.text = ___NO;
        } break;
            
        case AnswerTypeUnknown:
        {
            cell.statementSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
            cell.statementAnswerLabel.text = nil;
        } break;
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
        id<StatementProtocol> statement = [self statementAtIndexPath: indexPath];
        FRB_AssertNotNil(statement);
        
        switch (selectedSegmentIndex)
        {
            case 0: [_record.testAnswers setAnswerType: AnswerTypeNegative
                                        forStatementID: statement.statementID]; break;
                
            case 1: [_record.testAnswers setAnswerType: AnswerTypePositive
                                        forStatementID: statement.statementID]; break;
                
            default: [_record.testAnswers setAnswerType: AnswerTypeUnknown
                                         forStatementID: statement.statementID]; break;
        }
    }
}


#pragma mark -
#pragma mark SegueDestinationEditAnswers

- (void) setRecordToEditAnswers:  (id<TestRecordProtocol>) record
{
    self.record = record;
}


- (void) setStorageToEditAnswers: (id<TestRecordStorage>) storage
{
    self.storage = storage;
}


#pragma mark -
#pragma mark SegueSourceAnalyzeRecord

- (id<TestRecordProtocol>) recordForAnalysisWithSender: (id) sender
{
    return self.record;
}


- (id<TestRecordStorage>) storageForAnalysisWithSender: (id) sender
{
    return self.storage;
}

@end
