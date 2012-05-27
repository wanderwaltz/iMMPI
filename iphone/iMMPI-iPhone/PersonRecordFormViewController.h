//
//  NewRecordFormViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonRecordProtocol.h"

#pragma mark -
#pragma mark Forward declarations

@class PersonRecordFormViewController;


#pragma mark -
#pragma mark PersonRecordFormViewControllerDelegate protocol

@protocol PersonRecordFormViewControllerDelegate<NSObject>
@optional

- (void) personRecordFormViewControllerDidCancel: (PersonRecordFormViewController *) controller;

- (void) personRecordFormViewController: (PersonRecordFormViewController *) controller
                          didSaveRecord: (id) record;

@end


#pragma mark -
#pragma mark PersonRecordFormViewController interface

@interface PersonRecordFormViewController : BaseViewController
    <UITableViewDelegate, 
     UITableViewDataSource,
     WWTextFieldTableViewCellDelegate>
{
    // Model
    __weak id<PersonRecordFormViewControllerDelegate> _delegate;
    
    id<PersonRecordProtocol> _person;
    
    NSMutableArray *_tableSections;
    
    // UI
    IBOutlet UITableView *_tableView;
}

@property (weak, nonatomic) id<PersonRecordFormViewControllerDelegate> delegate;

- (IBAction) cancelButtonAction: (id) sender;
- (IBAction) nextButtonAction:   (id) sender;

@end
