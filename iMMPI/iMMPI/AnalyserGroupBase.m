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

#import "AnalyserFGroup.h"
#import "AnalyserFGroupFM.h"
#import "AnalyserPGroup.h"
#import "AnalyserKGroup.h"
#import "AnalyserIGroupT1.h"
#import "AnalyserIGroup99.h"
#import "AnalyserIGroupM.h"
#import "AnalyserIGroupX.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyName      = @"name";
static NSString * const kJSONKeyType      = @"type";
static NSString * const kJSONKeySubgroups = @"subgroups";



static NSDictionary *kGroupClassForType = nil;


#pragma mark -
#pragma mark Error message function declarations

static id _logGroupNameNotFound();
static id _logGroupTypeNotFound();
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
#pragma mark intialization methods

+ (void) initialize
{
    static dispatch_once_t predicate  = 0;
    dispatch_once(&predicate,
                  ^{
                      kGroupClassForType = @{
                      kGroupType_Group      : @"AnalyserGroupBase",
                      
                      kGroupType_FScale     : @"AnalyserFGroup",
                      kGroupType_FScale_FM  : @"AnalyserFGroupFM",
                      
                      kGroupType_PScale     : @"AnalyserPGroup",
                      
                      kGroupType_Base_L     : @"AnalyserFGroup",
                      kGroupType_Base_F     : @"AnalyserFGroup",
                      kGroupType_Base_K     : @"AnalyserFGroup",
                      
                      kGroupType_Base_1     : @"AnalyserKGroup",
                      kGroupType_Base_2     : @"AnalyserFGroup",
                      kGroupType_Base_3     : @"AnalyserFGroup",
                      kGroupType_Base_4     : @"AnalyserKGroup",
                      kGroupType_Base_5     : @"AnalyserFGroupFM",
                      kGroupType_Base_6     : @"AnalyserFGroup",
                      kGroupType_Base_7     : @"AnalyserKGroup",
                      kGroupType_Base_8     : @"AnalyserKGroup",
                      kGroupType_Base_9     : @"AnalyserKGroup",
                      kGroupType_Base_0     : @"AnalyserFGroup",
                      
                      kGroupType_IScale_95  : @"AnalyserIGroupT1",
                      kGroupType_IScale_96  : @"AnalyserIGroupT1",
                      kGroupType_IScale_97  : @"AnalyserIGroupT1",
                      kGroupType_IScale_98  : @"AnalyserIGroupT1",
                      kGroupType_IScale_99  : @"AnalyserIGroup99",
                      kGroupType_IScale_100 : @"AnalyserIGroupX",
                      kGroupType_IScale_101 : @"AnalyserIGroupX",
                      kGroupType_IScale_102 : @"AnalyserIGroupX",
                      kGroupType_IScale_103 : @"AnalyserIGroupM",
                      kGroupType_IScale_104 : @"AnalyserIGroupM"
                      };
                  });
}


- (id) initWithJSON: (NSDictionary *) json
{
    self = [super init];
    
    if (self != nil)
    {
        _subgroups = [NSMutableArray array];
    }
    return self;
}


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
#pragma mark properties

- (NSUInteger) subgroupsCount
{
    return _subgroups.count;
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


- (double) computeScoreForRecord: (id<TestRecord>) record
                        analyser: (id<Analyser>) analyser
{
    _score = NAN;
    return _score;
}


- (NSUInteger) computeMatchesForRecord: (id<TestRecord>) record
                              analyser: (id<Analyser>) analyser
{
    return 0;
}


- (NSUInteger) computePercentageForRecord: (id<TestRecord>) record
                                 analyser: (id<Analyser>) analyser
{
    return 0;
}


#pragma mark -
#pragma mark methods

+ (id<AnalyserGroup>) parseGroupJSON: (NSDictionary *) json
{
    NSString *name = json[kJSONKeyName];
    NSString *type = json[kJSONKeyType];
    
    if (name.length == 0) return _logGroupNameNotFound();
    if (type.length == 0) return _logGroupTypeNotFound();
    
    
    AnalyserGroupBase *group = nil;
    
    NSString *className = kGroupClassForType[type];
    
    if (className.length > 0)
    {
        group = [[NSClassFromString(className) alloc] initWithJSON: json];
    }
    
    if (group == nil)
    {
        group = [AnalyserGroupBase new];
        NSLog(@"Failed to parse group '%@' of type '%@'.", name, type);
    }
    
    if (group != nil)
    {
        group.name = name;
        group.type = type;
        
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


static id _logGroupTypeNotFound()
{
    NSLog(@"Failed to parse group: '%@' not found.", kJSONKeyType);
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
