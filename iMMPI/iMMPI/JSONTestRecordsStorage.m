//
//  JSONTestRecordsStorage.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JSONTestRecordsStorage.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kJSONPathExtension = @"json";
static NSString * const kIndexFileName     = @"index";

#pragma mark -
#pragma mark Constants

NSString * const kJSONTestRecordStorageDirectoryDefault = @"JSONRecords";
NSString * const kJSONTestRecordStorageDirectoryTrash   = @"JSONRecords-Trash";


#pragma mark -
#pragma mark JSONTestRecordStorage private

@interface JSONTestRecordsStorage()
{
    NSMutableArray *_elements;
    NSMutableSet   *_loadedFileNames;
    
    NSString    *_storageDirectoryName;
    NSString    *_storedRecordsPath;
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark JSONTestRecordsStorage implementation

@implementation JSONTestRecordsStorage

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    return [self initWithDirectoryName: kJSONTestRecordStorageDirectoryDefault];
}


- (id) initWithDirectoryName: (NSString *) storageDirectoryName
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *storedRecordsPath = [[directories lastObject] stringByAppendingPathComponent:
                                   storageDirectoryName];
        
    FRB_AssertNotNil(storedRecordsPath);
    
    if (![self createFolderAtPathIfNeeded: storedRecordsPath])
        return nil;
        
    self = [super init];
    
    if (self != nil)
    {
        _elements        = [NSMutableArray array];
        _loadedFileNames = [NSMutableSet   set];
     
        _storageDirectoryName = storageDirectoryName;
        _storedRecordsPath    = storedRecordsPath;
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark TestRecordStorage

- (BOOL) addNewTestRecord: (id<TestRecordProtocol>) testRecord
{
    BOOL didAdd = NO;
    
    JSONTestRecordStorageElement *element = [JSONTestRecordStorageElement new];
    element.record = testRecord;
    
    [_elements addObject: element];
    didAdd = [self storeElement: element];
    
    return didAdd;
}


- (BOOL) updateTestRecord: (id<TestRecordProtocol>) testRecord
{
    BOOL didUpdate = NO;
    
    JSONTestRecordStorageElement *element = [self elementForRecord: testRecord];
    
    if (element != nil)
    {
        didUpdate = [self storeElement: element];
    }
    
    return didUpdate;
}


- (BOOL) removeTestRecord: (id<TestRecordProtocol>) testRecord
{
    BOOL didRemove = NO;
    
    JSONTestRecordStorageElement *element = [self elementForRecord: testRecord];
    
    if (element != nil)
    {
        didRemove = [self removeElement: element];
    }
    
    return didRemove;
}


- (void) loadTestRecordsIndex
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString      *indexPath   = [[_storedRecordsPath stringByAppendingPathComponent: kIndexFileName]
                                  stringByAppendingPathExtension: kJSONPathExtension];
    
    if ([fileManager fileExistsAtPath: indexPath isDirectory: NULL])
    {
        NSData *indexData = [NSData dataWithContentsOfFile: indexPath];
        NSArray  *proxies = [JSONTestRecordSerialization recordProxiesFromIndexData: indexData];
        
        for (JSONTestRecordProxy *proxy in proxies)
        {
            NSParameterAssert(proxy.fileName != nil);
            
            // Skip nonexistant files in index
            NSString *proxiedFilePath = [_storedRecordsPath stringByAppendingPathComponent: proxy.fileName];
            if (![fileManager fileExistsAtPath: proxiedFilePath isDirectory: NULL]) {
                continue;
            }
            
            if (![_loadedFileNames containsObject: proxy.fileName])
            {
                JSONTestRecordStorageElement *element = [JSONTestRecordStorageElement new];
                element.record   = proxy;
                element.fileName = proxy.fileName;
                
                [_loadedFileNames addObject: proxy.fileName];
                [_elements        addObject:        element];
            }
        }
    }
}


- (void) saveTestRecordsIndex
{
    NSArray  *indexProxies = [self allTestRecords];
    NSData   *indexData    = [JSONTestRecordSerialization indexDataForRecordProxies: indexProxies];
    
    if (indexData != nil)
    {
        NSString *indexPath = [[_storedRecordsPath stringByAppendingPathComponent: kIndexFileName]
                               stringByAppendingPathExtension: kJSONPathExtension];
        
        [indexData writeToFile: indexPath atomically: YES];
    }
}


- (BOOL) loadStoredTestRecords
{
    [self loadTestRecordsIndex];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray       *subpaths    = [fileManager subpathsAtPath: _storedRecordsPath];
    
    for (NSString *fileName in subpaths)
    {
        if ([[fileName pathExtension] isEqualToString: kJSONPathExtension] &&
            ![_loadedFileNames containsObject: fileName])
        {
            NSString *path = [_storedRecordsPath stringByAppendingPathComponent: fileName];
            NSData   *data = [NSData dataWithContentsOfFile: path];
            
            id<TestRecordProtocol> record = [JSONTestRecordSerialization testRecordFromData: data];
            
            if (record != nil)
            {
                JSONTestRecordStorageElement *element = [JSONTestRecordStorageElement new];
                element.record =
                [[JSONTestRecordProxy alloc] initWithRecord: record
                                                   fileName: fileName
                                                  directory: _storageDirectoryName];
                element.fileName = fileName;
                
                [_loadedFileNames addObject: fileName];
                [_elements        addObject:  element];
            }
        }
    }
    
    [self saveTestRecordsIndex];
    
    NSLog(@"%ld files loaded", (long)_loadedFileNames.count);
    
    return YES;
}


