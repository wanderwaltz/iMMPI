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
                      
                      kGroupType_Base_1     : @"",
                      kGroupType_Base_2     : @"AnalyserFGroup",
                      kGroupType_Base_3     : @"AnalyserFGroup",
                      kGroupType_Base_4     : @"",
                      kGroupType_Base_5     : @"AnalyserFGroupFM",
                      kGroupType_Base_6     : @"AnalyserFGroup",
                      kGroupType_Base_7     : @"",
                      kGroupType_Base_8     : @"",
                      kGroupType_Base_9     : @"",
                      kGroupType_Base_0     : @"AnalyserFGroup",
                      
                      kGroupType_IScale_95  : @"",
                      kGroupType_IScale_96  : @"",
                      kGroupType_IScale_97  : @"",
                      kGroupType_IScale_98  : @"",
                      kGroupType_IScale_99  : @"",
                      kGroupType_IScale_100 : @"",
                      kGroupType_IScale_101 : @"",
                      kGroupType_IScale_102 : @"",
                      kGroupType_IScale_103 : @"",
                      kGroupType_IScale_104 : @""
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
