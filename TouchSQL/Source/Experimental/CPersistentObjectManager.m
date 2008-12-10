//
//  CPersistentObjectManager.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CPersistentObjectManager.h"

#import "CPersistentObject.h"
#import "CSqliteDatabase_Extensions.h"
#import "CObjectTranscoder.h"

@interface CPersistentObjectManager ()
@property (readwrite, nonatomic, retain) CSqliteDatabase *database;
@property (readwrite, nonatomic, retain) NSMutableDictionary *cachedObjects;
@end

#pragma mark -

@implementation CPersistentObjectManager

@synthesize database;
@synthesize cachedObjects;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase
{
if ((self = [super init]) != NULL)
	{
	self.database = inDatabase;
	self.cachedObjects = [NSMutableDictionary dictionary];
	}
return(self);
}

- (void)dealloc
{
self.database = NULL;
//
[super dealloc];
}

#pragma mark -

- (id)makePersistentObjectOfClass:(Class)inClass error:(NSError **)outError
{
#pragma unused (outError)
id theObject = [[[inClass alloc] initWithPersistenObjectManager:self rowID:-1] autorelease];
return(theObject);
}

- (id)loadPersistentObjectOfClass:(Class)inClass rowID:(NSInteger)inRowID error:(NSError **)outError
{
#pragma unused (outError)

NSAssert(inClass != NULL, @"Class should not be NULL");
NSString *theTableName = [inClass tableName];
NSAssert(theTableName != NULL, @"tableName should not be NULL");

id theObject = NULL;

// Check the cache.
theObject = [self.cachedObjects objectForKey:[NSString stringWithFormat:@"%@/%d", [[inClass class] tableName], inRowID]];
if (theObject != NULL)
	return(theObject);

// READ id from database
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = %d LIMIT 1", theTableName, inRowID];
NSDictionary *theDictionary = [self.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	{
	return(NULL);
	}

// Create an object
theObject = [[[inClass alloc] initWithPersistenObjectManager:self rowID:inRowID] autorelease];

// Load object properties...
CObjectTranscoder *theTranscoder = [[theObject class] objectTranscoder];
NSDictionary *theUpdateDictonary = [theTranscoder dictionaryForObjectUpdate:theObject withPropertiesInDictionary:theDictionary error:&theError];
if (theUpdateDictonary == NULL)
	{
	[NSException raise:NSGenericException format:@"dictionaryForObjectUpdate failed: %@", theError];
	}

if ([[[theObject class] objectTranscoder] updateObject:theObject withPropertiesInDictionary:theUpdateDictonary error:&theError] == NO)
	{
	[NSException raise:NSGenericException format:@"Update Object failed: %@", theError];
	}


return(theObject);
}

- (id)loadPersistentObjectOfClass:(Class)inClass rowID:(NSInteger)inRowID fromDictionary:(NSDictionary *)inValues error:(NSError **)outError
{
#pragma unused (outError)

NSAssert(inClass != NULL, @"Class should not be NULL");
NSString *theTableName = [inClass tableName];
NSAssert(theTableName != NULL, @"tableName should not be NULL");

id theObject = NULL;

// Check the cache.
theObject = [self.cachedObjects objectForKey:[NSString stringWithFormat:@"%@/%d", [[inClass class] tableName], inRowID]];
if (theObject != NULL)
	return(theObject);

theObject = [[[inClass alloc] initWithPersistenObjectManager:self rowID:inRowID] autorelease];

// Load object properties...
CObjectTranscoder *theTranscoder = [[theObject class] objectTranscoder];
NSError *theError = NULL;
NSDictionary *theUpdateDictonary = [theTranscoder dictionaryForObjectUpdate:theObject withPropertiesInDictionary:inValues error:&theError];
if (theUpdateDictonary == NULL)
	{
	[NSException raise:NSGenericException format:@"dictionaryForObjectUpdate failed: %@", theError];
	}

if ([[[theObject class] objectTranscoder] updateObject:theObject withPropertiesInDictionary:theUpdateDictonary error:&theError] == NO)
	{
	[NSException raise:NSGenericException format:@"Update Object failed: %@", theError];
	}

return(theObject);
}

- (NSArray *)objectsOfClass:(Class)inClass forExpression:(NSString *)inExpression error:(NSError **)outError
{
NSArray *theRows = [self.database rowsForExpression:inExpression error:outError];
if (theRows == NULL)
	return(NULL);
NSMutableArray *theObjects = [NSMutableArray arrayWithCapacity:theRows.count];
for (NSDictionary *theRow in theRows)
	{
	NSInteger theID = [[theRow objectForKey:@"id"] integerValue];
	id theObject = [self loadPersistentObjectOfClass:inClass rowID:theID error:outError];
	if (theObject == NULL)
		return(NULL);
	[theObjects addObject:theObject];
	}
return(theObjects);
}

#pragma mark -

- (void)cachePersistentObject:(CPersistentObject *)inPersistentObject
{
NSAssert(inPersistentObject.rowID != -1, @"Cannot cache an object with a rowID of -1");

NSString *theKey = inPersistentObject.persistentIdentifier;

NSAssert1([self.cachedObjects objectForKey:theKey] == NULL, @"Object with same persistentIdentifier (%@) is already in the cache. This is bad.", theKey);

#if defined(DEBUG_POCACHE)
NSLog(@"PO CACHE #: %d", self.cachedObjects.count);
#endif /* defined(DEBUG_POCACHE) */

[self.cachedObjects setObject:inPersistentObject forKey:theKey];
}

- (void)uncachePersistentObject:(CPersistentObject *)inPersistentObject;
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

NSString *theKey = inPersistentObject.persistentIdentifier;

if ([self.cachedObjects objectForKey:theKey] != NULL)
	[self.cachedObjects removeObjectForKey:theKey];

#if defined(DEBUG_POCACHE)
NSLog(@"PO UNCACHE #: %d", self.cachedObjects.count);
#endif /* defined(DEBUG_POCACHE) */
	
[thePool release];
}

@end
