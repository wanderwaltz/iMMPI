//
//  AnalyzerIGroupT1.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroupT1.h"


#pragma mark -
#pragma mark AnalyzerIGroupT1 implementation

@implementation AnalyzerIGroupT1

#pragma mark -
#pragma mark AnalyzerGroup

- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    // Сумма Тэра вычисляется как сумма процентов совпадений по шкалам 95-98
    NSUInteger TaerSum = [analyser taerSumForRecord: record];
    
    // Сумма Тэра попадает в знаменатель, поэтому необходимо проверить,
    // что она положительная.
    if (TaerSum > 0)
    {
        // Формульные единицы для каждой из шкал 95-98 вычисляются на
        // основе процента совпадений, умноженного на 10 и деленного на
        // сумму Тэра.
        NSUInteger percentage = [self computePercentageForRecord: record
                                                        analyser: analyser];
        
        // Здесь идет умножение на 100, которое потом компенсируется делением на 10
        // в конце вычисления. Вероятно, это какой-то остаток из прошлой версии
        // приложения на Delphi, где вычисления были организованы как-то иначе.
        percentage = percentage * 100 / TaerSum;
        
        if (percentage <= A)
            self.score = round(10 * 1.5 * (double)percentage/(double)A);
        
        else if (percentage <= B)
            self.score = round(10*(1.5+(double)(percentage-A)/(double)(B-A)));
        
        else if (percentage <= C)
            self.score = round(10*(2.5+(double)(percentage-B)/(double)(C-B)));
        
        else if (percentage <= D)
            self.score = round(10*(3.5+(double)(percentage-C)/(double)(D-C)));
        else
            self.score = 50;
        
        self.score /= 10.0;
    }
    else self.score = -1;
    
    
    return self.score;
}


@end
