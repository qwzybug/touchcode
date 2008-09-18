//
//  CPersistentObject.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CPersistentObject.h"

#import "CObjectTranscoder.h"
#import "CPersistentObjectManager.h"
#import "CSqliteDatabase.h"

@interface CPersistentObject ()
@property (readwrite, nonatomic, assign) CPersistentObjectManager *persistentObjectManager;
@end

#pragma mark -

@implementation CPersistentObject

@synthesize persistentObjectManager;
@dynamic persistentIdentifier;
@synthesize rowID;

+ (CObjectTranscoder *)objectTranscoder
{
return([[[CObjectTranscoder alloc] initWithTargetObjectClass:[self class]] autorelease]);
}

+ (NSString *)tableName
{
NSAssert(NO, @"Implement tableName in subclass");
return(NULL);
}

+ (NSArray *)columns;
{
NSAssert(NO, @"Implement columns in subclass");
return(NULL);
}

- (id)initWithPersistenObjectManager:(CPersistentObjectManager *)inManager rowID:(NSInteger)inRowID
{
if ((self = [super init]) != NULL)
	{
	self.persistentObjectManager = inManager;
	rowID = -1;
	}
return(self);
}

- (void)dealloc
{
self.persistentObjectManager = NULL;
//
[super dealloc];
}

- (void)release
{
if ([self retainCount] == 2) // 2 == one in cache, one about to be released.
	{
	[self.persistentObjectManager uncachePersistentObject:self];
	}
//
[super release];
}

#pragma mark -

- (NSString *)persistentIdentifier
{
if (self.rowID == -1)
	return(NULL);
else
	return([NSString stringWithFormat:@"%@/%d", [[self class] tableName], self.rowID]);
}

- (NSInteger)rowID
{
return(rowID);
}

- (void)setRowID:(NSInteger)inRowID
{
if (rowID != inRowID)
	{
	NSAssert(rowID == -1, @"Should not change the rowID of an object that already has a valid rowID (I think)");
	rowID = inRowID;
	[self.persistentObjectManager cachePersistentObject:self];
	}
}

#pragma mark -

//- (BOOL)write:(NSError **)outError
//{
//CSqliteDatabase *theDatabase = self.persistentObjectManager.database;
//
//[theDatabase begin];
//
//if (self.rowID == -1)
//	{
//	NSString *theExpression = NULL;
//	BOOL theResult = NO;
//
//	theExpression = [NSString stringWithFormat:@"INSERT INTO entry (%@) VALUES (%@)", self.feed.rowID, [self.identifier encodedForSql], [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.subtitle encodedForSql], [self.content encodedForSql], [self.updated sqlDateString]];
////	BOOL theResult = [theDatabase executeExpression:theExpression error:outError];
////	if (theResult == NO)
////		{
////		return(NO);
////		}
//
//	self.rowID = [theDatabase lastInsertRowID];
//	}
//else
//	{
//	// TODO -- This should be an update operation.
//	}
//	
//[theDatabase commit];
//
//return(YES);
//}


@end
