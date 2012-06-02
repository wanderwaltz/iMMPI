//
//  ListModelViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "ListModel.h"

#pragma mark -
#pragma mark ListModelViewController interface

@interface ListModelViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource>
{
    id<ListModel> _model;
    BOOL _needsReload;
    
    IBOutlet UITableView *_tableView;
}

@property (strong, nonatomic) id<ListModel> model;

- (void) setNeedsReload;
- (void) reloadIfNeeded;
- (void) reload;

@end
