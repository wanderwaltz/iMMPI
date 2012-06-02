//
//  JsonDataWrapper.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "JsonData.h"
#import "Serializable.h"

#pragma mark -
#pragma mark JsonDataWrapper interface

@interface JsonDataWrapper : NSObject<Serializable>
{
    JsonData *_jsonData;
}

@end
