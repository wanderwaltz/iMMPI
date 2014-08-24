//
//  AnalyzerIGroupX.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroupX.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyAnswersPositive = @"answersPositive";
static NSString * const kJSONKeyAnswersNegative = @"answersNegative";


#pragma mark -
#pragma mark AnalyzerIGroupX private

@interface AnalyzerIGroupX()
{
    NSArray *_positiveIndices;
    NSArray *_negativeIndices;
}

@end


#pragma mark -
#pragma mark AnalyzerIGroupX implementation

@implementation AnalyzerIGroupX

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *answersPositiveString = json[kJSONKeyAnswersPositive];
    NSString *answersNegativeString = json[kJSONKeyAnswersNegative];
    
    self = [super initWithJSON: json];
    
    if (self != nil)
    {
        _positiveIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: answersPositiveString];
        _negativeIndices = [AnalyzerGroupBase parseSpaceSeparatedInts: answersNegativeString];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (BOOL) canProvideDetailedInfo
{
    return YES;
}


- (NSString *) htmlDetailedInfoForRecord: (id<TestRecordProtocol>) record
                                analyser: (id<AnalyzerProtocol>) analyser
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString: @"<!DOCTYPE html>"];
    [html appendString: @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString: @"<html>"];
    [html appendString: @"<body>"];
    
    [html appendString: @"<table width=\"100%\">"];
    [html appendString: @"<colgroup>"];
    [html appendString: @"<col width=\"35%\">"];
    [html appendString: @"<col width=\"65%\">"];
    [html appendString: @"</colgroup>"];
    
    void (^addRow)(NSString *left,
                   NSString *right) =
    ^(NSString *left,
      NSString *right)
    {
        [html appendString: @"<tr>"];
        
        [html appendFormat: @"<td colspan=\"1\">%@</td>", left];
        [html appendFormat: @"<td colspan=\"1\">%@</td>", right];
        
        [html appendString: @"</tr>"];
    };
    
    
    NSUInteger TaerSum = [analyser taerSumForRecord: record];
    
    addRow(___Details_Score,    self.readableScore);
    addRow(___Details_Taer_Sum, [NSString stringWithFormat: @"%ld", (long)TaerSum]);
    
    if (TaerSum > 0)
    {
        id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
        id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
        
        NSUInteger p95 = [IScale_95 computePercentageForRecord: record analyser: analyser];
        NSUInteger p96 = [IScale_96 computePercentageForRecord: record analyser: analyser];
        
        NSUInteger FE99 = (p95 + p96) * 100 / TaerSum;
        
        addRow(___Details_Matches_IScale_95, [NSString stringWithFormat: @"%ld%%", (long)p95]);
        addRow(___Details_Matches_IScale_96, [NSString stringWithFormat: @"%ld%%", (long)p96]);
        addRow(___Details_Matches_IScale_99, [NSString stringWithFormat:
                                              @"(%ld + %ld) / %ld == %ld%%", (long)p95, (long)p96, (long)TaerSum, (long)FE99]);
        
        id<AnalyzerGroup> IScale_100 = [analyser firstGroupForType: kGroupType_IScale_100];
        id<AnalyzerGroup> IScale_101 = [analyser firstGroupForType: kGroupType_IScale_101];
        id<AnalyzerGroup> IScale_102 = [analyser firstGroupForType: kGroupType_IScale_102];
        
        NSUInteger p100 = [IScale_100 computePercentageForRecord: record analyser: analyser];
        NSUInteger p101 = [IScale_101 computePercentageForRecord: record analyser: analyser];
        NSUInteger p102 = [IScale_102 computePercentageForRecord: record analyser: analyser];
        
        addRow(___Details_Matches_IScale_100, [NSString stringWithFormat: @"%ld%%", (long)p100]);
        addRow(___Details_Matches_IScale_101, [NSString stringWithFormat: @"%ld%%", (long)p101]);
        addRow(___Details_Matches_IScale_102, [NSString stringWithFormat: @"%ld%%", (long)p102]);
        
        NSUInteger X = p100 + p101 + p102;
        
        addRow(___Details_X, [NSString stringWithFormat: @"%ld", (long)X]);
        
        
        NSUInteger FE100 = round([IScale_100 computePercentageForRecord: record
                                                               analyser: analyser] * FE99 / X);
        
        NSUInteger FE101 = round([IScale_101 computePercentageForRecord: record
                                                               analyser: analyser] * FE99 / X);
        
        NSUInteger FE102 = round([IScale_102 computePercentageForRecord: record
                                                               analyser: analyser] * FE99 / X);
        
        // Здесь идет дублирование кода, я убрал все комментарии;
        // см. подробности вычислений в -computeScoreForRecord:analyzer:
        NSMutableArray *scores = [NSMutableArray arrayWithCapacity: 3];
        
        static NSString * const kScore = @"score";
        static NSString * const kType  = @"type";
        
        [scores addObject: @{kScore: @(FE100), kType: kGroupType_IScale_100}];
        [scores addObject: @{kScore: @(FE101), kType: kGroupType_IScale_101}];
        [scores addObject: @{kScore: @(FE102), kType: kGroupType_IScale_102}];
        
        [scores sortUsingDescriptors:
         @[[NSSortDescriptor sortDescriptorWithKey: kScore ascending: YES]]];
        
        NSMutableDictionary *resultingScores = [NSMutableDictionary dictionary];
        
        NSDictionary *max = scores[2];
        NSDictionary *med = scores[1];
        NSDictionary *min = scores[0];
        
        NSUInteger maxDelta = [max[kScore] intValue] - [min[kScore] intValue];
        NSUInteger medDelta = [med[kScore] intValue] - [min[kScore] intValue];
        
        NSUInteger maxFinal = 0;
        NSUInteger medFinal = 0;
        NSUInteger minFinal = 3;
        
        if (maxDelta > 4)
        {
            maxFinal = 5;
        }
        else if (maxDelta > 2)
        {
            maxFinal = 4;
        }
        else
        {
            maxFinal = 3;
        }
        
        if (medDelta > 4)
        {
            medFinal = 5;
        }
        else if (medDelta > 2)
        {
            medFinal = 4;
        }
        else
        {
            medFinal = 3;
        }
        
        resultingScores[max[kType]] = @(maxFinal);
        resultingScores[med[kType]] = @(medFinal);
        resultingScores[min[kType]] = @(minFinal);
        
        NSDictionary *typeTranslation =
        @{
            kGroupType_IScale_100 : ___Details_FE_IScale_100,
            kGroupType_IScale_101 : ___Details_FE_IScale_101,
            kGroupType_IScale_102 : ___Details_FE_IScale_102
        };
        
        for (NSDictionary *dic in scores)
        {
            addRow(typeTranslation[dic[kType]],
                   [NSString stringWithFormat: @"%d (%d)",
                    [dic[kScore] intValue],
                    [resultingScores[dic[kType]] intValue]]);
        }
    }
    
    [html appendString: @"</table>"];
    
    [html appendString: @"</body>"];
    [html appendString: @"</html>"];
    
    return html;
}


