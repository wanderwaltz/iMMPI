//
//  Person.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Person interface

NS_ASSUME_NONNULL_BEGIN
/*! A concrete implementation of PersonProtocol.
 
 Note that when initializing a Person instance with -init method, default gender value will be GenderMale and default ageGroup value will be AgeGroupAdult; name property defaults to nil.
 */
@interface Person : NSObject<PersonProtocol>

@property (strong, nonatomic) NSString    *name;
@property (assign, nonatomic) Gender     gender;
@property (assign, nonatomic) AgeGroup ageGroup;

@end
NS_ASSUME_NONNULL_END
