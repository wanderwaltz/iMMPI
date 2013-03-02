//
//  AnalysisSettings.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 03.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark AnalysisSettings interface

@interface AnalysisSettings : NSObject

/*! Decides whether the analysis scores which are in the 'normal' interval should be replaced by dashes '-' so that the 'out-of-norm' values are more visible.
 */
+ (BOOL) shouldFilterAnalysisResults;


/*! Decides whether the analysis scores which are in the 'normal' interval should be completely hidden from the analysis view.
 */
+ (BOOL) shouldHideNormalResults;


+ (void) setShouldFilterAnalysisResults: (BOOL) shouldFilter;

+ (void) setShouldHideNormalResults: (BOOL) shouldHide;

@end
