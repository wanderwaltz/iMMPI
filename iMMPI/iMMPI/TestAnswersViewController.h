//
//  TestAnswersViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


#pragma mark -
#pragma mark TestAnswersViewController interface

@interface TestAnswersViewController : UITableViewController
@property (strong, nonatomic) id<TestRecord> record;
@property (strong, nonatomic) id<TestRecordStorage> storage;

@end
