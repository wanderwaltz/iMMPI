//
//  RecordOverviewViewController.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"
#import "DataStorage.h"

#pragma mark -
#pragma mark RecordOverviewViewController interface

@interface RecordOverviewViewController : BaseViewController
{
    MMPIDocument *_document;
}

+ (id) instanceWithMMPIDocument: (MMPIDocument *) document NS_RETURNS_NOT_RETAINED;
- (id) initWithMMPIDocument:     (MMPIDocument *) document NS_RETURNS_RETAINED;

- (IBAction) startTestAction:     (id) sender;
- (IBAction) reviewResultsAction: (id) sender;
- (IBAction) exportAction:        (id) sender;

@end
