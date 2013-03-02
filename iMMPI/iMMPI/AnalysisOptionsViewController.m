//
//  AnalysisOptionsViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalysisOptionsViewController.h"
#import "AnalysisSettings.h"


#pragma mark -
#pragma mark Static constants

static NSString * kCellIdentifierEnableFilter  = @"com.immpi.cells.enableFilter";
static NSString * kCellIdentifierHideFiltered  = @"com.immpi.cells.hideFiltered";
static NSString * kCellIdentifierEmailAnalysis = @"com.immpi.cells.emailAnalysis";
static NSString * kCellIdentifierPrintAnalysis = @"com.immpi.cells.printAnalysis";

static const NSInteger kCellUISwitchTag = 1;


#pragma mark -
#pragma mark AnalysisOptionsViewController private

@interface AnalysisOptionsViewController()
{
    NSMutableArray *_cellIdentifiers;
}

@end


#pragma mark -
#pragma mark AnalysisOptionsViewController implementaiton

@implementation AnalysisOptionsViewController

#pragma mark -
#pragma mark inititialization methods

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _cellIdentifiers = [NSMutableArray arrayWithCapacity: 4];
        
        [_cellIdentifiers addObject:  kCellIdentifierEnableFilter];
        
        if ([AnalysisSettings shouldFilterAnalysisResults])
            [_cellIdentifiers addObject: kCellIdentifierHideFiltered];
        
        [_cellIdentifiers addObject: kCellIdentifierEmailAnalysis];
        [_cellIdentifiers addObject: kCellIdentifierPrintAnalysis];
    }
    return self;
}


#pragma mark -
#pragma mark actions

- (void) enableFilterSwitchChanged: (UISwitch *) sender
{
    [AnalysisSettings setShouldFilterAnalysisResults: sender.on];
    
    if (sender.on)
    {
        [_cellIdentifiers insertObject: kCellIdentifierHideFiltered atIndex: 1];
        [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 1
                                                                     inSection: 0]]
                              withRowAnimation: UITableViewRowAnimationAutomatic];
    }
    else
    {
        [AnalysisSettings setShouldHideNormalResults: NO];
        
        [_cellIdentifiers removeObject: kCellIdentifierHideFiltered];
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 1
                                                                     inSection: 0]]
                              withRowAnimation: UITableViewRowAnimationAutomatic];
    }
    
    [_delegate analysisOptionsViewControllerSettingsChanged: self];
}


- (void) hideFilteredSwitchChanged: (UISwitch *) sender
{
    [AnalysisSettings setShouldHideNormalResults: sender.on];
    [_delegate analysisOptionsViewControllerSettingsChanged: self];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)      tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
}


#pragma mark - 
#pragma mark Table view data source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return _cellIdentifiers.count;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSString *cellIdentifier = _cellIdentifiers[indexPath.row];
    UITableViewCell    *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if ([cellIdentifier isEqualToString: kCellIdentifierEnableFilter])
    {
        UISwitch *uiswitch = (UISwitch *)[cell viewWithTag: kCellUISwitchTag];
        FRB_AssertClass(uiswitch, UISwitch);
        
        uiswitch.on = [AnalysisSettings shouldFilterAnalysisResults];
        
        [uiswitch addTarget: self
                     action: @selector(enableFilterSwitchChanged:)
           forControlEvents: UIControlEventValueChanged];
    }
    else if ([cellIdentifier isEqualToString: kCellIdentifierHideFiltered])
    {
        UISwitch *uiswitch = (UISwitch *)[cell viewWithTag: kCellUISwitchTag];
        FRB_AssertClass(uiswitch, UISwitch);
        
        uiswitch.on = [AnalysisSettings shouldHideNormalResults];
        
        [uiswitch addTarget: self
                     action: @selector(hideFilteredSwitchChanged:)
           forControlEvents: UIControlEventValueChanged];

    }
    
    return cell;
}

@end
