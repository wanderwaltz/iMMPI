//
//  PersonIndexModel.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 5/30/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonIndexModel.h"

#pragma mark -
#pragma mark PersonIndexModel implementation

@implementation PersonIndexModel

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _indexRecords  = [NSMutableArray array];
        _sectionRanges = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark Private

- (void) setupSections
{
    if (_indexRecords.count > 0)
    {
        [self sortRecords];
        NSLog(@"%@", _indexRecords);
        
        [_sectionTitles removeAllObjects];
        [_sectionRanges removeAllObjects];
        
        
        NSRange       range = NSMakeRange(0, _indexRecords.count);
        NSString *sectionId = [[_indexRecords firstObject] sectionIdentifier];
        
        for (NSUInteger i = 1; i < _indexRecords.count; ++i)
        {
            NSString *newId = [[_indexRecords objectAtIndex: i] sectionIdentifier];
                              
            
            if (![newId isEqualToString: sectionId])
            {
                range.length = i-range.location;
                
                [_sectionRanges addObject: [NSValue valueWithRange: range]];
                [_sectionTitles addObject: sectionId];
                
                range.location = i;
                range.length   = _indexRecords.count-range.location;
                sectionId      = newId;
            }
        }
        
        [_sectionRanges addObject: [NSValue valueWithRange: range]];
        [_sectionTitles addObject: sectionId];
    }
}


- (void) sortRecords
{
    [_indexRecords sortUsingDescriptors:
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
      [NSSortDescriptor sortDescriptorWithKey: @"fullName" ascending: YES], nil]]; 
}


#pragma mark -
#pragma mark Methods

- (NSString *) titleForSection: (NSUInteger) section
{
    return [_sectionTitles objectAtIndex: section];
}


- (void) addIndexRecord: (PersonIndexRecord *) indexRecord
{
    @synchronized(self)
    {
        if ([_indexRecords indexOfObject: indexRecord] == NSNotFound)
        {
            [_indexRecords addObject: indexRecord];
            [self setupSections];   
        }
    }
}


- (NSUInteger) numberOfSections
{
    return _sectionRanges.count;
}


- (NSUInteger) numberOfRowsInSection: (NSUInteger) section
{
    NSRange range = [[_sectionRanges objectAtIndex: section] rangeValue];
    return range.length;
}


- (PersonIndexRecord *) recordAtIndexPath: (NSIndexPath *) indexPath 
{
    NSRange range = [[_sectionRanges objectAtIndex: indexPath.section] rangeValue];
    
    return [_indexRecords objectAtIndex: indexPath.row + range.location];
}


- (NSArray *) sectionIndexTitles
{
    return _sectionTitles;
}


- (NSUInteger) sectionForSectionIndexTitle: (NSString *) title
{
    return [_sectionTitles indexOfObject: title];
}


@end
