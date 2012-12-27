//
//  TestAnswers.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswers.h"


#pragma mark -
#pragma mark TestAnswers private

@interface TestAnswers()
{
    NSMutableDictionary *_answersByID;
}

@end


#pragma mark -
#pragma mark TestAnswers implementation

@implementation TestAnswers

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _answersByID = [NSMutableDictionary new];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) setAnswerType: (AnswerType) answerType
        forStatementID: (NSInteger) statementID
{
    Answer *answer = _answersByID[@(statementID)];
    
    if (answer == nil)
    {
        answer = [Answer new];
        answer.statementID = statementID;
        
        _answersByID[@(statementID)] = answer;
    }
    
    answer.answerType = answerType;
}


- (AnswerType) answerTypeForStatementID: (NSInteger) statementID
{
    Answer *answer = _answersByID[@(statementID)];
    
    if (answer != nil) return answer.answerType;
    else
        return AnswerTypeUnknown;
}

@end
