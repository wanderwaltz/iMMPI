//
//  TestAnswersViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswersViewController.h"
#import "AnalysisViewController.h"

#import "StatementTableViewCell.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kSegueAnalyzer = @"com.immpi.segue.analyzer";

#pragma mark -
#pragma mark TestAnswersViewController private

@interface TestAnswersViewController()<StatementTableViewCellDelegate>
@end


#pragma mark -
#pragma mark TestAnswersViewController implementation

@implementation TestAnswersViewController

#pragma mark -
#pragma mark view lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self loadQuestionnaireAsyncIfNeeded];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear: animated];
    [self saveRecord];
}

@end
