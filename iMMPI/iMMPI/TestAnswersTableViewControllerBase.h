//
//  TestAnswersTableViewControllerBase.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatementTableViewCell.h"
#import "Model.h"


#pragma mark -
#pragma mark TestAnswersTableViewControllerBase interface

/*! A base class for presenting and editing TestRecordProtocol record answers in a UITableView-driven UI.
 
 This class uses StatementTableViewCell cells to display the statements of the questionnaire. The UITableViewDataSource methods are implemented to display the questionnaire contents in a single section list.
 
 TestAnswersTableViewControllerBase is automatically set as the delegate for each of the StatementTableViewCell used in the table view.
 
 It is expected that the table view does return a StatementTableViewCell object for [StatementTableViewCell reuseIdentifier] string (this is set up in the storyboard).
 
 @see TestAnswersInputViewController, TestAnswersViewController
 */
@interface TestAnswersTableViewControllerBase : UITableViewController
<StatementTableViewCellDelegate>

/*! A TestRecordProtocol object to be managed by the view controller.
 
 This property should be set prior to showing the view contorller's view on screen, so the questionnaire can be properly set up (questionnaire depends on the PersonProtocol object properties which are retrieved from the record).
 */
@property (strong, nonatomic) id<TestRecordProtocol> record;



/*! A storage for the TestRecordProtocol record.
 
 Records managed by the TestAnswersTableViewControllerBase are assumed to be stored in the TestRecordStorage object provided in this property. When saving state of the record, the -updateTestRecord: method is called on the provided storage object.
 */
@property (strong, nonatomic) id<TestRecordStorage> storage;



/*! The QuestionnaireProtocol object which provides the questionnaire info.

 If this property is not set manually, it can be set automatically using the -loadQuestionnaireAsyncIfNeeded and -loadQuestionnaireAsyncIfNeeded: methods.
 */
@property (strong, nonatomic) id<QuestionnaireProtocol> questionnaire;



/*! Loads the questionnaire asynchronously if questionnaire property value is nil.
 
 Creates a new Questionnaire object depending on the values of the PersonProtocol object read from the record property. The questionnaire is loaded asynchronously in background and a completion callback block is dispatched on main queue then.
 
 This method does nothing if record property value is nil.
 
 @param completion A block to be dispatched on main queue when the questionnaire is loaded.s
 */
- (void) loadQuestionnaireAsyncIfNeeded: (dispatch_block_t) completion;



/*! A default variant of the -loadQuestionnaireAsyncIfNeeded: method which calls -reloadData on the table view when the questionnaire finishes loading.
 */
- (void) loadQuestionnaireAsyncIfNeeded;



/*! Returns a StatementProtocol object for a given indexPath.
 
 @param indexPath Index path associated with a certain statement.
 
 @return This method returns a statement corresponding to one of the table view cells with the provided index path. If the index path is out of the valid table view bounds (provided by the -numberOfSectionsInTalbeView: and -tableView:numberOfRowsInSection: methods of the UITableViewDataSource protocol), returns nil.
 */
- (id<StatementProtocol>) statementAtIndexPath: (NSIndexPath *) indexPath;



/*! Updates the record in the storage object provided.
 
 @return If record property is not nil, calls [TestRecordStorage updateTestRecord:] on the storage object and returns the result, else returns NO.
 */
- (BOOL) saveRecord;

@end
