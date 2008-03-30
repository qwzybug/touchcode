//
//  NSData_SqlExtensions.m
//  kcal
//
//  Created by Ian Baird on 3/30/08.
//  Copyright 2008 Skorpiostech, Inc.. All rights reserved.
//

#import "NSData_SqlExtensions.h"

#import "CSqliteDatabase.h"

@implementation NSData (NSData_SqlExtensions)

- (BOOL)writeToDatabase:(CSqliteDatabase *)database table:(NSString *)table field:(NSString *)field whereClause:(NSString *)whereClause
{
    BOOL success = NO;
    sqlite3_stmt *pStmt;
    const char *zTail;
    NSString *sqlExpression = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@", table, field, whereClause]; 
    int resultCode = sqlite3_prepare_v2([database sql], [sqlExpression UTF8String], -1, &pStmt, &zTail);
    if (resultCode == SQLITE_OK)
    {
        resultCode = sqlite3_bind_blob(pStmt, 1, [self bytes], [self length], SQLITE_STATIC);
        if(resultCode == SQLITE_OK)
        {
            success = (sqlite3_step(pStmt) == SQLITE_DONE);
        }
        sqlite3_finalize(pStmt);
    }
    return success;
}

@end
