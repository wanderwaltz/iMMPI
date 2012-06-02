//
//  BasicListModel.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "ListModel.h"

#pragma mark -
#pragma mark BasicListModelElement protocol

@protocol BasicListModelElement<ListModelElement>

- (NSString *) sectionIdentifier;

@end


#pragma mark -
#pragma mark BasicListModel interface
/*!
    Elements must conform to BasicListModelElement protocol.
 */
@interface BasicListModel : NSObject<ListModel>
{
    NSArray *_elements;
    
    NSMutableArray *_sectionRanges;
    NSMutableArray *_sectionTitles;
    
    BOOL _needsReload;
}

@property (strong, nonatomic) NSArray *elements;

- (void) setNeedsReload;
- (void) reloadIfNeeded;
- (void) reload;

@end
