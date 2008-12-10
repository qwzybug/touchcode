//
//  CSqliteDatabase_Deprecated.h
//  TouchSQL
//
//  Created by Jonathan Wight on 12/9/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CSqliteDatabase.h"

@interface CSqliteDatabase (CSqliteDatabase_Deprecated)

+ (NSDateFormatter *)dbDateFormatter;

- (BOOL)objectExistsOfType:(NSString *)inType name:(NSString *)inTableName temporary:(BOOL)inTemporary;
- (BOOL)tableExists:(NSString *)inTableName;
- (BOOL)temporaryTableExists:(NSString *)inTableName;

@end
