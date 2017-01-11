//
//  Analyzer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark Constants

extern NSString * const kGroupType_Group;

extern NSString * const kGroupType_FScale;
extern NSString * const kGroupType_FScale_FM;

extern NSString * const kGroupType_PScale;

extern NSString * const kGroupType_Base_L;
extern NSString * const kGroupType_Base_F;
extern NSString * const kGroupType_Base_K;

extern NSString * const kGroupType_Base_1;
extern NSString * const kGroupType_Base_2;
extern NSString * const kGroupType_Base_3;
extern NSString * const kGroupType_Base_4;
extern NSString * const kGroupType_Base_5;
extern NSString * const kGroupType_Base_6;
extern NSString * const kGroupType_Base_7;
extern NSString * const kGroupType_Base_8;
extern NSString * const kGroupType_Base_9;
extern NSString * const kGroupType_Base_0;

extern NSString * const kGroupType_IScale_95;
extern NSString * const kGroupType_IScale_96;
extern NSString * const kGroupType_IScale_97;
extern NSString * const kGroupType_IScale_98;
extern NSString * const kGroupType_IScale_99;
extern NSString * const kGroupType_IScale_100;
extern NSString * const kGroupType_IScale_101;
extern NSString * const kGroupType_IScale_102;
extern NSString * const kGroupType_IScale_103;
extern NSString * const kGroupType_IScale_104;

extern NSString * const kGroupType_PlainPercentScale;


#pragma mark -
#pragma mark Analyzer interface

@interface Analyzer: NSObject<AnalyzerProtocol>

@property (readonly, nonatomic) NSInteger groupsCount;

- (id<AnalyzerGroup> _Nullable)groupAtIndex:(NSInteger)index;
- (NSInteger)depthOfGroupAtIndex:(NSInteger)index;

- (id<AnalyzerGroup> _Nullable)groupWithName:(NSString *)name;

- (BOOL)loadGroups;

- (void)computeScoresForRecord:(id<TestRecordProtocol>)record;

@end

NS_ASSUME_NONNULL_END
