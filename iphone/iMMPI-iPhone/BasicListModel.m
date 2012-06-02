//
//  BasicListModel.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "BasicListModel.h"

#pragma mark -
#pragma mark BasicListModel implementation

@implementation BasicListModel

#pragma mark -
#pragma mark Wrappers

#pragma mark -
#pragma mark Properties

@synthesize elements = _elements;

- (void) setElements:(NSArray *)elements
{
    _elements = elements;
    [self setNeedsReload];
}

#pragma mark -
#pragma mark Reloading

- (void) setNeedsReload
{
    _needsReload = YES;
}


- (void) reloadIfNeeded
{
    if (_needsReload)
    {
        [self reload];
    }
}


- (void) reload
{
    _needsReload = NO;
    [self reloadSections];
}


#pragma mark -
#pragma mark Sections

- (void) reloadSections
{
    if (_elements.count > 0)
    {
        [self sortElements];
        
        if (_sectionTitles == nil) _sectionTitles = [NSMutableArray array];
        else [_sectionTitles removeAllObjects];
        
        if (_sectionRanges == nil) _sectionRanges = [NSMutableArray array];
        else [_sectionRanges removeAllObjects];
        
        NSRange       range = NSMakeRange(0, _elements.count);
        NSString *sectionId = [[_elements firstObject] sectionIdentifier];
        
        for (NSUInteger i = 1; i < _elements.count; ++i)
        {
            NSString *newId = [[_elements objectAtIndex: i] sectionIdentifier];
            
            
            if (![newId isEqualToString: sectionId])
            {
                range.length = i-range.location;
                
                [_sectionRanges addObject: [NSValue valueWithRange: range]];
                [_sectionTitles addObject: (sectionId.length > 0)?sectionId:@""];
                
                range.location = i;
                range.length   = _elements.count-range.location;
                sectionId      = newId;
            }
        }
        
        [_sectionRanges addObject: [NSValue valueWithRange: range]];
        [_sectionTitles addObject: (sectionId.length > 0)?sectionId:@""];
    }
}


- (void) sortElements
{
    _elements = 
    [_elements sortedArrayUsingDescriptors:
     [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey: @"sectionIdentifier" 
                                    ascending: YES 
                                   comparator:
       ^NSComparisonResult(NSString *a, NSString *b) 
       {
           if ([a isEqualToString: @"#"] && [b isEqualToString: @"#"])
               return NSOrderedSame;
           
           else if ([a isEqualToString: @"#"])
               return NSOrderedDescending;
           
           else if ([b isEqualToString: @"#"])
               return NSOrderedAscending;
           
           else
               return [a compare: b];
       }],
      [NSSortDescriptor sortDescriptorWithKey: @"title" ascending: YES], nil]]; 
}


#pragma mark -
#pragma mark ListModel

- (NSString *) titleForSection: (NSUInteger) section
{
    [self reloadIfNeeded];
    return [_sectionTitles objectAtIndex: section];
}


- (NSUInteger) numberOfSections
{
    [self reloadIfNeeded];
    return _sectionRanges.count;
}


- (NSUInteger) numberOfRowsInSection: (NSUInteger) section
{
    [self reloadIfNeeded];
    NSRange range = [[_sectionRanges objectAtIndex: section] rangeValue];
    return range.length;
}


- (id<ListModelElement>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    [self reloadIfNeeded];
    NSRange range = [[_sectionRanges objectAtIndex: indexPath.section] rangeValue];
    return [_elements objectAtIndex: indexPath.row + range.location];
}


- (NSArray *) sectionIndexTitles
{
    [self reloadIfNeeded];
    return _sectionTitles;
}


- (NSUInteger) sectionForSectionIndexTitle: (NSString *) title
{
    [self reloadIfNeeded];
    return [_sectionTitles indexOfObject: title];
}


@end
