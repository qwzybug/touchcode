//
//  UnitTests.m
//  ToxicSQL
//
//  Created by Jonathan Wight on 06/07/2005.
//  Copyright 2005 Toxic Software. All rights reserved.
//

#import "UnitTests.h"

#import <ToxicSQL/ToxicSQL.h>

@implementation UnitTests

- (void)testFoo
{
	CSqliteDatabase *theDatabase = [[[CSqliteDatabase alloc] initInMemory] autorelease];

	[theDatabase executeExpression:@"create table foo (name varchar(100))"];

}

@end
