//
//  CSqliteDatabase_Extensions.h
//  DBTest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase.h"

@interface CSqliteDatabase (CSqliteDatabase_Extensions)

- (NSUInteger)countRowsInTable:(NSString *)inTableName error:(NSError **)outError;

- (NSDictionary *)rowForExpression:(NSString *)inExpression error:(NSError **)outError;

- (NSArray *)valuesForExpression:(NSString *)inExpression error:(NSError **)outError;

- (id)valueForExpression:(NSString *)inExpression error:(NSError **)outError;

- (BOOL)objectExistsOfType:(NSString *)inType name:(NSString *)inTableName temporary:(BOOL)inTemporary;
- (BOOL)tableExists:(NSString *)inTableName;
- (BOOL)temporaryTableExists:(NSString *)inTableName;

+ (NSDateFormatter *)dbDateFormatter;

@end
