//
//  AnalysisViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalysisViewController.h"
#import "AnalyzerTableViewCell.h"
#import "AnalysisOptionsViewController.h"
#import "AnalysisSettings.h"

#import <MessageUI/MessageUI.h>


#pragma mark -
#pragma mark Static constants

static NSString * const kAnalyzerGroupCellIdentifer = @"com.immpi.cells.analyzerGroup";
static NSString * const kSegueIDAnalysisOptions = @"com.immpi.segue.analysisOptions";


#pragma mark -
#pragma mark AnalysisViewController private

@interface AnalysisViewController()
<UIPopoverControllerDelegate,
 AnalysisOptionsViewControllerDelegate,
 MFMailComposeViewControllerDelegate>
{
    Analyzer *_analyzer;
    NSMutableArray *_analyzerGroupIndices;
    
    NSDateFormatter *_dateFormatter;
    
    UIPopoverController *_analysisOptionsPopover;
}

@end


#pragma mark -
#pragma mark AnalysisViewController implementation

@implementation AnalysisViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _analyzerGroupIndices = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark view lifecylce

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // We do init analyzer here since if the view never appears
    // there is no sense loading the data anyway.
    //
    // Once the analyzer has been initialized, this method does
    // nothing.
    [self initAnalyzerInBackgroundIfNeeded];
}


#pragma mark -
#pragma mark private

- (void) initAnalyzerInBackgroundIfNeeded
{
    if (_analyzer == nil)
    {
        _analyzer = [Analyzer new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_analyzer loadGroups];
            [_analyzer computeScoresForRecord: _record];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        });
    }
}


- (void) reloadData
{
    [_analyzerGroupIndices removeAllObjects];
    
    for (NSUInteger i = 0; i < _analyzer.groupsCount; ++i)
    {
        id<AnalyzerGroup> group = [_analyzer groupAtIndex: i];
        
        // Add the index to list if the score is outside norm or filters are off
        if (!group.scoreIsWithinNorm || ![AnalysisSettings shouldHideNormalResults])
            [_analyzerGroupIndices addObject: @(i)];
    }
    
    [self.tableView reloadData];
}


- (void) presentPrintingInterface
{
    UIPrintInteractionController *printController =
    [UIPrintInteractionController sharedPrintController];
    
    UIMarkupTextPrintFormatter *formatter =
    [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: [self composeHTMLAnalysisReport]];
    
    printController.printFormatter = formatter;
    
    [printController presentFromBarButtonItem: self.navigationItem.rightBarButtonItem
                                     animated: YES
                            completionHandler:
     ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error)
     {
                                
    }];
}


- (void) presentEmailInterface
{
    MFMailComposeViewController *controller =
    [MFMailComposeViewController new];
    
    controller.mailComposeDelegate = self;
    
    [controller setToRecipients: @[@"sasha-e2000@mail.ru"]];
    [controller setSubject: @"Результаты тестирования"];
    
    
    NSString *htmlReport   = [self composeHTMLAnalysisReport];
    NSData *htmlReportData = [htmlReport dataUsingEncoding: NSUTF8StringEncoding];
    
    [controller addAttachmentData: htmlReportData
                         mimeType: @"text/html"
                         fileName: [NSString stringWithFormat: @"%@%@.html",
                                    self.record.person.name,
                                    [_dateFormatter stringFromDate: self.record.date]]];
    
    [self presentViewController: controller
                       animated: YES
                     completion: nil];
}


