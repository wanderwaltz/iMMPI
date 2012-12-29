//
//  MutableTableViewModel.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark MutableTableViewModel protocol

@protocol MutableTableViewModel <NSObject>
@required

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;

- (id) objectAtIndexPath: (NSIndexPath *) indexPath;

- (void) addObjectsFromArray: (NSArray *) array;

- (BOOL) addNewObject: (id) object;
- (BOOL) updateObject: (id) object;

@end
