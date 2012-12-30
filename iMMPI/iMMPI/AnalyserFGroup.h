//
//  AnalyserFGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "AnalyserGroupBase.h"


#pragma mark -
#pragma mark AnalyserFGroup interface

@interface AnalyserFGroup : AnalyserGroupBase

@property (readonly, nonatomic) double medianMale;
@property (readonly, nonatomic) double medianFemale;
@property (readonly, nonatomic) double deviationMale;
@property (readonly, nonatomic) double deviationFemale;


@end
