#if 0
//
//  AnalysisHTMLReportGenerator.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Analyzer;
@protocol QuestionnaireProtocol;
@protocol TestRecordProtocol;

#pragma mark -
#pragma mark AnalysisHTMLReportGenerator interface

@interface AnalysisHTMLReportGenerator : NSObject
@property (strong, nonatomic) Analyzer *analyzer;
@property (strong, nonatomic) id<QuestionnaireProtocol> questionnaire;
@property (strong, nonatomic) id<TestRecordProtocol> record;

/// If groupIndices == nil, includes all of the analysis groups in the report
- (NSString *)composeOverallAnalysisReportForGroupIndices:(NSArray *)groupIndices
                                         filterNormValues:(BOOL)filter;

- (NSString *)composeDetailedReportForGroupNamed:(NSString *)groupName;

- (NSString *)composeAnswersReport;

@end
#endif
