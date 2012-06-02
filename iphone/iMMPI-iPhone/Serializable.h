//
//  Serializable.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 5/30/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#pragma mark -
#pragma mark Serializable protocol

@protocol Serializable <NSObject>

- (NSData *) serialize NS_RETURNS_NOT_RETAINED;

- (id) initWithData: (NSData *) data NS_RETURNS_RETAINED;

@end
