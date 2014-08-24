//
//  AnalyzerProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Analyzer protocol

@protocol AnalyzerProtocol<NSObject>
@required

- (id<AnalyzerGroup>) firstGroupForType: (NSString *) type;

- (BOOL) isValidStatementID: (NSInteger) statementID;


/*! Сумма Тэра, используется при расчете баллов по шкалам 95-104,
    представленных в данном приложении классами AnalyzerIGroupT1,
    AnalyzerIGroupX, AnalyzerIGroup99.
 
    Представляет собой сумму процентов совпадений по шкалам 95-98
 */
- (NSUInteger) taerSumForRecord: (id<TestRecordProtocol>) record;

@end
