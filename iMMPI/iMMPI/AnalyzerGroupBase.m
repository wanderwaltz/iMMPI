//
//  AnalyzerGroupBase.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerGroupBase.h"

#import "AnalyzerFGroup.h"
#import "AnalyzerFGroupFM.h"
#import "AnalyzerPGroup.h"
#import "AnalyzerKGroup.h"
#import "AnalyzerIGroupT1.h"
#import "AnalyzerIGroup99.h"
#import "AnalyzerIGroupM.h"
#import "AnalyzerIGroupX.h"

#import "AnalyzerBase5Group.h"
#import "AnalyzerPlainPercentGroup.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kJSONKeyName      = @"name";
static NSString * const kJSONKeyType      = @"type";
static NSString * const kJSONKeySubgroups = @"subgroups";
static NSString * const kJSONKeyIndex     = @"index";



static NSDictionary *kGroupClassForType = nil;


#pragma mark -
#pragma mark Error message function declarations

static id _logGroupNameNotFound();
static id _logGroupTypeNotFound();
static id _logSubgroupsNotArray(id object);
static id _logSubgroupNotDictionary(id object);

#pragma mark -
#pragma mark AnalyzerGroupBase private

@interface AnalyzerGroupBase()
{
    NSMutableArray *_subgroups;
}

@property (readonly, nonatomic) NSMutableArray *subgroups;

@end


#pragma mark -
#pragma mark AnalyzerGroupBase implementation

@implementation AnalyzerGroupBase

#pragma mark -
#pragma mark intialization methods