- (NSArray *) allTestRecords
{
    NSMutableArray *records = [NSMutableArray arrayWithCapacity: _elements.count];
    
    for (JSONTestRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONTestRecordStorageElement);
        if (element.record != nil)
            [records addObject: element.record];
    }
    
    return records;
}


- (BOOL) containsTestRecord: (id<TestRecordProtocol>) testRecord
{
    FRB_AssertNotNil(testRecord);
    
    for (JSONTestRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONTestRecordStorageElement);
        if (element.record == testRecord)
            return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark private

- (BOOL) createFolderAtPathIfNeeded: (NSString *) path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSError *error = nil;
        
        BOOL created =
        [fileManager createDirectoryAtPath: path
               withIntermediateDirectories: YES
                                attributes: nil
                                     error: &error];
        
        if (!created)
        {
            NSLog(@"Failed to create directory at path '%@' with error: %@",
                  path, error);
            return NO;
        }
    }

    return YES;
}


- (BOOL) removeElement: (JSONTestRecordStorageElement *) element
{
    BOOL     didRemove = NO;
    NSString *fileName = element.fileName;
    
    if (fileName.length > 0)
    {
        if ([_trashStorage addNewTestRecord: element.record])
        {
            didRemove = [self removeRecordFileWithName: element.fileName];   
        }
    }
    
    if (didRemove)
    {
        [_elements removeObject: element];
        [self saveTestRecordsIndex];
    }
    
    return didRemove;
}


- (BOOL) storeElement: (JSONTestRecordStorageElement *) element
{
    BOOL didStore = NO;
    
    if (element.record != nil)
    {
        FRB_AssertConformsTo(element.record, TestRecordProtocol);
        
        NSData *jsonData = [JSONTestRecordSerialization dataWithTestRecord: element.record];
        
        if (jsonData)
        {
            NSString *fileName          = element.fileName;
            NSString *suggestedFileName = [self fileNameForRecord: element.record];
            
            if ((fileName != nil) && ![fileName isEqualToString: suggestedFileName])
            {
                // Remove the file containing the old version
                // since the new suggested file name has changed
                [self removeRecordFileWithName: fileName];
            }
            
            element.fileName = suggestedFileName;
            [_loadedFileNames addObject: suggestedFileName];
            
            NSString *path = [_storedRecordsPath stringByAppendingPathComponent:
                              suggestedFileName];
            
            didStore = [jsonData writeToFile: path atomically: YES];
        }
    }
    
    return didStore;
}


- (BOOL) removeRecordFileWithName: (NSString *) fileName
{
    NSString *path = [_storedRecordsPath stringByAppendingPathComponent:
                        fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSError *error = nil;
        
        BOOL deleted = [fileManager removeItemAtPath: path
                                               error: &error];
        
        if (!deleted)
        {
            NSLog(@"JSONTestRecordsStorage failed to remove test record file named '%@' with error: %@", fileName, error);
        }
        else
        {
            [_loadedFileNames removeObject: fileName];
        }
        
        return deleted;
    }
    else return YES;
}


- (NSString *) fileNameForRecord: (id<TestRecordProtocol>) record
{
    NSString *candidate = [NSString stringWithFormat: @"%@ - %@",
                           record.person.name, [_dateFormatter stringFromDate: record.date]];
    
    NSCharacterSet *illegalFileNameCharacters =
    [NSCharacterSet characterSetWithCharactersInString: @"/\\?%*|\"<>$&@"];
    
    candidate = [[candidate componentsSeparatedByCharactersInSet: illegalFileNameCharacters]
                 componentsJoinedByString: @""];
    
    NSString *fileName  = [candidate stringByAppendingPathExtension: kJSONPathExtension];
    NSInteger attempts  = 0;
    
    while (![self fileNameIsAvailable: fileName])
    {
        attempts++;
        fileName = [[candidate stringByAppendingFormat: @" %ld", (long)attempts]
                    stringByAppendingPathExtension: kJSONPathExtension];
    }
    
    return fileName;
}


- (BOOL) fileNameIsAvailable: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fullPath = [_storedRecordsPath stringByAppendingPathComponent: fileName];
    
    return ![fileManager fileExistsAtPath: fullPath];
}


- (JSONTestRecordStorageElement *) elementForRecord: (id<TestRecordProtocol>) record
{
    JSONTestRecordStorageElement *found = nil;
    
    if (record != nil)
    {
        for (JSONTestRecordStorageElement *element in _elements)
        {
            if (element.record == record)
            {
                found = element;
                break;
            }
        }
    }
    
    return found;
}


@end
