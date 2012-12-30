//
//  EditTestRecordViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "EditTestRecordViewController.h"
#import "Model.h"


#pragma mark -
#pragma mark Static constants

enum
{
    kTableRowName = 0,
    kTableRowGender,
    kTableRowAgeGroup,
    kTableRowDate
};


#pragma mark -
#pragma mark EditTestRecordViewController private

@interface EditTestRecordViewController()<FRBDatePickerPopoverDateDelegate>
{
    IBOutlet UITextField *_fullNameTextField;
    IBOutlet UILabel     *_genderLabel;
    IBOutlet UILabel     *_ageGroupLabel;
    IBOutlet UILabel     *_dateLabel;
    
    IBOutlet UITableViewCell *_genderTableViewCell;
    IBOutlet UITableViewCell *_ageGroupTableViewCell;
    IBOutlet UITableViewCell *_dateTableViewCell;
        
    Gender    _selectedGender;
    AgeGroup  _selectedAgeGroup;
    NSDate   *_selectedDate;
    NSString *_personName;
    
    NSDateFormatter *_dateFormatter;
    
    FRBKeyedTargetAction *_cellSelectActions;
    FRBDatePickerPopover *_datePickerPopover;
}

@end


#pragma mark -
#pragma mark EditTestRecordViewController implementation

@implementation EditTestRecordViewController

#pragma mark -
#pragma mark properties

- (void) setRecord:(id<TestRecordProtocol>)record
{
    _record = record;
    
    _personName       = record.person.name;
    _selectedGender   = record.person.gender;
    _selectedAgeGroup = record.person.ageGroup;
    _selectedDate     = record.date;
    
    [self updateUI];
}


#pragma mark -
#pragma mark actions

- (IBAction) cancelButtonAction: (id) sender
{
    if ([_delegate respondsToSelector: @selector(editTestRecordViewController:didFinishEditingRecord:)])
    {
        [_delegate editTestRecordViewController: self
                         didFinishEditingRecord: nil];
    }
}


- (IBAction) saveButtonAction: (id) sender
{
    _record.person.name     = _personName;
    _record.person.gender   = _selectedGender;
    _record.person.ageGroup = _selectedAgeGroup;
    _record.date            = _selectedDate;
    
    if ([_delegate respondsToSelector: @selector(editTestRecordViewController:didFinishEditingRecord:
                                                 )])
    {
        [_delegate editTestRecordViewController: self
                         didFinishEditingRecord: _record];
    }
}


#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _selectedGender   = GenderMale;
        _selectedAgeGroup = AgeGroupAdult;
        _selectedDate     = [NSDate date];
        
        _dateFormatter           = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        
        _cellSelectActions = [FRBKeyedTargetAction new];
        _cellSelectActions.target = self;
        _cellSelectActions.inhibitConsoleWarnings = YES;
        [_cellSelectActions addActions: @{
         @(kTableRowAgeGroup) : @"toggleAgeGroup",
         @(kTableRowGender)   : @"toggleGender",
         @(kTableRowDate)     : @"selectDate"
         }];
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    
    _datePickerPopover = [FRBDatePickerPopover new];
    _datePickerPopover.title        = ___Select_Date;
    _datePickerPopover.dateDelegate = self;
    
    [_fullNameTextField addTarget: self
                           action: @selector(textFieldDidChange:)
                 forControlEvents: UIControlEventEditingChanged];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    [_fullNameTextField becomeFirstResponder];
}


- (void) updateUI
{
    switch (_selectedAgeGroup)
    {
        case AgeGroupAdult: _ageGroupLabel.text = ___Age_Group_Adult; break;
        case AgeGroupTeen:  _ageGroupLabel.text = ___Age_Group_Teen;  break;
            
        default: _ageGroupLabel.text = ___Unknown; break;
    }
    
    
    switch (_selectedGender)
    {
        case GenderFemale: _genderLabel.text = ___Gender_Female; break;
        case GenderMale:   _genderLabel.text = ___Gender_Male;   break;
            
        default: _genderLabel.text = ___Unknown; break;
    }
    
    _fullNameTextField.text = _personName;
    _dateLabel.text         = [_dateFormatter stringFromDate: _selectedDate];
}


#pragma mark -
#pragma mark actions

- (void) textFieldDidChange: (id) sender
{
    _personName = _fullNameTextField.text;
}


#pragma mark -
#pragma mark private

- (void) toggleGender
{
    if (_selectedGender == GenderFemale) _selectedGender = GenderMale;
    else _selectedGender = GenderFemale;
    
    [self updateUI];
}


- (void) toggleAgeGroup
{
    if (_selectedAgeGroup == AgeGroupAdult) _selectedAgeGroup = AgeGroupTeen;
    else _selectedAgeGroup = AgeGroupAdult;
    
    [self updateUI];
}


- (void) selectDate
{
    [_datePickerPopover dismissPopoverAnimated: NO];
    [_datePickerPopover presentPopoverFromRect: _dateTableViewCell.bounds
                                        inView: _dateTableViewCell
                      permittedArrowDirections: UIPopoverArrowDirectionAny
                                      animated: YES];
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [_cellSelectActions doActionForKey: @(indexPath.row)];
}


#pragma mark -
#pragma mark FRBDatePickerPopoverDateDelegate

- (void) FRBDatePickerPopover: (FRBDatePickerPopover *) popover
                didSelectDate: (NSDate *) date
{
    _selectedDate = date;
    [self updateUI];
}


@end