- (NSString *) composeHTMLAnalysisReport
{
    NSMutableString *html = [NSMutableString string];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    [html appendFormat: @"<h1>%@</h1>", self.record.person.name];
    
    NSString *dateString = [dateFormatter stringFromDate: self.record.date];
    
    if (dateString.length > 0)
    [html appendFormat: @"<h2>%@</h2>", dateString];
    
    [html appendString: @"<table width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\" 1%\">"];
    [html appendString: @"<col width=\" 4%\">"];
    [html appendString: @"<col width=\" 5%\">"];
    [html appendString: @"<col width=\"75%\">"];
    [html appendString: @"<col width=\"15%\">"];
    [html appendString: @"</colgroup>"];
    
    for (NSNumber *groupIndexNumber in _analyzerGroupIndices)
    {
        NSInteger groupIndex = [groupIndexNumber integerValue];
        
        id<AnalyzerGroup> group = [_analyzer groupAtIndex: groupIndex];
        
        [html appendString: @"<tr>"];
        
        switch ([_analyzer depthOfGroupAtIndex: groupIndex])
        {
            case 0:
            {
                [html appendString: @"<td colspan=\"1\"></td>"];
                [html appendFormat: @"<td colspan=\"3\"><b>%@</b></td>", group.name];
            } break;
                
                
            case 1:
            {
                [html appendString: @"<td colspan=\"2\"></td>"];
                [html appendFormat: @"<td colspan=\"2\">%@</td>", group.name];
            } break;
                
                
            default:
            {
                [html appendString: @"<td colspan=\"3\"></td>"];
                [html appendFormat: @"<td colspan=\"1\"><i>%@</i></td>", group.name];
            } break;
        }
        
        if ([group scoreIsWithinNorm])
            [html appendFormat: @"<td>%@</td>", ___Normal_Score_Placeholder];
        else
            [html appendFormat: @"<td>%@</td>", group.readableScore];
        
        [html appendString: @"</tr>"];
    }
    
    [html appendString: @"</table>"];
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


#pragma mark -
#pragma mark storyboard

- (BOOL) shouldPerformSegueWithIdentifier: (NSString *) identifier
                                   sender: (id) sender
{
    if ([identifier isEqualToString: kSegueIDAnalysisOptions])
    {
        if (_analysisOptionsPopover != nil)
        {
            [_analysisOptionsPopover dismissPopoverAnimated: YES];
             _analysisOptionsPopover = nil;
            return NO;
        }
    }
    
    return YES;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue
                  sender: (id) sender
{
    [super prepareForSegue: segue
                    sender: sender];
    
    if ([segue.identifier isEqualToString: kSegueIDAnalysisOptions])
    {
        AnalysisOptionsViewController *controller =
        (id)SelfOrFirstChild(segue.destinationViewController);
        
        FRB_AssertClass(controller, AnalysisOptionsViewController);
        controller.delegate = self;
        
        FRB_AssertClass(segue, UIStoryboardPopoverSegue);
        _analysisOptionsPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        _analysisOptionsPopover.delegate = self;
    }
}


#pragma mark -
#pragma mark AnalysisOptionsViewControllerDelegate

- (void) analysisOptionsViewControllerSettingsChanged:
 (AnalysisOptionsViewController *) controller
{
    [self reloadData];
}


- (void) analysisOptionsViewControllerPrintOptionSelected:
 (AnalysisOptionsViewController *) controller
{
    [_analysisOptionsPopover dismissPopoverAnimated: YES];
     _analysisOptionsPopover = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentPrintingInterface];
    });
}


- (void) analysisOptionsViewControllerEmailOptionSelected:
 (AnalysisOptionsViewController *)controller
{
    [_analysisOptionsPopover dismissPopoverAnimated: YES];
     _analysisOptionsPopover = nil;
    
    [self presentEmailInterface];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller
           didFinishWithResult: (MFMailComposeResult) result
                         error: (NSError *) error
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate

- (void) popoverControllerDidDismissPopover: (UIPopoverController *) popoverController
{
    if (popoverController == _analysisOptionsPopover)
    {
        _analysisOptionsPopover = nil;
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return _analyzerGroupIndices.count;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    AnalyzerTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:
                                       kAnalyzerGroupCellIdentifer];
    FRB_AssertClass(cell, AnalyzerTableViewCell);
    
    NSUInteger groupIndex = [_analyzerGroupIndices[indexPath.row] integerValue];

    id<AnalyzerGroup> group = [_analyzer groupAtIndex:        groupIndex];
    NSUInteger        depth = [_analyzer depthOfGroupAtIndex: groupIndex];
    
    
    // If we hide the scores which are within the norm, there may be a situation
    // when the group's parent group is hidden, while the group itself is not.
    // In that case we'll have the offset of the child group still equal to
    // larger value and it will look like this group is child to some other group
    // which is wrong. So we reset all of the offsets if 'hide normal' setting
    // is set to on. Offset zero is reserved for the larger groups which are
    // always present, so we cap the offset at the value of 1
    if ([AnalysisSettings shouldHideNormalResults] && depth > 1) depth = 1;
    
    cell.groupNameLabel.text = group.name;
    cell.groupNameOffset     = depth * 40;
    
    switch (depth)
    {
        case 0:
        {
            cell.groupNameLabel.font = [UIFont boldSystemFontOfSize: 18.0];
        } break;
            
            
        case 1:
        {
            cell.groupNameLabel.font = [UIFont systemFontOfSize: 18.0];
        } break;
            
            
        default:
        {
            cell.groupNameLabel.font = [UIFont italicSystemFontOfSize: 16.0];
        } break;
    }
    
    cell.scoreLabel.font = cell.groupNameLabel.font;
    
    
    if ([AnalysisSettings shouldFilterAnalysisResults] && group.scoreIsWithinNorm)
        cell.scoreLabel.text = ___Normal_Score_Placeholder;
    else
        cell.scoreLabel.text = [group readableScore];

    
    return cell;
}


#pragma mark -
#pragma mark SegueDestinationAnalyzeRecord

- (void) setRecordForAnalysis: (id<TestRecordProtocol>) record
{
    self.record = record;
    
    self.title = [NSString stringWithFormat: @"%@, %@",
                  record.person.name, [_dateFormatter stringFromDate: record.date]];
}


@end
