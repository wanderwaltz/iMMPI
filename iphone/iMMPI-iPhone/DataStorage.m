//
//  DataStorage.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "DataStorage.h"
#import "Person.h"
#import "PersonIndexRecord.h"
#import "MMPIDocument.h"
#import "PersonListDocumentWrapper.h"

#pragma mark -
#pragma mark DataStorage implementation

@implementation DataStorage

#pragma mark -
#pragma mark Properties

- (NSArray *) personsListElements
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: _documents.count];
    
    for (id document in _documents)
    {
        [result addObject: 
         [PersonListDocumentWrapper instanceWithMMPIDocument: document]];
    }
    
    return result;
}


#pragma mark -
#pragma mark Model objects factory methods

+ (Person *) createPersonRecord
{
    return [Person instance];
}


+ (Person *) createIndexRecordForPerson: (Person *) person 
{
    return [PersonIndexRecord indexRecordForPerson: person];
}

#pragma mark -
#pragma mark Methods

+ (void) storePersonRecord: (Person *) person
{
    [[self shared] storePersonRecord: person];
}


#pragma mark -
#pragma mark Data I/O

- (MMPIDocument *) createNewDocument
{
    NSURL *fileURL = 
    [[NSFileManager documentsDirURL] URLByAppendingPathComponent:
     [NSString stringWithFormat: @"%@.%@", 
      [NSString stringWithUUID], kTestRecordDocumentExtension]];
    
    MMPIDocument *document = [[MMPIDocument alloc] initWithFileURL: fileURL];
    
    return document;
}


- (MMPIDocument *) createNewDocumentForPerson: (Person *) person
{
    MMPIDocument *document = [self createNewDocument];
    document.person = person;
    
    return document;
}


- (void) saveDocument: (MMPIDocument *) document
{
    [_documents addObject: document];
    
    [document saveToURL: document.fileURL
       forSaveOperation: UIDocumentSaveForCreating 
      completionHandler:
     ^(BOOL success) 
     {
         if (!success) 
         {
             NSLog(@"Failed to create file at %@", document.fileURL);
             return;
         } 
         
         NSLog(@"File created at %@", document.fileURL);        
     }]; 
}


- (void) storePersonRecord: (Person *) person
{
    MMPIDocument *document = [self createNewDocumentForPerson: person];
    [self saveDocument: document];
}


- (void) loadDocAtURL: (NSURL *) fileURL
{    
    MMPIDocument *document = [[MMPIDocument alloc] initWithFileURL: fileURL];
    [_documents addObject: document];
    [document openWithCompletionHandler: nil];
}


- (void) loadLocalDocuments 
{    
    NSArray *localDocuments = 
    [[NSFileManager defaultManager] 
     contentsOfDirectoryAtURL: [NSFileManager documentsDirURL] 
   includingPropertiesForKeys: nil 
                      options: 0 
                        error: nil];
    
    
    for (NSUInteger i = 0; i < localDocuments.count; i++) 
    {
        NSURL *fileURL = [localDocuments objectAtIndex: i];
        
        if ([[fileURL pathExtension] isEqualToString: kTestRecordDocumentExtension]) 
        {
            [self loadDocAtURL: fileURL];
        }        
    }
}


+ (void) loadLocalDocuments
{
    [[self shared] loadLocalDocuments];
}



#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _documents = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark Singleton

CLASS_SYNTHESIZE_SHARED_INSTANCE(shared, id, [self instance]);

@end
