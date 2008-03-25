//
//  CSqliteDatabase.h
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

extern NSString *TouchSQLErrorDomain /* = @"TouchSQLErrorDomain" */;

@interface CSqliteDatabase : NSObject {
	NSString *path;
	sqlite3 *sql;
}

@property (readonly, retain) NSString *path;
@property (readonly, assign) sqlite3 *sql;

- (id)initWithPath:(NSString *)inPath;
- (id)initInMemory;

- (BOOL)open:(NSError **)outError;
- (void)close;

- (BOOL)executeExpression:(NSString *)inExpression error:(NSError **)outError;
- (NSEnumerator *)enumeratorForExpression:(NSString *)inExpression error:(NSError **)outError;
- (NSArray *)rowsForExpression:(NSString *)inExpression error:(NSError **)outError;

@end

#pragma mark -

@interface CSqliteDatabase (CSqliteDatabase_Configuration)

- (NSString *)integrityCheck;

@property (readwrite, assign) int cacheSize;
@property (readwrite, assign) int synchronous;
@property (readwrite, assign) int tempStore;

@end
