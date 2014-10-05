//
//  AnswersListReportComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzerReportComposer.h"
#import "HtmlTableReportComposer.h"

@protocol QuestionnaireProtocol;

@interface AnswersListReportComposer : NSObject<AnalyzerReportComposer, HtmlTableReportComposerDataSource>

- (instancetype)initWithHtmlTableReportComposer:(id<HtmlTableReportComposer>)tableComposer
                    questionnaire:(id<QuestionnaireProtocol>)questionnaire;

@end
