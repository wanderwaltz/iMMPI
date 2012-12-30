//
//  AnalysisViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


#pragma mark -
#pragma mark AnalysisViewController interface

@interface AnalysisViewController : UITableViewController
@property (strong, nonatomic) id<TestRecord> record;

@end
