//
//  CSqliteDatabase_Extensions.m
//  DBTest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CSqliteDatabase_Extensions.h"

@implementation CSqliteDatabase (CSqliteDatabase_Extensions)

// TODO -- most of these methods can be heavily optimised and more error checking added (search for NULL)

- (NSUInteger)countRowsInTable:(NSString *)inTableName error:(NSError **)outError
{
id theEnumerator = [self enumeratorForExpression:[NSString stringWithFormat:@"select count(*) from %@;", inTableName] error:outError];
NSArray *theObjects = [theEnumerator allObjects];
// TODO make sure only 1 object is returned.
NSArray *theValues = [[theObjects lastObject] allValues];
// TODO make sure only 1 object is returned.
NSString *theString = [theValues lastObject];
return([theString intValue]);
}

- (NSDictionary *)rowForExpression:(NSString *)inExpression error:(NSError **)outError
{
NSArray *theRows = [self rowsForExpression:inExpression error:outError];
if ([theRows count] > 0)
	return([theRows objectAtIndex:0]);
else
	return(NULL);
}

- (NSArray *)valuesForExpression:(NSString *)inExpression error:(NSError **)outError
{
NSDictionary *theRow = [self rowForExpression:inExpression error:outError];
return([theRow allValues]);
}

- (id)valueForExpression:(NSString *)inExpression error:(NSError **)outError
{
NSArray *theValues = [self valuesForExpression:inExpression error:outError];
// TODO -- check only 1 object is returned?
return([theValues lastObject]);
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

+ (NSDateFormatter *)dbDateFormatter
{
NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[dateFormatter setGeneratesCalendarDates:NO];

return dateFormatter;
}

@end
