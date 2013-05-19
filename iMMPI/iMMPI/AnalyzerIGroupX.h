//
//  AnalyzerIGroupX.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "AnalyzerGroupBase.h"


#pragma mark -
#pragma mark AnalyzerIGroupX interface

/*! Данный класс соответствует следующим шкалам:
    100. Научный потенциал
    101. Артистический потенциал
    102. Религиозный потенциал
 
 Выписка из "Большой толстой книги":
 
 100. Научный потенциал (`уч`)
 -----------------------------
 Все три показателя `уч`, `ар`, `ре` замещают друг друга, поэтому сумма (в %)
 относительно постоянна и для удобства приравнивается к величине `ик` (шкала 99).
 Получаемые формульные значения сопоставляются и относительная доминанта одного
 из них характеризует предпочтительный тип мышления. 
 
 Оценочные баллы ставятся по следующему правилу:
 Превышение одного показателя над другим в пределах 0.2 < D < 0.4 формульных единиц
 оценивается в 4 балла; превышение D > 0.4 - в 5 баллов; по тому же принципу ставятся
 2 и 1 балла; при D < 0.2 все показатели получают 3 балла. 
 
 `уч` характеризует способность к аналитическому мышлению, и соотношение `уч`>`ар`>`ре`
 в сочетании с высоким `тв` и особенно с `тп` служат важными качествами для исследователя. 
 
 101. Артистический потенциал (`ар`)
 -----------------------------------
 Доминанта `ар` указывает на развитие интуиции, позволяющей успешно решать 
 профессиональные задачи, не поддающиеся формализации. Собственно, артистические 
 способности выявляются в сочетании с другими показателями, в первую очередь, с `тп`.
 
 102. Религиозный потенциал (`ре`)
 ---------------------------------
 Соотношение `ре`>`уч` свидетельствует о склонности респондента верить в 
 саморазрешаемость жизненных проблем, не доискиваться их разрешения. При 5 баллах
 `ре` объект веры легко может быть фетишизирован, что наблюдается чаще в старческом
 возрасте. 
 
 
 Формулы:
 
 100%+101%+102% = X // сумма всех процентов совпадений, никак не названа
 
 100фе = 100% * 99фе / Х
 101фе = 101% * 99фе / Х
 102фе = 102% * 99фе / Х
 
 */
@interface AnalyzerIGroupX : AnalyzerGroupBase
@end
