//
//  CSqliteDatabase_Extensions.h
//  DBTest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase.h"

@interface CSqliteDatabase (CSqliteDatabase_Extensions)

- (BOOL)executeExpressionIgnoringExceptions:(NSString *)inExpression;

- (void)executeExpressionFormat:(NSString *)inFormat, ...;

- (NSEnumerator *)enumeratorForExpressionFormat:(NSString *)inFormat, ...;

- (NSUInteger)countRowsInTable:(NSString *)inTableName;

- (NSDictionary *)rowForExpression:(NSString *)inExpression;

- (NSArray *)valuesForExpression:(NSString *)inExpression;

- (NSString *)valueForExpression:(NSString *)inExpression;

- (BOOL)objectExistsOfType:(NSString *)inType name:(NSString *)inTableName temporary:(BOOL)inTemporary;
- (BOOL)tableExists:(NSString *)inTableName;
- (BOOL)temporaryTableExists:(NSString *)inTableName;

@end
