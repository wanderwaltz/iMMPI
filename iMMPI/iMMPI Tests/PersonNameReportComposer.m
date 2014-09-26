//
//  PersonNameReportComposer.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "PersonNameReportComposer.h"
#import "TestRecordProtocol.h"

SPEC_BEGIN(PersonNameReportComposerTests)

describe(@"PersonNameReportComposer", ^{
    it(@"should conform to AnalyzerReportComposer protocol", ^{
        [[[PersonNameReportComposer class] should] conformToProtocol: @protocol(AnalyzerReportComposer)];
    });
    
    
    let(test_record, ^id{
        return [KWMock mockForProtocol: @protocol(TestRecordProtocol)];
    });
    

    context(@"when newly created", ^{
        let(composer, ^PersonNameReportComposer *{
            return [[PersonNameReportComposer alloc] init];
        });
        
        
        it(@"should return person name as its report", ^{
            NSString *person_name = @"John Appleseed";
            
            [[test_record should] receive: @selector(personName) andReturn: person_name];
            
            NSString *actual_report = [composer composeReportForTestRecord: test_record];
            
            [[actual_report should] equal: person_name];
        });
    });
});

SPEC_END
