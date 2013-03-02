//
//  AnalysisSettings.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 03.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalysisSettings.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kDefaultsKeyShouldFilter = @"com.immpi.defaults.analysis.shouldFilter";
static NSString * const kDefaultsKeyShouldHide   = @"com.immpi.defaults.analysis.shouldHide";


#pragma mark -
#pragma mark AnalysisSettings implementation

@implementation AnalysisSettings

+ (NSUserDefaults *) defaults
{
    return [NSUserDefaults standardUserDefaults];
}


+ (BOOL) shouldFilterAnalysisResults
{
    return [[self defaults] boolForKey: kDefaultsKeyShouldFilter];
}


+ (BOOL) shouldHideNormalResults
{
    return [[self defaults] boolForKey: kDefaultsKeyShouldHide];
}


+ (void) setShouldFilterAnalysisResults: (BOOL) shouldFilter
{
    NSUserDefaults *defaults = [self defaults];
    [defaults setBool: shouldFilter forKey: kDefaultsKeyShouldFilter];
    [defaults synchronize];
}


+ (void) setShouldHideNormalResults: (BOOL) shouldHide
{
    NSUserDefaults *defaults = [self defaults];
    [defaults setBool: shouldHide forKey: kDefaultsKeyShouldHide];
    [defaults synchronize];
}

@end
