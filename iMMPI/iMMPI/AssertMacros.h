//
//  AssertMacros.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef iMMPI_AssertMacros_h
#define iMMPI_AssertMacros_h

#define AssertExists(Object) \
    NSAssert(Object, @"Expected " @#Object @" to be not nil")

#endif
