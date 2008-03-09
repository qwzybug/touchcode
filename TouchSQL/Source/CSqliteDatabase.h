//
//  CSqliteDatabase.h
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface CSqliteDatabase : NSObject {
	NSString *path;
	sqlite3 *sql;
}

@property (readonly, retain) NSString *path;
@property (readonly, assign) sqlite3 *sql;

- (id)initWithPath:(NSString *)inPath;
- (id)initInMemory;

- (void)open;
- (void)close;

- (void)executeExpression:(NSString *)inExpression;
- (NSEnumerator *)enumeratorForExpression:(NSString *)inExpression;
- (NSArray *)rowsForExpression:(NSString *)inExpression;

@end

#pragma mark -

@interface CSqliteDatabase (CSqliteDatabase_Configuration)

- (NSString *)integrityCheck;

- (void)setCacheSize:(int)inCacheSize;
- (int)cacheSize;

- (void)setSynchronous:(int)inSynchronous;
- (int)synchronous;

- (void)setTempStore:(int)inTempStore;
- (int)tempStore;

@end
