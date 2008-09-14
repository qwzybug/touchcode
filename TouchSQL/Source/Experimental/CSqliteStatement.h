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

@interface CSqliteStatement : NSObject {
	CSqliteDatabase *database;
	NSString *string;
	sqlite3_stmt *statement;
}

@property (readonly, nonatomic, assign) CSqliteDatabase *database;
@property (readonly, nonatomic, copy) NSString *string;
@property (readonly, nonatomic, assign) sqlite3_stmt *statement;

+ (CSqliteStatement *)statementWithDatabase:(CSqliteDatabase *)inDatabase format:(NSString *)inFormat, ...;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase string:(NSString *)inString;

- (BOOL)compile:(NSError **)outError;

//- (BOOL)execute:(NSError **)outError;
//- (NSArray *)rowsFromExecution:(NSError **)outError;

@end
