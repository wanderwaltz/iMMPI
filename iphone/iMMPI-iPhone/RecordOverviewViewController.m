//
//  RecordOverviewViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "RecordOverviewViewController.h"
#import "TestStatementViewController.h"

#pragma mark -
#pragma mark RecordOverviewViewController implementation

@implementation RecordOverviewViewController

#pragma mark -
#pragma mark Actions

- (void) startTestAction: (id) sender
{
    [self presentTestStatement];
}


- (void) reviewResultsAction: (id) sender
{
    
}


- (void) exportAction: (id) sender
{
    
}


#pragma mark -
#pragma mark initialization methods

+ (id) instanceWithMMPIDocument: (MMPIDocument *) document
{
    return [[[self class] alloc] initWithMMPIDocument: document];
}


- (id) initWithMMPIDocument: (MMPIDocument *) document
{
    self = [super init];
    
    if (self != nil)
    {
        _document  = document;
        self.title = document.personIndexRecord.fullName;
    }
    return self;
}


#pragma mark -
#pragma mark Navigation

- (void) presentTestStatement
{
    TestStatementViewController *controller = 
    [TestStatementViewController instance];
    
    [self.navigationController pushViewController: controller 
                                         animated: YES];
}


@end
