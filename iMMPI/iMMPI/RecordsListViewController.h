//
//  RecordsListViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"
#import "Model.h"


#pragma mark -
#pragma mark RecordsListViewController interface

@interface RecordsListViewController : StoryboardManagedTableViewController
<SegueDestinationListRecords>

@property (strong, nonatomic) id<TestRecordStorage>   storage;
@property (strong, nonatomic) id<MutableTableViewModel> model;

@end
