//
//  Analyser.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Analyser.h"
#import "AnalyserGroupBase.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kAnalysisResourceName = @"mmpi.analysis";
static NSString * const kAnalysisResourceType = @"json";

static NSString * const kJSONKeyGroups = @"groups";


#pragma mark -
#pragma mark Error message function declarations

static BOOL _logAnalysisResourceNotFound();
static BOOL _logAnalysisResourceCannotBeLoaded();
static BOOL _logAnalysisJSONCannotBeParsed(NSError *error);
static BOOL _logJSONRootObjectNotDictionary();
static BOOL _logJSONGroupsNotFound();
static BOOL _logJSONGroupNotNSDictionary(id object);


#pragma mark -
#pragma mark Analyzer private

@interface Analyser()
{
    NSMutableArray *_groups;
    NSMutableArray *_allGroups;
    NSMutableArray *_depths;
}

@end



#pragma mark -
#pragma mark Analyzer implementation

@implementation Analyser

#pragma mark -
#pragma mark properties

- (NSUInteger) groupsCount
{
    return _allGroups.count;
}


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

- (id<AnalyserGroup>) groupAtIndex: (NSUInteger) index
{
    return _allGroups[index];
}


- (NSUInteger) depthOfGroupAtIndex: (NSUInteger) index
{
    return [_depths[index] unsignedIntegerValue];
}


- (BOOL) loadGroups
{
    _groups    = nil;
    _allGroups = nil;
    _depths    = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource: kAnalysisResourceName
                                                     ofType: kAnalysisResourceType];
    if (path == nil) return _logAnalysisResourceNotFound();
    
    
    NSData *data = [NSData dataWithContentsOfFile: path];
    if (data == nil) return _logAnalysisResourceCannotBeLoaded();
    
    NSError     *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data
                                                         options: 0
                                                           error: &error];
    if (json == nil) return _logAnalysisJSONCannotBeParsed(error);
    if (![json isKindOfClass: [NSDictionary class]]) return _logJSONRootObjectNotDictionary();
    
    NSArray *groups = json[kJSONKeyGroups];
    
    if (groups == nil) return _logJSONGroupsNotFound();
    
    _groups = [NSMutableArray arrayWithCapacity: groups.count];
    
    for (NSDictionary *groupJson in groups)
    {
        if ([groupJson isKindOfClass: [NSDictionary class]])
        {
            id<AnalyserGroup> group = [AnalyserGroupBase parseGroupJSON: groupJson];
            
            if (group != nil)
            {
                [_groups addObject: group];
            }
        }
        else
        {
            _logJSONGroupNotNSDictionary(groupJson);
        }
    }
    
    _allGroups = [NSMutableArray arrayWithCapacity: _groups.count];
    _depths    = [NSMutableArray arrayWithCapacity: _allGroups.count];
    
    for (id<AnalyserGroup> group in _groups)
    {
        [_allGroups addObject: group];
        [_depths    addObject: @0];

        [self visitSubgroupsOfGroupDFS: group
                             withBlock:
         ^(id<AnalyserGroup> subgroup, NSUInteger depth) {
             [_allGroups addObject: subgroup];
             [_depths addObject: @(depth)];
         }
                                 depth: 1];
    }
    
    return YES;
}


#pragma mark -
#pragma mark private

- (void) visitSubgroupsOfGroupDFS: (id<AnalyserGroup>) group
                        withBlock: (void(^)(id<AnalyserGroup> subgroup, NSUInteger depth)) block
                            depth: (NSUInteger) depth
{
    if (block)
    {
        for (NSUInteger i = 0; i < group.subgroupsCount; ++i)
        {
            id<AnalyserGroup> subgroup = [group subgroupAtIndex: i];
            block(subgroup, depth);
            [self visitSubgroupsOfGroupDFS: subgroup
                                 withBlock: block
                                     depth: depth+1];
        }
    }
}

@end


#pragma mark -
#pragma mark Error messages

static BOOL _logAnalysisResourceNotFound()
{
    NSLog(@"Failed to load analyzer groups: '%@.%@' not found in the application bundle.",
          kAnalysisResourceName, kAnalysisResourceType);
    return NO;
}


static BOOL _logAnalysisResourceCannotBeLoaded()
{
    NSLog(@"Failed to load analyzer groups: failed to read '%@.%@'",
          kAnalysisResourceName, kAnalysisResourceType);
    return NO;
}


static BOOL _logAnalysisJSONCannotBeParsed(NSError *error)
{
    NSLog(@"Failed to load analyzer groups: failed to parse '%@.%@' JSON, error: %@",
          kAnalysisResourceName, kAnalysisResourceType, error);
    return NO;
}


static BOOL _logJSONRootObjectNotDictionary()
{
    NSLog(@"Failed to load analyzer groups: expected '%@.%@' root element to be of dictionary class.",
          kAnalysisResourceName, kAnalysisResourceType);
    return NO;
}


static BOOL _logJSONGroupsNotFound()
{
    NSLog(@"Failed to load analyzer groups: '%@' not found.", kJSONKeyGroups);
    return NO;
}


static BOOL _logJSONGroupNotNSDictionary(id object)
{
    NSLog(@"Failed to load analyzer groups: expected '%@' to contain only dictionary objects, got : '%@'", kJSONKeyGroups, object);
    return NO;
}
