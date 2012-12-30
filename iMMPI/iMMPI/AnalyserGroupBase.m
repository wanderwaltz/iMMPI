//
//  AnalyserGroupBase.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyserGroupBase.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyName      = @"name";
static NSString * const kJSONKeySubgroups = @"subgroups";


#pragma mark -
#pragma mark Error message function declarations

static id _logGroupNameNotFound();
static id _logSubgroupsNotArray(id object);
static id _logSubgroupNotDictionary(id object);

#pragma mark -
#pragma mark AnalyzerGroupBase private

@interface AnalyserGroupBase()
{
    NSMutableArray *_subgroups;
}

@property (readonly, nonatomic) NSMutableArray *subgroups;

@end


#pragma mark -
#pragma mark AnalyserGroupBase implementation

@implementation AnalyserGroupBase

#pragma mark -
#pragma mark properties

- (NSUInteger) subgroupsCount
{
    return _subgroups.count;
}


#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _subgroups = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (id<AnalyserGroup>) subgroupAtIndex: (NSUInteger) index
{
    id<AnalyserGroup> subgroup = _subgroups[index];
    FRB_AssertConformsTo(subgroup, AnalyserGroup);
    
    return subgroup;
}


- (void) visitSubgroupsDFS: (void(^)(id<AnalyserGroup> subgroup)) block
{
    if (block)
    {
        for (id<AnalyserGroup> subgroup in _subgroups)
        {
            FRB_AssertConformsTo(subgroup, AnalyserGroup);
            block(subgroup);
            [subgroup visitSubgroupsDFS: block];
        }
    }
}


+ (id<AnalyserGroup>) parseGroupJSON: (NSDictionary *) json
{
    NSString *name = json[kJSONKeyName];
    
    if (name.length == 0) return _logGroupNameNotFound();
    
    AnalyserGroupBase *group = [AnalyserGroupBase new];
    
    group.name = name;
    
    NSArray *subgroups = json[kJSONKeySubgroups];
    
    if (subgroups != nil)
    {
        if (![subgroups isKindOfClass: [NSArray class]]) return _logSubgroupsNotArray(subgroups);
        
        for (NSDictionary *subgroupJSON in subgroups)
        {
            if ([subgroupJSON isKindOfClass: [NSDictionary class]])
            {
                id<AnalyserGroup> subgroup = [self parseGroupJSON: subgroupJSON];
                
                if (subgroup != nil)
                {
                    [group.subgroups addObject: subgroup];
                }
            }
            else
            {
                _logSubgroupNotDictionary(subgroupJSON);
            }
        }   
    }
    
    return group;
}

@end


#pragma mark -
#pragma mark Error messages

static id _logGroupNameNotFound()
{
    NSLog(@"Failed to parse group: '%@' not found.", kJSONKeyName);
    return nil;
}


static id _logSubgroupsNotArray(id object)
{
    NSLog(@"Failed to parse group: '%@' expected to be of array class, got '%@' instead.", kJSONKeySubgroups, object);
    return nil;
}


static id _logSubgroupNotDictionary(id object)
{
    NSLog(@"Failed to parse group: subgroups expected to be of dictionary class, got '%@' instead.",
          object);
    return nil;
}
