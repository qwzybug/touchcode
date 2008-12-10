//
//  CSqliteStatement.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sqlite3.h>

@class CSqliteDatabase;

@interface CSqliteStatement : NSObject <NSFastEnumeration> {
	CSqliteDatabase *database;
	NSString *statementString;
	sqlite3_stmt *statement;
	NSError *error;
}

@property (readonly, nonatomic, assign) CSqliteDatabase *database;
@property (readonly, nonatomic, copy) NSString *statementString;
@property (readonly, nonatomic, assign) sqlite3_stmt *statement;
@property (readonly, nonatomic, retain)	NSError *error;

+ (CSqliteStatement *)statementWithDatabase:(CSqliteDatabase *)inDatabase format:(NSString *)inFormat, ...;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase string:(NSString *)inString;

- (BOOL)prepare:(NSError **)outError;

- (BOOL)reset:(NSError **)outError;

- (BOOL)clearBindings:(NSError **)outError;

- (BOOL)bindValues:(NSDictionary *)inValues transientValues:(BOOL)inTransientValues error:(NSError **)outError;

- (BOOL)step:(NSError **)outError;

- (NSInteger)columnCount:(NSError **)outError;
- (NSString *)columnNameAtIndex:(NSInteger)inIndex error:(NSError **)outError;
- (id)columnValueAtIndex:(NSInteger)inIndex error:(NSError **)outError;

- (NSArray *)columnNames:(NSError **)outError;

- (NSArray *)row:(NSError **)outError;
- (NSDictionary *)rowDictionary:(NSError **)outError;

- (NSArray *)rows:(NSError **)outError;
- (NSArray *)rowDictionaries:(NSError **)outError;

- (NSEnumerator *)enumerator;

@end
