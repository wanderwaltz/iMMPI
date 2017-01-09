//
//  FRBDatePickerPopover.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark FRBDatePickerPopoverDelegate protocol

@class FRBDatePickerPopover;

@protocol FRBDatePickerPopoverDateDelegate<NSObject>
@optional

- (void)FRBDatePickerPopover:(FRBDatePickerPopover *)popover
               didSelectDate:(NSDate *)date;

@end


#pragma mark -
#pragma mark FRBDatePickerPopover interface

@interface FRBDatePickerPopover: UIPopoverController

@property (weak, nonatomic) id<FRBDatePickerPopoverDateDelegate> _Nullable dateDelegate;

@property (strong, nonatomic) NSString * _Nullable title;
@property (strong, nonatomic) NSDate   *date;

@property (assign, nonatomic) UIDatePickerMode datePickerMode;


@end

NS_ASSUME_NONNULL_END
