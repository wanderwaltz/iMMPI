//
//  test_Persistence.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "BaseCoreDataTest.h"

#pragma mark -
#pragma mark test_Persistence interface

/*  Tests in this group verify that the persistent store is indeed persistent
    and does save and restore the managed objects properly. This test group
    is the most important since we will be using a custom persistent store
    class in this project.
 */
@interface test_Persistence : BaseCoreDataTest
@end
