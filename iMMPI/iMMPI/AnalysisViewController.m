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


#pragma mark -
#pragma mark Static constants

static NSString * const kAnalyzerGroupCellIdentifer = @"com.immpi.cells.analyzerGroup";


#pragma mark -
#pragma mark AnalysisViewController private

@interface AnalysisViewController()
{
    Analyzer *_analyzer;
}

@end


#pragma mark -
#pragma mark AnalysisViewController implementation

@implementation AnalysisViewController

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
                [self.tableView reloadData];
            });
        });
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
    return _analyzer.groupsCount;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    AnalyzerTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:
                                       kAnalyzerGroupCellIdentifer];
    FRB_AssertClass(cell, AnalyzerTableViewCell);
    
    NSUInteger groupIndex = indexPath.row;

    id<AnalyzerGroup> group = [_analyzer groupAtIndex:        groupIndex];
    NSUInteger        depth = [_analyzer depthOfGroupAtIndex: groupIndex];
    
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
    
    if (isnan(group.score))
    {
        cell.scoreLabel.text = @"";
    }
    else
    {
        if (group.score >= 0.0)
        {
            if (fabs(group.score-trunc(group.score) > 0.1))
                cell.scoreLabel.text = [NSString stringWithFormat: @"%.1lf", group.score];
            else
                cell.scoreLabel.text = [NSString stringWithFormat: @"%.0lf", group.score];
        }
        else
        {
            cell.scoreLabel.text = ___Score_Invalid;
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark SegueDestinationAnalyzeRecord

- (void) setRecordForAnalysis: (id<TestRecordProtocol>) record
{
    self.record = record;
}


@end
