//
//  main.m
//  TouchSQL
//
//  Created by Jonathan Wight on 5/16/09.
//  Copyright 2009 Small Society. All rights reserved.
//


#import "TouchSQL.h"

int main(int argc, char **argv)
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

	CSqliteDatabase *db = [[[CSqliteDatabase alloc] initInMemory] autorelease];
	[db open:NULL];
	
	BOOL result;
	result = [db executeExpression:@"create table foo (name varchar(100))" error:NULL];
	NSLog(@"%d", result);
	
	result = [db executeExpression:@"INSERT INTO foo VALUES ('testname') " error:NULL];
	NSLog(@"%d", result);

	
	NSError *err = NULL;
	NSArray *rows = [db rowsForExpression:@"SELECT * FROM foo WHERE 1" error:&err];
	NSLog(@"%@", err);
	NSLog(@"%@", rows);
	
	NSDictionary *row = [rows objectAtIndex:0];
	NSLog(@"%@", row);


[thePool release];
return(0);
}