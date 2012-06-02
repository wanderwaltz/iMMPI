//
//  PersonListDocumentWrapper.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BasicListModel.h"
#import "MMPIDocument.h"

#pragma mark -
#pragma mark PersonListDocumentWrapper interface

@interface PersonListDocumentWrapper : NSObject<BasicListModelElement>
{
    __weak MMPIDocument *_document;
}

@property (weak, readonly, nonatomic) MMPIDocument *document;

+ (id) instanceWithMMPIDocument: (MMPIDocument *) document NS_RETURNS_NOT_RETAINED;
- (id) initWithMMPIDocument:     (MMPIDocument *) document NS_RETURNS_RETAINED;

@end
