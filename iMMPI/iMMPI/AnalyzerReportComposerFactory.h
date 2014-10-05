//
//  AnalyzerReportComposerFactory.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnalyzerReportComposer;
@protocol QuestionnaireProtocol;

@interface AnalyzerReportComposerFactory : NSObject

+ (id<AnalyzerReportComposer>)answersReportComposerWithQuestionnaire:(id<QuestionnaireProtocol>)questionnaire;

@end
