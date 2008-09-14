//
//  CRandomAccessTemporaryTable.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSqliteDatabase;

@interface CRandomAccessTemporaryTable : NSObject {
	NSString *tableName;
	CSqliteDatabase *database;
	BOOL dropOnDealloc;
}

@property (readonly, nonatomic, retain) CSqliteDatabase *database;
@property (readonly, nonatomic, retain) NSString *tableName;
@property (readonly, nonatomic, assign) BOOL dropOnDealloc;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase dropOnDealloc:(BOOL)inDropObDealloc;

- (BOOL)createTable:(NSError **)outError;
- (BOOL)dropTable:(NSError **)outError;
- (BOOL)insertForeignIds:(NSString *)inSelectStatement error:(NSError **)outError;

@end
