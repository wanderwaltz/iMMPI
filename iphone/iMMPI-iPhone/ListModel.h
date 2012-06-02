//
//  ListModel.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "ListModelElement.h"

#pragma mark -
#pragma mark ListModel protocol

@protocol ListModel <NSObject>

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;

- (NSString *) titleForSection: (NSUInteger) section;

- (id<ListModelElement>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (NSArray *) sectionIndexTitles;
- (NSUInteger) sectionForSectionIndexTitle: (NSString *) title;

- (void) reload;

@end
