//
//  EditPersonViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "Person.h"

#pragma mark -
#pragma mark Forward declarations

@class EditPersonViewController;


#pragma mark -
#pragma mark EditPersonViewControllerDelegate protocol

@protocol EditPersonViewControllerDelegate<NSObject>
@optional

- (void) editPersonViewControllerDidCancel: (EditPersonViewController *) controller;

- (void) editPersonViewController: (EditPersonViewController *) controller
                    didSavePerson: (Person *) record;

@end


#pragma mark -
#pragma mark EditPersonViewController interface

@interface EditPersonViewController : BaseViewController
    <UITableViewDelegate, 
     UITableViewDataSource,
     WWTextFieldTableViewCellDelegate>
{
    // Model
    __weak id<EditPersonViewControllerDelegate> _delegate;
    
    Person *_person;
    
    NSMutableArray *_tableSections;
    
    // UI
    IBOutlet UITableView *_tableView;
}

@property (weak, nonatomic) id<EditPersonViewControllerDelegate> delegate;

- (IBAction) cancelButtonAction: (id) sender;
- (IBAction) nextButtonAction:   (id) sender;

+ (id) instanceWithPerson: (Person *) person NS_RETURNS_NOT_RETAINED;
- (id) initWithPerson:     (Person *) person NS_RETURNS_RETAINED;

@end
