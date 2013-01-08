//
//  PersonsListViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"

#pragma mark -
#pragma mark PersonsListViewController interface

@interface PersonsListViewController : StoryboardManagedTableViewController
<SegueSourceEditAnswers,
 SegueSourceEditRecord,
 SegueSourceListRecords>

@end
