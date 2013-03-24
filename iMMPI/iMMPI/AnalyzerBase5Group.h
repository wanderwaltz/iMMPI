//
//  AnalyzerBase5Group.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 23.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerFGroupFM.h"


#pragma mark -
#pragma mark AnalyzerBase5Group interface

/*! Implements a special type of scale based on a standard FM scale type (F scale with gender-dependent answer sets), but the computation differs slightly for females - difference between number of matches and the median value is taken into account with the opposite sign.
 */
@interface AnalyzerBase5Group : AnalyzerFGroupFM
@end
