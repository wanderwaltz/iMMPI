//
//  TestRecordDocument.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonIndexRecord.h"
#import "Person.h"

#pragma mark -
#pragma mark Constants

extern NSString * const kTestRecordDocumentExtension;


#pragma mark -
#pragma mark TestRecordDocument interface

@interface MMPIDocument : UIDocument
{
    NSFileWrapper *_fileWrapper;
    
    Person            *_person;
    PersonIndexRecord *_personIndexRecord;
}

@property (strong, nonatomic) PersonIndexRecord *personIndexRecord; // Lazy loaded
@property (strong, nonatomic) Person *person;                       // Lazy loaded

@end