- (NSArray *) positiveStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return _positiveIndices;
}


- (NSArray *) negativeStatementIDsForRecord: (id<TestRecordProtocol>) record
{
    return _negativeIndices;
}


- (BOOL) scoreIsWithinNorm
{
    return fabs(self.score - 3.0) < 0.05;
}


- (NSString *) readableScore
{
    return [NSString stringWithFormat: @"%d", (int)self.score];
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    //---------------------------------------------------
    // Считаем для начала формульные единицы по шкале 99
    //---------------------------------------------------
    // Сумма Тэра вычисляется как сумма процентов совпадений по шкалам 95-98
    NSUInteger TaerSum = [analyser taerSumForRecord: record];
    
    // Сумма Тэра попадает в знаменатель, поэтому должна быть положительной.
    // Если она все-таки получается равной нулю, вернуть недопустимое значение.
    if (TaerSum == 0)
    {
        self.score = -1;
        return self.score;
    }
    
    id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    
    // FE == "формульные единицы"
    // Формкльные единицы шкалы 99 вычисляются как сумма процентов совпадений по
    // шкалам 95 и 96, умноженная на 10 и деленная на сумму Тэра.
    NSUInteger FE99 =
    ([IScale_95 computePercentageForRecord: record analyser: analyser] +
     [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / TaerSum;
    
    //---------------------------------------------------
    // Вычисляем значение X по формуле из книги
    //---------------------------------------------------
    id<AnalyzerGroup> IScale_100 = [analyser firstGroupForType: kGroupType_IScale_100];
    id<AnalyzerGroup> IScale_101 = [analyser firstGroupForType: kGroupType_IScale_101];
    id<AnalyzerGroup> IScale_102 = [analyser firstGroupForType: kGroupType_IScale_102];
    
    // X - это сумма процентов совпадений по шкалам 100-102
    NSUInteger X =
    [IScale_100 computePercentageForRecord: record analyser: analyser] +
    [IScale_101 computePercentageForRecord: record analyser: analyser] +
    [IScale_102 computePercentageForRecord: record analyser: analyser];
    
    // X попадает в знаменатель, поэтому должен быть положительным.
    // Если X оказался равным нулю, вернуть недопустимое значение. 
    if (X == 0)
    {
        self.score = -1;
        return self.score;
    }
    
    //---------------------------------------------------
    // Подсчет формульных единиц по шкалам 100-102
    //---------------------------------------------------
    static NSString * const kScore = @"score";
    static NSString * const kType  = @"type";
    
    // Формульные единицы нормализуются в соответствии с выражениями,
    // перечисленными в "Большой толстой книге":
    // 100фе = 100% * 99фе / Х
    // 101фе = 101% * 99фе / Х
    // 102фе = 102% * 99фе / X
    
    // Формульные единицы для шкалы 100
    NSUInteger FE100 = round([IScale_100 computePercentageForRecord: record
                                                           analyser: analyser] * FE99 / X);
    
    // Формульные единицы для шкалы 101
    NSUInteger FE101 = round([IScale_101 computePercentageForRecord: record
                                                           analyser: analyser] * FE99 / X);
    
    // Формульные единицы для шкалы 102
    NSUInteger FE102 = round([IScale_102 computePercentageForRecord: record
                                                           analyser: analyser] * FE99 / X);
    
    // Далее необходимо упорядочить полученные значения по возрастанию,
    // но не забыть, какой шкале они соответствуют. Поэтому пишем NSDictionary
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity: 3];
    
    [scores addObject: @{kScore: @(FE100), kType: kGroupType_IScale_100}];
    [scores addObject: @{kScore: @(FE101), kType: kGroupType_IScale_101}];
    [scores addObject: @{kScore: @(FE102), kType: kGroupType_IScale_102}];
    
    // Отсортировали пары (баллы, тип шкалы) по возрастанию
    [scores sortUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey: kScore ascending: YES]]];
    
    // Сюда положим финальные баллы
    NSMutableDictionary *resultingScores = [NSMutableDictionary dictionary];
    
    // Для удобства читаем значения из упорядоченного массива
    // в отдельные NSDictionary
    NSDictionary *max = scores[2];
    NSDictionary *med = scores[1];
    NSDictionary *min = scores[0];
    
    // Далее необходимо воспользоваться формулой из книги:
    //
    // Оценочные баллы ставятся по следующему правилу:
    // Превышение одного показателя над другим в пределах 0.2 < D < 0.4 формульных единиц
    // оценивается в 4 балла; превышение D > 0.4 - в 5 баллов; по тому же принципу ставятся
    // 2 и 1 балла; при D < 0.2 все показатели получают 3 балла.
    //
    // Здесь мне до сих пор не ясно точно, разницу между какой парой значений
    // рассматривать в качестве D в формуле из книги - есть дельта между максимальным
    // и минимальным, есть дельта между средним и минимальным и есть дельта между
    // средним и максимальным.
    //
    // Обсуждая этот вопрос с клиентом, мы пришли к выводу, что нужно брать дельту между
    // максимальным и минимальным, для подсчета очков максимального, после чего брать
    // дельту между двумя оставшимися - средним и минимальным.
    //
    // Это кажется несколько странным, но пусть будет так.
    NSUInteger maxDelta = [max[kScore] intValue] - [min[kScore] intValue];
    NSUInteger medDelta = [med[kScore] intValue] - [min[kScore] intValue];
    
    NSUInteger maxFinal = 0;
    NSUInteger medFinal = 0;
    NSUInteger minFinal = 3; // В таком случае минимальный балл всегда получит 3 очка
    
    // Наши значения умножены на 10 лишний раз, поэтому берем целые числа вместо десятых долей.
    // Вычисляем баллы для максимального значения по формуле из книги.
    if (maxDelta > 4)
    {
        maxFinal = 5;
    }
    else if (maxDelta > 2)
    {
        maxFinal = 4;
    }
    else
    {
        maxFinal = 3;
    }
    
    // Вычисляем баллы для среднего значения по формуле из книги
    if (medDelta > 4)
    {
        medFinal = 5;
    }
    else if (medDelta > 2)
    {
        medFinal = 4;
    }
    else
    {
        medFinal = 3;
    }
    
    // Минимальное значение получает 3 балла по умолчанию, поэтому для него ничего
    // вычислять уже не нужно.
    
    
    // Сопоставляем полученные балы соответствующим шкалам
    resultingScores[max[kType]] = @(maxFinal);
    resultingScores[med[kType]] = @(medFinal);
    resultingScores[min[kType]] = @(minFinal);
    
    self.score = [resultingScores[self.type] intValue];
    
    return self.score;
}


