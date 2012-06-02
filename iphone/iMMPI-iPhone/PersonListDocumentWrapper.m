//
//  PersonListDocumentWrapper.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonListDocumentWrapper.h"

#pragma mark -
#pragma mark PersonListDocumentWrapper implementation

@implementation PersonListDocumentWrapper

#pragma mark -
#pragma mark Properties

@synthesize document = _document;


#pragma mark -
#pragma mark ListModelElement

- (NSString *) title
{
    return _document.personIndexRecord.fullName;
}


- (NSString *) subtitle
{
    return nil;
}


#pragma mark -
#pragma mark BasicListModelElement

- (NSString *) sectionIdentifier
{    
    return _document.personIndexRecord.sectionIdentifier;
}


#pragma mark -
#pragma mark initialization methods

+ (id) instanceWithMMPIDocument: (MMPIDocument *) document
{
    return [[PersonListDocumentWrapper alloc] initWithMMPIDocument: document];
}


- (id) initWithMMPIDocument: (MMPIDocument *) document
{
    self = [super init];
    
    if (self != nil)
    {
        _document = document;
    }
    return self;
}

@end
