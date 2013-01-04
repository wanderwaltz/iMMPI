//
//  TestAnswersViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "TestAnswersTableViewControllerBase.h"
#import "Model.h"


#pragma mark -
#pragma mark TestAnswersViewController interface

/*! A view controller suited to review TestAnswersProtocol answers provided in the TestRecordProtocol record and possibly correct some of them.
 
 This view controller displays a segmented control in each of the StatementTableViewCell cells which it creates, and allows setting each of the answers individually. Note that this functionality should be provided by the storyboard (i.e. storyboard should set the proper outlets of the corresponding prototype cells).
 
 The form of presentation implemented by this controller is not very comfortable to enter lots of answers at once.
 */
@interface TestAnswersViewController : TestAnswersTableViewControllerBase
@end
