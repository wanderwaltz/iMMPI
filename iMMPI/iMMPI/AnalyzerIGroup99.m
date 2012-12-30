//
//  AnalyzerIGroup99.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerIGroup99.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyPercent = @"percent";


#pragma mark -
#pragma mark Error message function declarations

static id _logBracketNotFound();
static id _logWrongNumberOfComponents(NSString *key, id object);


#pragma mark -
#pragma mark AnalyzerIGroup99 private

@interface AnalyzerIGroup99()
{
    NSArray *_brackets;
}

@end


#pragma mark -
#pragma mark AnalyzerIGroup99 implementation

@implementation AnalyzerIGroup99

#pragma mark -
#pragma mark initialization methods

- (id) initWithJSON: (NSDictionary *) json
{
    NSString *bracketString = json[kJSONKeyPercent];
    
    if (bracketString.length == 0)   return _logBracketNotFound();
    
    NSArray *bracket = [[bracketString componentsSeparatedByString: @" "]
                        valueForKey: @"intValue"];
    
    if (bracket.count != 4)
        return _logWrongNumberOfComponents(kJSONKeyPercent, bracketString);

    
    self = [super init];
    
    if (self != nil)
    {
        _brackets = bracket;
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (NSArray *) bracketsForRecord: (id<TestRecordProtocol>) record
{
    NSAssert(_brackets.count == 4, @"");
    return _brackets;
}


- (double) computeScoreForRecord: (id<TestRecordProtocol>) record
                        analyser: (id<AnalyzerProtocol>) analyser
{
    NSArray *brackets = [self bracketsForRecord: record];
    
    NSUInteger A = [brackets[0] unsignedIntegerValue];
    NSUInteger B = [brackets[1] unsignedIntegerValue];
    NSUInteger C = [brackets[2] unsignedIntegerValue];
    NSUInteger D = [brackets[3] unsignedIntegerValue];
    
    id<AnalyzerGroup> IScale_95 = [analyser firstGroupForType: kGroupType_IScale_95];
    id<AnalyzerGroup> IScale_96 = [analyser firstGroupForType: kGroupType_IScale_96];
    id<AnalyzerGroup> IScale_97 = [analyser firstGroupForType: kGroupType_IScale_97];
    id<AnalyzerGroup> IScale_98 = [analyser firstGroupForType: kGroupType_IScale_98];
    
    NSUInteger T_aer =
    [IScale_95 computePercentageForRecord: record analyser: analyser] +
    [IScale_96 computePercentageForRecord: record analyser: analyser] +
    [IScale_97 computePercentageForRecord: record analyser: analyser] +
    [IScale_98 computePercentageForRecord: record analyser: analyser];
    
    if (T_aer > 0)
    {
        NSUInteger percentage =
        ([IScale_95 computePercentageForRecord: record analyser: analyser] +
         [IScale_96 computePercentageForRecord: record analyser: analyser]) * 100 / T_aer;
        
        if (percentage <= A)
            self.score = round(10 * 1.5 * percentage/A);
        
        else if (percentage <= B)
            self.score = round(10*(1.5+(percentage-A)/(B-A)));
        
        else if (percentage <= C)
            self.score = round(10*(2.5+(percentage-B)/(C-B)));
        
        else if (percentage <= D)
            self.score = round(10*(3.5+(percentage-C)/(D-C)));
        else
            self.score = 50;
    }
    else self.score = -1;
    
    return self.score;
}

@end


#pragma mark -
#pragma mark Error messages

static id _logBracketNotFound()
{
    NSLog(@"Failed to parse ISCALE_99 group: '%@' not found.", kJSONKeyPercent);
    return nil;
}


static id _logWrongNumberOfComponents(NSString *key, id object)
{
    NSLog(@"Failed to parse ISCALE_99 group: expected 4 integer components in '%@', got '%@' instead.", key, object);
    return nil;
}

