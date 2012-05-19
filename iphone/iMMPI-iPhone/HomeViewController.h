//
//  HomeViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "NewRecordFormViewController.h"


#pragma mark -
#pragma mark HomeViewController interface

@interface HomeViewController : BaseViewController
<NewRecordFormViewControllerDelegate>

- (IBAction) browseRecordsAction: (id) sender;
- (IBAction) addNewRecordAction:  (id) sender;

@end
