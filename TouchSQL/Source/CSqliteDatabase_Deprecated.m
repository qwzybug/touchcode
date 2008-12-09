//
//  CSqliteDatabase_Deprecated.m
//  TouchSQL
//
//  Created by Jonathan Wight on 12/9/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CSqliteDatabase_Deprecated.h"

#import "CSqliteDatabase_Extensions.h"

@implementation CSqliteDatabase (CSqliteDatabase_Deprecated)

+ (NSDateFormatter *)dbDateFormatter
{
NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[dateFormatter setGeneratesCalendarDates:NO];

return dateFormatter;
}

- (BOOL)objectExistsOfType:(NSString *)inType name:(NSString *)inTableName temporary:(BOOL)inTemporary
{
NSString *theSQL = [NSString stringWithFormat:@"select count(*) from %@ where TYPE = '%@' and NAME = '%@'", inTemporary == YES ? @"SQLITE_TEMP_MASTER" : @"SQLITE_MASTER", inType, inTableName];
NSString *theValue = [self valueForExpression:theSQL error:NULL];
return([theValue intValue] == 1);
}

- (BOOL)tableExists:(NSString *)inTableName
{
return([self objectExistsOfType:@"table" name:inTableName temporary:NO]);
}

- (BOOL)temporaryTableExists:(NSString *)inTableName
{
return([self objectExistsOfType:@"table" name:inTableName temporary:YES]);
}

@end
