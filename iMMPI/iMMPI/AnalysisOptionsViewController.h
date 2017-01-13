//
//  AnalysisOptionsViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark AnalysisOptionsViewControllerDelegate protocol

@class AnalysisOptionsViewController;

@protocol AnalysisOptionsViewControllerDelegate<NSObject>
@required

- (void)analysisOptionsViewControllerSettingsChanged:(AnalysisOptionsViewController *)controller;
- (void)analysisOptionsViewControllerPrintOptionSelected:(AnalysisOptionsViewController *)controller;
- (void)analysisOptionsViewControllerEmailOptionSelected:(AnalysisOptionsViewController *)controller;

@end


#pragma mark -
#pragma mark AnalysisOptionsViewController interface

@interface AnalysisOptionsViewController: UITableViewController
@property (weak, nonatomic) id<AnalysisOptionsViewControllerDelegate> _Nullable delegate;
@end

NS_ASSUME_NONNULL_END
