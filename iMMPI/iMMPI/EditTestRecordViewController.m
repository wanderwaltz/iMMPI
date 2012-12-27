//
//  NewRecordViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "EditTestRecordViewController.h"


#pragma mark -
#pragma mark NewRecordViewController private

@interface EditTestRecordViewController()
{
    IBOutlet UITextField *_fullNameTextField;
    IBOutlet UILabel     *_genderLabel;
    IBOutlet UILabel     *_ageGroupLabel;
    IBOutlet UILabel     *_dateLabel;
    
    IBOutlet UITableViewCell *_genderTableViewCell;
    IBOutlet UITableViewCell *_ageGroupTableViewCell;
    IBOutlet UITableViewCell *_dateTableViewCell;
}

@end


#pragma mark -
#pragma mark NewRecordViewController implementation

@implementation EditTestRecordViewController

#pragma mark -
#pragma mark view lifecycle

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    [_fullNameTextField becomeFirstResponder];
}


@end