+ (void) initialize
{
    static dispatch_once_t predicate  = 0;
    dispatch_once(&predicate,
                  ^{
                      kGroupClassForType = @{
                      kGroupType_Group      : @"AnalyzerGroupBase",
                      
                      kGroupType_FScale     : @"AnalyzerFGroup",
                      
                      kGroupType_FScale_FM  : @"AnalyzerFGroupFM",
                      
                      kGroupType_PScale     : @"AnalyzerPGroup",
                      
                      kGroupType_Base_L     : @"AnalyzerFGroup",
                      kGroupType_Base_F     : @"AnalyzerFGroup",
                      kGroupType_Base_K     : @"AnalyzerFGroup",
                      
                      kGroupType_Base_1     : @"AnalyzerKGroup",
                      kGroupType_Base_2     : @"AnalyzerFGroup",
                      kGroupType_Base_3     : @"AnalyzerFGroup",
                      kGroupType_Base_4     : @"AnalyzerKGroup",
                      kGroupType_Base_5     : @"AnalyzerBase5Group",
                      kGroupType_Base_6     : @"AnalyzerFGroup",
                      kGroupType_Base_7     : @"AnalyzerKGroup",
                      kGroupType_Base_8     : @"AnalyzerKGroup",
                      kGroupType_Base_9     : @"AnalyzerKGroup",
                      kGroupType_Base_0     : @"AnalyzerFGroup",
                      
                      kGroupType_IScale_95  : @"AnalyzerIGroupT1",
                      kGroupType_IScale_96  : @"AnalyzerIGroupT1",
                      kGroupType_IScale_97  : @"AnalyzerIGroupT1",
                      kGroupType_IScale_98  : @"AnalyzerIGroupT1",
                      kGroupType_IScale_99  : @"AnalyzerIGroup99",
                      kGroupType_IScale_100 : @"AnalyzerIGroupX",
                      kGroupType_IScale_101 : @"AnalyzerIGroupX",
                      kGroupType_IScale_102 : @"AnalyzerIGroupX",
                      kGroupType_IScale_103 : @"AnalyzerIGroupM",
                      kGroupType_IScale_104 : @"AnalyzerIGroupM",
                      
                      kGroupType_PlainPercentScale : @"AnalyzerPlainPercentGroup"
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

- (NSInteger)subgroupsCount
{
    return _subgroups.count;
}


#pragma mark -
#pragma mark AnalyzerGroup

- (NSInteger)indexForRecord:(id<TestRecordProtocol>)record
{
    return [self.indexesForGender[(record.person.gender == GenderFemale) ? 1 : 0] unsignedIntegerValue];
}


- (BOOL) canProvideDetailedInfo
{
    return NO;
}


- (NSString *)htmlDetailedInfoForRecord:(id<TestRecordProtocol>)record
                               analyser:(id<AnalyzerProtocol>)analyser
{
    return @"";
}


- (NSArray *)positiveStatementIDsForRecord:(id<TestRecordProtocol>)record
{
    return @[];
}


- (NSArray *)negativeStatementIDsForRecord:(id<TestRecordProtocol>)record
{
    return @[];
}


- (BOOL) scoreIsWithinNorm
{
    // We have to default to NO here because if score is within
    // norm, this group may be completely hidden depending on the
    // user's settings. So if some group does not implement this
    // method, we'll be safer with NO as default since this group's
    // score will always be visible in that case.
    return NO;
}


- (NSString *) readableScore
{
    return @"";
}


- (id<AnalyzerGroup>)subgroupAtIndex:(NSInteger)index
{
    id<AnalyzerGroup> subgroup = _subgroups[index];
    FRB_AssertConformsTo(subgroup, AnalyzerGroup);
    
    return subgroup;
}


- (double)computeScoreForRecord:(id<TestRecordProtocol>)record
                       analyser:(id<AnalyzerProtocol>)analyser
{
    self.score = NAN;
    return self.score;
}


- (NSInteger) computeMatchesForRecord: (id<TestRecordProtocol>) record
                              analyser: (id<AnalyzerProtocol>) analyser
{
    return 0;
}


- (NSInteger) computePercentageForRecord: (id<TestRecordProtocol>) record
                                 analyser: (id<AnalyzerProtocol>) analyser
{
    return 0;
}


- (NSInteger) totalNumberOfValidStatementIDsForRecord: (id<TestRecordProtocol>) record
                                              analyser: (id<AnalyzerProtocol>) analyser
{
    return 0;
}


#pragma mark -
#pragma mark methods

+ (id<AnalyzerGroup>) parseGroupJSON: (NSDictionary *) json
{
    NSString *name = json[kJSONKeyName];
    NSString *type = json[kJSONKeyType];
    
    if (name.length == 0) return _logGroupNameNotFound();
    if (type.length == 0) return _logGroupTypeNotFound();
    
    AnalyzerGroupBase *group = nil;
    
    NSString *className = kGroupClassForType[type];
    
    if (className.length > 0)
    {
        group = [[NSClassFromString(className) alloc] initWithJSON: json];
    }
    
    if (group == nil)
    {
        group = [AnalyzerGroupBase new];
        NSLog(@"Failed to parse group '%@' of type '%@'.", name, type);
    }
    
    if (group != nil)
    {
        group.name = name;
        group.type = type;
        
        id index = json[kJSONKeyIndex];
        
        if ([index isKindOfClass: [NSNumber class]])
            group.indexesForGender = @[index, index];
        else if ([index isKindOfClass: [NSArray class]] && ([index count] == 2))
            group.indexesForGender = index;
        else
            group.indexesForGender = @[@0, @0];
        
        NSArray *subgroups = json[kJSONKeySubgroups];
        
        if (subgroups != nil)
        {
            if (![subgroups isKindOfClass: [NSArray class]]) return _logSubgroupsNotArray(subgroups);
            
            for (NSDictionary *subgroupJSON in subgroups)
            {
                if ([subgroupJSON isKindOfClass: [NSDictionary class]])
                {
                    id<AnalyzerGroup> subgroup = [self parseGroupJSON: subgroupJSON];
                    
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


+ (NSArray *) parseSpaceSeparatedInts: (NSString *) string
{
    if ([string isKindOfClass: [NSString class]])
    {
        if (string.length > 0)
        {
            return [[string componentsSeparatedByString: @" "] valueForKey: @"intValue"];
        }
        else return @[];
    }
    else return @[];
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
