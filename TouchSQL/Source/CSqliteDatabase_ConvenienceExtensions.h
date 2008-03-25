//
//  CSqliteDatabase_ConvenienceExtensions.h
//  Prototype
//
//  Created by Jonathan Wight on Mon May 17 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase.h"

// Deprecated
@interface CSqliteDatabase (CSqliteDatabase_ConvenienceExtensions)

- (BOOL)populateTableName:(NSString *)inTableName tableColumns:(NSArray *)inTableColumns columnTypes:(NSArray *)inColumnTypes indexName:(NSString *)inIndexName indexColumns:(NSArray *)inIndexColumns primaryKey:(NSString *)inPrimaryKey withDictionariesFromEnumerator:(NSEnumerator *)inEnumerator error:(NSError **)outError;

@end
