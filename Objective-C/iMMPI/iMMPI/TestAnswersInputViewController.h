//
//  TestAnswersInputViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "TestAnswersTableViewControllerBase.h"
#import "Model.h"


#pragma mark -
#pragma mark TestAnswersInputViewController interface

/*! This class presents interface suitable to entering answers for the MMPI test in order starting with first and finishing with last question.
 
 This view controller has a set of toolbar items which provide the means to enter positive/negative answers to each statement. A current statement is displayed as usual, all other (not currently selected) statements are dimmed so the attention of the user is focused on a single selected statement.
 */
@interface TestAnswersInputViewController : TestAnswersTableViewControllerBase
@end
