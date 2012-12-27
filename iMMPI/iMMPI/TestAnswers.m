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
#pragma mark TestAnswers implementation

@implementation TestAnswers

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) setAnswerType: (AnswerType) answerType
        forStatementID: (NSInteger) statementID
{
    
}


- (AnswerType) answerTypeForStatementID: (NSInteger) statementID
{
    return AnswerTypeUnknown;
}

@end
