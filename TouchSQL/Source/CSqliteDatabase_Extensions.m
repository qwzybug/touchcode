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

- (NSError *)currentError
{
NSString *theErrorString = [NSString stringWithUTF8String:sqlite3_errmsg(self.sql)];
NSError *theError = [NSError errorWithDomain:TouchSQLErrorDomain code:sqlite3_errcode(self.sql) userInfo:[NSDictionary dictionaryWithObject:theErrorString forKey:NSLocalizedDescriptionKey]];
return(theError);
}

@end

#pragma mark -

@implementation CSqliteDatabase (CSqliteDatabase_Configuration)

@dynamic cacheSize;
@dynamic synchronous;
@dynamic tempStore;

- (NSString *)integrityCheck
{
return([self valueForExpression:@"pragma integrity_check;" error:NULL]);
}

- (int)cacheSize
{
return([[self valueForExpression:@"pragma cache_size;" error:NULL] intValue]);
}

- (void)setCacheSize:(int)inCacheSize
{
[self executeExpression:[NSString stringWithFormat:@"pragma cache_size=%d;", inCacheSize] error:NULL];
}

- (int)synchronous
{
return([[self valueForExpression:@"pragma synchronous;" error:NULL] intValue]);
}

- (void)setSynchronous:(int)inSynchronous
{
[self executeExpression:[NSString stringWithFormat:@"pragma synchronous=%d;", inSynchronous] error:NULL];
}

- (int)tempStore
{
return([[self valueForExpression:@"pragma temp_store;" error:NULL] intValue]);
}

- (void)setTempStore:(int)inTempStore
{
[self executeExpression:[NSString stringWithFormat:@"pragma temp_store=%d;", inTempStore] error:NULL];
}

@end
