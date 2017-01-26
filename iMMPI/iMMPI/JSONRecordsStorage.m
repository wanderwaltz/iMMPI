//
//  JSONRecordsStorage.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "iMMPI-Swift.h"
#import "FRBAssertMacros.h"
#import "JSONRecordsStorage.h"

#pragma mark -
#pragma mark Static constants

static NSString * const kJSONPathExtension = @"json";
static NSString * const kIndexFileName     = @"index";

#pragma mark -
#pragma mark Constants

NSString * const kJSONRecordStorageDirectoryDefault = @"JSONRecords";
NSString * const kJSONRecordStorageDirectoryTrash   = @"JSONRecords-Trash";


/// Returns object if object is not nil, else returns [NSNull null]
id nil2Null(id _Nullable object);

/// Returns object if object is not of NSNull class, else returns nil
id _Nullable null2Nil(id _Nullable object);

#pragma mark -
#pragma mark JSONRecordStorage private

@interface JSONRecordsStorage()
{
    NSMutableArray *_elements;
    NSMutableSet   *_loadedFileNames;
    
    NSString    *_storageDirectoryName;
    NSString    *_storedRecordsPath;
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark JSONRecordsStorage implementation

@implementation JSONRecordsStorage

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    return [self initWithDirectoryName: kJSONRecordStorageDirectoryDefault];
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
#pragma mark RecordStorage

- (BOOL) addNewRecord: (id<RecordProtocol>) record
{
    BOOL didAdd = NO;
    
    JSONRecordStorageElement *element = [JSONRecordStorageElement new];
    element.record = record;
    
    [_elements addObject: element];
    didAdd = [self storeElement: element];
    
    return didAdd;
}


- (BOOL) updateRecord: (id<RecordProtocol>) record
{
    BOOL didUpdate = NO;
    
    JSONRecordStorageElement *element = [self elementForRecord: record];
    
    if (element != nil)
    {
        didUpdate = [self storeElement: element];
    }
    
    return didUpdate;
}


- (BOOL) removeRecord: (id<RecordProtocol>) record
{
    BOOL didRemove = NO;
    
    JSONRecordStorageElement *element = [self elementForRecord: record];
    
    if (element != nil)
    {
        didRemove = [self removeElement: element];
    }
    
    return didRemove;
}


- (void) loadRecordsIndex
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString      *indexPath   = [[_storedRecordsPath stringByAppendingPathComponent: kIndexFileName]
                                  stringByAppendingPathExtension: kJSONPathExtension];
    
    if ([fileManager fileExistsAtPath: indexPath isDirectory: NULL])
    {
        NSData *indexData = [NSData dataWithContentsOfFile: indexPath];
        NSArray  *proxies = [self.indexSerialization decode: indexData];
        
        for (JSONRecordProxy *proxy in proxies)
        {
            NSParameterAssert(proxy.fileName != nil);
            
            // Skip nonexistant files in index
            NSString *proxiedFilePath = [_storedRecordsPath stringByAppendingPathComponent: proxy.fileName];
            if (![fileManager fileExistsAtPath: proxiedFilePath isDirectory: NULL]) {
                continue;
            }
            
            if (![_loadedFileNames containsObject: proxy.fileName])
            {
                JSONRecordStorageElement *element = [JSONRecordStorageElement new];
                element.record   = proxy;
                element.fileName = proxy.fileName;
                
                [_loadedFileNames addObject: proxy.fileName];
                [_elements        addObject:        element];
            }
        }
    }
}


- (void) saveRecordsIndex
{
    NSArray  *indexProxies = [self allRecords];
    NSData   *indexData    = [self.indexSerialization encode: indexProxies];
    
    if (indexData != nil)
    {
        NSString *indexPath = [[_storedRecordsPath stringByAppendingPathComponent: kIndexFileName]
                               stringByAppendingPathExtension: kJSONPathExtension];
        
        [indexData writeToFile: indexPath atomically: YES];
    }
}


- (BOOL) loadStoredRecords
{
    [self loadRecordsIndex];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray       *subpaths    = [fileManager subpathsAtPath: _storedRecordsPath];
    
    for (NSString *fileName in subpaths)
    {
        if ([[fileName pathExtension] isEqualToString: kJSONPathExtension] &&
            ![_loadedFileNames containsObject: fileName])
        {
            NSString *path = [_storedRecordsPath stringByAppendingPathComponent: fileName];
            NSData   *data = [NSData dataWithContentsOfFile: path];
            
            id<RecordProtocol> record = [self.serialization decode: data];
            
            if (record != nil)
            {
                JSONRecordStorageElement *element = [JSONRecordStorageElement new];
                element.record =
                [[JSONRecordProxy alloc] initWithRecord: record
                                                   fileName: fileName
                                                  directory: _storageDirectoryName];
                element.fileName = fileName;
                
                [_loadedFileNames addObject: fileName];
                [_elements        addObject:  element];
            }
        }
    }
    
    [self saveRecordsIndex];
    
    NSLog(@"%ld files loaded", (long)_loadedFileNames.count);
    
    return YES;
}


- (NSArray *) allRecords
{
    NSMutableArray *records = [NSMutableArray arrayWithCapacity: _elements.count];
    
    for (JSONRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONRecordStorageElement);
        if (element.record != nil)
            [records addObject: element.record];
    }
    
    return records;
}


- (BOOL) containsRecord: (id<RecordProtocol>) record
{
    FRB_AssertNotNil(record);
    
    for (JSONRecordStorageElement *element in _elements)
    {
        FRB_AssertClass(element, JSONRecordStorageElement);
        if (element.record == record)
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


- (BOOL) removeElement: (JSONRecordStorageElement *) element
{
    BOOL     didRemove = NO;
    NSString *fileName = element.fileName;
    
    if (fileName.length > 0)
    {
        if ([_trashStorage addNewRecord: element.record])
        {
            didRemove = [self removeRecordFileWithName: element.fileName];   
        }
    }
    
    if (didRemove)
    {
        [_elements removeObject: element];
        [self saveRecordsIndex];
    }
    
    return didRemove;
}


- (BOOL) storeElement: (JSONRecordStorageElement *) element
{
    BOOL didStore = NO;
    
    if (element.record != nil)
    {
        FRB_AssertConformsTo(element.record, RecordProtocol);
        
        NSData *jsonData = [self.serialization encode: element.record];
        
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
            NSLog(@"JSONRecordsStorage failed to remove test record file named '%@' with error: %@", fileName, error);
        }
        else
        {
            [_loadedFileNames removeObject: fileName];
        }
        
        return deleted;
    }
    else return YES;
}


- (NSString *) fileNameForRecord: (id<RecordProtocol>) record
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


- (JSONRecordStorageElement *) elementForRecord: (id<RecordProtocol>) record
{
    JSONRecordStorageElement *found = nil;
    
    if (record != nil)
    {
        for (JSONRecordStorageElement *element in _elements)
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


id nil2Null(id object)
{
    if (object != nil) return object;
    else return [NSNull null];
}


id null2Nil(id object)
{
    if (![object isKindOfClass: [NSNull class]]) return object;
    else return nil;
}
