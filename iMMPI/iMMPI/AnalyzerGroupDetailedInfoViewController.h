//
//  AnalyzerGroupDetailedInfoViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"
#import "Model.h"


#pragma mark -
#pragma mark AnalyzerGroupDetailedInfoViewControllerDelegate protocol

@class AnalyzerGroupDetailedInfoViewController;

@protocol AnalyzerGroupDetailedInfoViewControllerDelegate<NSObject>
@optional

- (void) analyzerGroudDetailedInfoViewControllerDidCancel:
            (AnalyzerGroupDetailedInfoViewController *) controller;

@end


#pragma mark -
#pragma mark AnalyzerGroupDetailedInfoViewController interface

@interface AnalyzerGroupDetailedInfoViewController : StoryboardManagedViewController
<SegueDestinationAnalyzerGroupDetailedInfo>

@property (weak, nonatomic) id<AnalyzerGroupDetailedInfoViewControllerDelegate> delegate;

@property (strong, nonatomic) id<AnalyzerGroup> analyzerGroup;
@property (strong, nonatomic) id<TestRecordProtocol> record;

@end
