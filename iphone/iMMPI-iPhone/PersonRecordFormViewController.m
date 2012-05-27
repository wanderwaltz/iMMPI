//
//  NewRecordFormViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "PersonRecordFormViewController.h"

#pragma mark -
#pragma mark Table View Definitions

enum
{
    kTableViewRowFirstName,
    kTableViewRowLastName,
    kTableViewRowBirthDate
};


#pragma mark -
#pragma mark PersonRecordFormViewController implementation

@implementation PersonRecordFormViewController

#pragma mark -
#pragma mark Properties

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Actions 

- (void) cancelButtonAction: (id) sender
{
    [self cancel];
}


- (void) nextButtonAction: (id) sender
{
    [self saveRecord: nil];
}


#pragma mark -
#pragma mark Model

- (void) setupModel
{
    _tableSections = [NSMutableArray array];
    
    [_tableSections addObject:
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithInt: kTableViewRowLastName],
      [NSNumber numberWithInt: kTableViewRowFirstName], nil]];
    
    [_tableSections addObject:
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithInt: kTableViewRowBirthDate], nil]];
}


#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self setupModel];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [_tableView reloadData];
    [self focusRow: 0 inSection: 0];
}


#pragma mark -
#pragma mark View methods

- (void) focusRow: (NSUInteger) row inSection: (NSUInteger) section
{
    WWTextFieldTableViewCell *cell =
    (id)[_tableView cellForRowAtIndexPath: 
         [NSIndexPath indexPathForRow: row inSection: section]];
    
    [cell.textField becomeFirstResponder]; 
}


- (void) focusRowWithID: (NSUInteger) rowID
{
    for (NSUInteger section = 0; section < _tableSections.count; ++section)
    {
        NSArray *rows = [_tableSections objectAtIndex: section];
        for (NSUInteger row = 0; row < rows.count; ++row)
        {
            NSNumber *rowIDNumber = [rows objectAtIndex: row];
            NSUInteger ID = [rowIDNumber unsignedIntValue];
            
            if (rowID == ID)
            {
                [self focusRow: row inSection: section];
                return;
            }
        }
    }
}


#pragma mark -
#pragma mark Delegate callbacks

- (void) cancel
{
    [[(id)_delegate ifResponds] 
     personRecordFormViewControllerDidCancel: self];
}


- (void) saveRecord: (id) record
{
    [[(id)_delegate ifResponds] 
     personRecordFormViewController: self                           
                      didSaveRecord: record];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return _tableSections.count;
}


- (NSInteger) tableView: (UITableView *) tableView 
  numberOfRowsInSection: (NSInteger) section
{
    NSArray *rows = [_tableSections objectAtIndex: section];
    return rows.count;
}


- (UITableViewCell *) tableView: (UITableView *) tableView 
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    WWTextFieldTableViewCell *cell = 
    [WWTextFieldTableViewCell cellForTableView: tableView
                                    setupBlock: 
     ^(WWTextFieldTableViewCell *cell)
     {
         cell.selectionStyle          = UITableViewCellSelectionStyleNone;
         cell.textLabel.numberOfLines = 2;
     }
                                         style: UITableViewCellStyleValue2];
    
    cell.delegate = self;
    
    cell.textField.textAlignment = UITextAlignmentLeft;
    cell.textField.textColor     = [UIColor blackColor];
    
    NSArray  *rows = [_tableSections objectAtIndex: indexPath.section];
    NSNumber *row  = [rows objectAtIndex: indexPath.row];
    
    NSUInteger rowID = [row unsignedIntValue];
    
    switch (rowID)
    {
        case kTableViewRowFirstName:
        {
            cell.textLabel.text = NSLocalizedString(@"Имя", @"First Name");
            cell.textField.returnKeyType = UIReturnKeyNext;
        } break;
            
        case kTableViewRowLastName:
        {
            cell.textLabel.text = NSLocalizedString(@"Фамилия", @"Last Name");
            cell.textField.returnKeyType = UIReturnKeyNext;
        } break;
            
        case kTableViewRowBirthDate:
        {
            cell.textLabel.text = NSLocalizedString(@"Дата рождения", @"Birth Date");
            cell.textField.returnKeyType = UIReturnKeyDone;
        } break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void) textFieldTableViewCell: (WWTextFieldTableViewCell *) cell
                  didEndEditing: (NSString *) text
{
    NSIndexPath *indexPath = [_tableView indexPathForCell: cell];
    NSArray  *rows = [_tableSections objectAtIndex: indexPath.section];
    NSNumber *row  = [rows objectAtIndex: indexPath.row];
    
    NSUInteger rowID = [row unsignedIntValue];
    
    switch (rowID)
    {
        case kTableViewRowFirstName:
        {
            [_person setFirstName: text];
        } break;
            
        case kTableViewRowLastName:
        {
            [_person setLastName: text];
        } break;
            
        case kTableViewRowBirthDate:
        {
        
        } break;
    }
}

- (BOOL) textFieldTableViewCell: (WWTextFieldTableViewCell *) cell
          textFieldShouldReturn: (UITextField *) textField
{
    NSIndexPath *indexPath = [_tableView indexPathForCell: cell];
    NSArray  *rows = [_tableSections objectAtIndex: indexPath.section];
    NSNumber *row  = [rows objectAtIndex: indexPath.row];
    
    NSUInteger rowID = [row unsignedIntValue];
    
    switch (rowID)
    {
        case kTableViewRowFirstName:
        {
            [self focusRowWithID: kTableViewRowBirthDate];
        } break;
            
        case kTableViewRowLastName:
        {
            [self focusRowWithID: kTableViewRowFirstName];
        } break;
                        
        case kTableViewRowBirthDate:
        {
            [self.view endEditing: NO];
        } break;
    }
    
    return NO;
}

@end
