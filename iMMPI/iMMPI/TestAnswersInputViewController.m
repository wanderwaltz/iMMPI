//
//  TestAnswersInputViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswersInputViewController.h"
#import "StatementTableViewCell.h"
#import "AnalysisViewController.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kAnswerCellIdentifier = @"com.immpi.cells.answer";

static NSString * const kSegueAnalyzer = @"com.immpi.segue.analyzer";


#pragma mark -
#pragma mark TestAnswersInputViewController private

@interface TestAnswersInputViewController()
{
    IBOutlet UIBarButtonItem *_analyzisBarButton;
    
    id<QuestionnaireProtocol> _questionnaire;
    
    NSUInteger _statementIndex;
}

@end


#pragma mark -
#pragma mark TestAnswersInputViewController implementations

@implementation TestAnswersInputViewController

#pragma mark -
#pragma mark actions

- (IBAction) prevBarButtonAction: (id) sender
{
    [self setPreviousStatementIndex];
}


- (IBAction) nextBarButtonAction: (id) sender
{
    [self setNextStatementIndex];
}


- (IBAction) negativeAnswerButtonAction: (id) sender
{
    id<StatementProtocol> statement = [_questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    [_record.testAnswers setAnswerType: AnswerTypeNegative
                        forStatementID: statement.statementID];
    
    if (![self setNextStatementIndex])
    {
        [self performSegueWithIdentifier: kSegueAnalyzer
                                  sender: nil];
    }
}


- (IBAction) positiveAnswerButtonAction: (id) sender
{
    id<StatementProtocol> statement = [_questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    [_record.testAnswers setAnswerType: AnswerTypePositive
                        forStatementID: statement.statementID];
    if (![self setNextStatementIndex])
    {
        [self performSegueWithIdentifier: kSegueAnalyzer
                                  sender: nil];
    }
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self loadQuestionnaireIfNeeded];
}


- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear:  animated];
    [_storage updateTestRecord: _record];
}


#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: kSegueAnalyzer])
    {
        AnalysisViewController *controller = segue.destinationViewController;
        
        FRB_AssertClass(controller, AnalysisViewController);
        
        controller.record = _record;
    }
}


#pragma mark -
#pragma mark private

- (void) loadQuestionnaireIfNeeded
{
    if (_questionnaire == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _questionnaire = [Questionnaire newForGender: _record.person.gender
                                                ageGroup: _record.person.ageGroup];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setStatementIndex: 0];
            });
        });
    }
}


- (id<StatementProtocol>) statementAtIndexPath: (NSIndexPath *) indexPath
{
    return [_questionnaire statementAtIndex: indexPath.row];
}


- (BOOL) setPreviousStatementIndex
{
    if (_statementIndex > 0)
    {
        [self setStatementIndex: _statementIndex-1];
        return YES;
    }
    else return NO;
}


- (BOOL) setNextStatementIndex
{
    id<StatementProtocol> statement = [_questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    if ((_statementIndex < _questionnaire.statementsCount-1) &&
        ([_record.testAnswers answerTypeForStatementID: statement.statementID] != AnswerTypeUnknown))
    {
        [self setStatementIndex: _statementIndex+1];
        return YES;
    }
    else return NO;
}


- (void) setStatementIndex: (NSUInteger) index
{
    if (index < _questionnaire.statementsCount)
    {
        _statementIndex = index;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: index
                                                                   inSection: 0]
                              atScrollPosition: UITableViewScrollPositionMiddle
                                      animated: NO];
        
        self.title = [NSString stringWithFormat: ___FORMAT_N_of_M,
                      _statementIndex+1, _questionnaire.statementsCount];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate 

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self setStatementIndex: indexPath.row];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return  _questionnaire.statementsCount;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    StatementTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:
                                        kAnswerCellIdentifier];
    FRB_AssertClass(cell, StatementTableViewCell);
    
    id<StatementProtocol> statement = [self statementAtIndexPath: indexPath];
    FRB_AssertNotNil(statement);
    
    cell.statementIDLabel.text   = [NSString stringWithFormat: @"%d", statement.statementID];
    cell.statementTextLabel.text = statement.text;
    
    if (_statementIndex == indexPath.row)
    {
        cell.statementIDLabel.alpha     = 1.0;
        cell.statementTextLabel.alpha   = 1.0;
        cell.statementAnswerLabel.alpha = 1.0;
    }
    else
    {
        cell.statementIDLabel.alpha     = 0.125;
        cell.statementTextLabel.alpha   = 0.125;
        cell.statementAnswerLabel.alpha = 0.125;
    }
    
    
    switch ([_record.testAnswers answerTypeForStatementID: statement.statementID])
    {
        case AnswerTypePositive: cell.statementAnswerLabel.text = ___YES; break;
        case AnswerTypeNegative: cell.statementAnswerLabel.text =  ___NO; break;
        case AnswerTypeUnknown:  cell.statementAnswerLabel.text =    nil; break;
    }
    
    
    return cell;
}

@end
