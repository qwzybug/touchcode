//
//  CKeyValueStore.m
//  TouchCode
//
//  Created by Jonathan Wight on 2/27/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "CKeyValueStore.h"

#import "CSqliteDatabase.h"
#import "CSqliteDatabase_Extensions.h"
#import "CSqliteDatabase_Deprecated.h"
#import "CSqliteStatement.h"

@interface CKeyValueStore ()
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, retain) NSString *databasePath;
@property (readwrite, nonatomic, retain) CSqliteDatabase *database;
@end

#pragma mark -

@implementation CKeyValueStore

@synthesize name;
@dynamic databasePath;
@dynamic database;

//+ (void)load
//{
//NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
////
//CKeyValueStore *theStore = [CKeyValueStore namedKeyValueStore:@"test"];
//[theStore setObject:@"HELLO WORLD" forKey:@"test"];
//NSLog(@"%@", [theStore objectForKey:@"test"]);
//
//[theStore setObject:[NSDate date] forKey:@"test_date"];
//NSLog(@"%@", [theStore objectForKey:@"test_date"]);
//
////
//[thePool release];
//}

+ (CKeyValueStore *)namedKeyValueStore:(NSString *)inName
{
CKeyValueStore *theStore = [[[CKeyValueStore alloc] initWithName:inName error:NULL] autorelease];
return(theStore);
}

- (id)initWithName:(NSString *)inName error:(NSError **)outError
{
if ((self = [self init]) != NULL)
	{
	self.name = inName;
	}
return(self);
}

- (void)dealloc
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

if (database)
	[self.database close];

self.name = NULL;
self.databasePath = NULL;
self.database = NULL;

[thePool release];
//
[super dealloc];
}

#pragma mark -

- (NSString *)databasePath
{
if (databasePath == NULL)
	{
	NSString *theApplicationSupportFolder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *thePath = [theApplicationSupportFolder stringByAppendingPathComponent:@"KeyValueStores"];

	if ([[NSFileManager defaultManager] fileExistsAtPath:thePath] == NO)
		{
		NSError *theError = NULL;
		[[NSFileManager defaultManager] createDirectoryAtPath:thePath withIntermediateDirectories:YES attributes:NULL error:&theError];
		}

	thePath = [thePath stringByAppendingPathComponent:[self.name stringByAppendingPathExtension:@"db"]];
	databasePath = [thePath retain];
	}
return(databasePath);
}

- (void)setDatabasePath:(NSString *)inDatabasePath
{
if (databasePath != inDatabasePath)
	{
	[databasePath autorelease];
	databasePath = [inDatabasePath retain];
    }
}

- (CSqliteDatabase *)database
{
if (database == NULL)
	{
	NSError *theError = NULL;

	CSqliteDatabase *theDatabase = [[[CSqliteDatabase alloc] initWithPath:self.databasePath] autorelease];
	[theDatabase open:&theError];

	if ([theDatabase tableExists:@"schema_version"] == NO)
		{
		[theDatabase executeExpression:@"BEGIN TRANSACTION; CREATE TABLE schema_version (version INTEGER); INSERT INTO schema_version (version) VALUES (1); COMMIT TRANSACTION;" error:&theError];
		NSLog(@"CKeyValueStore error: %@", theError);
		}

	NSDictionary *theRow = [theDatabase rowForExpression:@"SELECT version FROM schema_version" error:&theError];
	NSInteger theVersion = [[theRow objectForKey:@"version"] integerValue];
	if (theVersion != 1)
		NSLog(@"CKeyValueStore version mismatch");

	if ([theDatabase tableExists:@"key_values"] == NO)
		{
		[theDatabase executeExpression:@"CREATE TABLE key_values (key TEXT PRIMARY KEY UNIQUE, class TEXT NOT NULL, encoded INTEGER, value NOT NULL);" error:&theError];
		NSLog(@"CKeyValueStore error: %@", theError);
		}

	self.database = theDatabase;
	}
return(database);
}

- (void)setDatabase:(CSqliteDatabase *)inDatabase
{
if (database != inDatabase)
	{
	if (database != NULL)
		{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];


		[database autorelease];
		database = NULL;
		}

	if (inDatabase != NULL)
		{
		database = [inDatabase retain];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotification:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
		}
    }
}

#pragma mark -

- (void)setObject:(id)inObject forKey:(NSString *)inKey
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

BOOL theEncodedFlag = YES;

if ([inObject isKindOfClass:[NSString class]]
	|| [inObject isKindOfClass:[NSNumber class]])
	{
	theEncodedFlag = NO;
	}

NSString *theClassName = NSStringFromClass([inObject class]);
id theValue = NULL;
if (theEncodedFlag == YES)
	theValue = [NSKeyedArchiver archivedDataWithRootObject:inObject];
else
	theValue = inObject;

NSError *theError = NULL;

CSqliteStatement *theStatement = [CSqliteStatement statementWithDatabase:self.database format:@"INSERT OR REPLACE INTO key_values (key, class, encoded, value) VALUES ($key, $class, $encoded, $value)"];

[theStatement bindValue:inKey toBinding:@"$key" transientValue:NO error:&theError];
[theStatement bindValue:theClassName toBinding:@"$class" transientValue:NO error:&theError];
[theStatement bindValue:[NSNumber numberWithBool:theEncodedFlag] toBinding:@"$encoded" transientValue:NO error:&theError];
[theStatement bindValue:theValue toBinding:@"$value" transientValue:NO error:&theError];

[theStatement execute:&theError];

[thePool release];
}

- (id)objectForKey:(NSString *)inKey
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

CSqliteStatement *theStatement = [CSqliteStatement statementWithDatabase:self.database format:@"SELECT * FROM key_values WHERE key = $key"];
NSError *theError = NULL;

[theStatement bindValue:inKey toBinding:@"$key" transientValue:NO error:&theError];

NSDictionary *theRow = [theStatement rowDictionary:&theError];

BOOL theEncodedFlag = [[theRow objectForKey:@"encoded"] boolValue];
id theValue = [theRow objectForKey:@"value"];
if (theEncodedFlag == YES)
	{
	theValue = [NSKeyedUnarchiver unarchiveObjectWithData:theValue];
	}

[theValue retain];

[thePool release];

[theValue autorelease];

return(theValue);
}

#pragma mark -

- (void)applicationWillTerminateNotification:(NSNotification *)inNotification
{
[self.database close];
self.database = NULL;
}

@end
