//
//  BrowseRecordsViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonIndexModel.h"

#pragma mark -
#pragma mark BrowseRecordsViewController interface

@interface BrowsePersonsViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UISegmentedControl *_sortControl;
    IBOutlet UITableView        *_tableView;
    
    PersonIndexModel *_model;
}


@end
