//
//  CSqliteEnumerator.m
//  sqllitetest
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

#import "CSqliteEnumerator.h"

@interface CSqliteEnumerator ()
@property (readwrite, assign) sqlite3_stmt *statement;
@end

@implementation CSqliteEnumerator

@synthesize statement;

- (id)initWithStatement:(sqlite3_stmt *)inStatement
{
if (self = ([super init]))
	{
	self.statement = inStatement;
	}
return(self);
}

- (void)dealloc
{
int theResult = sqlite3_finalize(statement);
self.statement = NULL;
//
[super dealloc];
//
if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_finalize() failed with %d", theResult];
}

- (id)nextObject
{
int theResult = sqlite3_step(self.statement);

if (theResult != SQLITE_ROW)
	return(NULL);

NSMutableDictionary *theRow = [NSMutableDictionary dictionary];
int theColumnCount = sqlite3_column_count(self.statement);
for (int N = 0; N != theColumnCount; ++N)
	{
	const char *theColumnName = sqlite3_column_name(self.statement, N);
	const unsigned char *theColumnData = sqlite3_column_text(self.statement, N);
	if (theColumnName != NULL)
		{
		NSString *theKey = [NSString stringWithUTF8String:theColumnName];
		id theValue = NULL;
		if (theColumnData == NULL)
			theValue = [NSNull null];
		else
			theValue = [NSString stringWithUTF8String:(const char *)theColumnData];
		
		[theRow setObject:theValue forKey:theKey];
		}
	}
return(theRow);
}

@end
