//
//  AnalyzerFGroupFM.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerGroupBase.h"


#pragma mark -
#pragma mark AnalyzerFGroupFM interface

@interface AnalyzerFGroupFM : AnalyzerGroupBase

@property (readonly, nonatomic) NSArray *malePositiveIndices;
@property (readonly, nonatomic) NSArray *maleNegativeIndices;

@property (readonly, nonatomic) NSArray *femalePositiveIndices;
@property (readonly, nonatomic) NSArray *femaleNegativeIndices;

@property (readonly, nonatomic) double medianMale;
@property (readonly, nonatomic) double deviationMale;

@property (readonly, nonatomic) double medianFemale;
@property (readonly, nonatomic) double deviationFemale;

@end
