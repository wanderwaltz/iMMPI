//
//  MutableTableViewModel.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark MutableTableViewModel protocol

@protocol MutableTableViewModel<NSObject>
@required

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;

- (id _Nullable)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath * _Nullable)indexPathForObject:(id)object;

- (void)addObjectsFromArray:(NSArray *)array;

- (BOOL)addNewObject:(id)object;
- (BOOL)updateObject:(id)object;
- (BOOL)removeObject:(id)object;

@end

NS_ASSUME_NONNULL_END
