//
//  CSqliteEnumerator.m
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
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
if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_finalize() failed with %d", theResult];
self.statement = NULL;
//
[super dealloc];
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
	if (theColumnName != NULL && theColumnData != NULL)
		{
		NSString *theKey = [NSString stringWithUTF8String:theColumnName];
		NSString *theValue = [NSString stringWithUTF8String:(const char *)theColumnData];
		[theRow setObject:theValue forKey:theKey];
		}
	}
return(theRow);
}

@end
