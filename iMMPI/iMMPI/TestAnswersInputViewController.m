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
#import "SystemSoundManager.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kSegueAnalyzer = @"com.immpi.segue.analyzer";


#pragma mark -
#pragma mark TestAnswersInputViewController private

@interface TestAnswersInputViewController()
{
    __weak IBOutlet UIBarButtonItem *_analyzisBarButton;
    __weak IBOutlet UIView *_inputView;
    
    NSUInteger _statementIndex;
    
    SystemSoundManager *_soundManager;
}

@end


#pragma mark -
#pragma mark TestAnswersInputViewController implementations

@implementation TestAnswersInputViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _soundManager = [SystemSoundManager new];
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonBackground        = [UIImage imageNamed: @"AnswersInputButton"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed: @"AnswersInputButtonPressed"];
    
    buttonBackground =
    [buttonBackground resizableImageWithCapInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
                                     resizingMode: UIImageResizingModeStretch];
    buttonBackgroundPressed =
    [buttonBackgroundPressed resizableImageWithCapInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
                                            resizingMode: UIImageResizingModeStretch];
    
    for (UIButton *button in _inputView.subviews)
    {
        if ([button isKindOfClass: [UIButton class]])
        {
            button.backgroundColor = [UIColor clearColor];
            
            [button setBackgroundImage: buttonBackground
                              forState: UIControlStateNormal];
            
            [button setBackgroundImage: buttonBackgroundPressed
                              forState: UIControlStateHighlighted];
        }
    }
    
    _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _inputView.layer.borderWidth = 1.0;
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self loadQuestionnaireAsyncIfNeeded: ^{
        [self setStatementIndex: 0];
    }];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear: animated];
    [self saveRecord];
}


#pragma mark -
#pragma mark actions

- (IBAction) prevButtonAction: (id) sender
{
    [self setPreviousStatementIndex];
}


- (IBAction) nextButtonAction: (id) sender
{
    [self setNextStatementIndex];
}


- (IBAction) negativeAnswerButtonAction: (id) sender
{
    [_soundManager playSoundNamed: @"button_tap1.wav"];
    
    id<StatementProtocol> statement = [self.questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    [self.record.testAnswers setAnswerType: AnswerTypeNegative
                        forStatementID: statement.statementID];
    
    if (![self setNextStatementIndex])
    {
        [self performSegueWithIdentifier: kSegueAnalyzer
                                  sender: nil];
    }
}


- (IBAction) positiveAnswerButtonAction: (id) sender
{
    [_soundManager playSoundNamed: @"button_tap2.wav"];
    
    id<StatementProtocol> statement = [self.questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    [self.record.testAnswers setAnswerType: AnswerTypePositive
                            forStatementID: statement.statementID];
    if (![self setNextStatementIndex])
    {
        [self performSegueWithIdentifier: kSegueAnalyzer
                                  sender: nil];
    }
}


#pragma mark -
#pragma mark private

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
    id<StatementProtocol> statement = [self.questionnaire statementAtIndex: _statementIndex];
    FRB_AssertNotNil(statement);
    
    if ((_statementIndex < self.questionnaire.statementsCount-1) &&
        ([self.record.testAnswers answerTypeForStatementID: statement.statementID] != AnswerTypeUnknown))
    {
        [self setStatementIndex: _statementIndex+1];
        return YES;
    }
    else return NO;
}


- (void) setStatementIndex: (NSUInteger) index
{
    if (index < self.questionnaire.statementsCount)
    {
        _statementIndex = index;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: index
                                                                   inSection: 0]
                              atScrollPosition: UITableViewScrollPositionMiddle
                                      animated: NO];
        
        self.title = [NSString stringWithFormat: ___FORMAT_N_of_M,
                      _statementIndex+1, self.questionnaire.statementsCount];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    StatementTableViewCell *cell =
    (StatementTableViewCell *)[super tableView: tableView
                         cellForRowAtIndexPath: indexPath];
    FRB_AssertClass(cell, StatementTableViewCell);
    
    id<StatementProtocol> statement = [self statementAtIndexPath: indexPath];
    FRB_AssertNotNil(statement);
    
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

    return cell;
}

@end
