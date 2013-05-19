//
//  AnalyzerFGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerGroupBase.h"


#pragma mark -
#pragma mark AnalyzerFGroup interface

@interface AnalyzerFGroup : AnalyzerGroupBase

@property (readonly, nonatomic) NSArray *positiveIndices;
@property (readonly, nonatomic) NSArray *negativeIndices;

@property (readonly, nonatomic) double medianMale;
@property (readonly, nonatomic) double medianFemale;
@property (readonly, nonatomic) double deviationMale;
@property (readonly, nonatomic) double deviationFemale;


@end
