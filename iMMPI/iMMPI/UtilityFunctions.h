//
//  UtilityFunctions.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/// Returns object if object is not nil, else returns [NSNull null]
id nil2Null(id _Nullable object);

/// Returns object if object is not of NSNull class, else returns nil
id _Nullable null2Nil(id _Nullable object);



UIViewController * _Nullable SelfOrFirstChild(UIViewController * _Nullable controller);


NSString * _Nullable TransliterateToLatin(NSString * _Nullable string);

NS_ASSUME_NONNULL_END