- (NSUInteger) computeMatchesForRecord: (id<TestRecordProtocol>) record
                              analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger positiveMatches = 0;
    NSUInteger negativeMatches = 0;
    
    for (NSNumber *index in _positiveIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypePositive) &&
            [analyser isValidStatementID: [index integerValue]]) positiveMatches++;
    }
    
    
    for (NSNumber *index in _negativeIndices)
    {
        if (([record.testAnswers answerTypeForStatementID: [index integerValue]]
             == AnswerTypeNegative) &&
            [analyser isValidStatementID: [index integerValue]]) negativeMatches++;
    }
    
    return positiveMatches+negativeMatches;
}


- (NSUInteger) computePercentageForRecord: (id<TestRecordProtocol>) record
                                 analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger total = [self totalNumberOfValidStatementIDsForRecord: record
                                                            analyser: analyser];
    
    if (total > 0)
    {
        return [self computeMatchesForRecord: record
                                    analyser: analyser] * 100 / total;
    }
    else return 0;
}


- (NSUInteger) totalNumberOfValidStatementIDsForRecord: (id<TestRecordProtocol>) record
                                              analyser: (id<AnalyzerProtocol>) analyser
{
    NSUInteger count = 0;
    
    for (NSNumber *statementID in _positiveIndices)
    {
        FRB_AssertClass(statementID, NSNumber);
        if ([analyser isValidStatementID: [statementID unsignedIntegerValue]])
            count++;
    }
    
    
    for (NSNumber *statementID in _negativeIndices)
    {
        FRB_AssertClass(statementID, NSNumber);
        if ([analyser isValidStatementID: [statementID unsignedIntegerValue]])
            count++;
    }
    
    return count;
}


#pragma mark -
#pragma mark private

@end
