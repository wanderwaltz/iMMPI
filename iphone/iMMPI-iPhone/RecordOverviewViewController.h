//
//  RecordOverviewViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"

#pragma mark -
#pragma mark RecordOverviewViewController interface

@interface RecordOverviewViewController : BaseViewController

- (IBAction) startTestAction:     (id) sender;
- (IBAction) reviewResultsAction: (id) sender;
- (IBAction) exportAction:        (id) sender;

@end
