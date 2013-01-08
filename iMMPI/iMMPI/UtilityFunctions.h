//
//  UtilityFunctions.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Returns object if object is not nil, else returns [NSNull null]
id nil2Null(id object);

/// Returns object if object is not of NSNull class, else returns nil
id null2Nil(id object);



UIViewController *SelfOrFirstChild(UIViewController *controller);