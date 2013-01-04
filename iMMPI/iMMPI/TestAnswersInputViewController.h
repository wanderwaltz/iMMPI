//
//  TestAnswersInputViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


#pragma mark -
#pragma mark TestAnswersInputViewController interface

@interface TestAnswersInputViewController : UITableViewController
@property (strong, nonatomic) id<TestRecordProtocol> record;
@property (strong, nonatomic) id<TestRecordStorage>  storage;

@end
