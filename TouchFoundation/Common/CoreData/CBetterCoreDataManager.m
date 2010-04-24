//
//  CBetterCoreDataManager.m
//  touchcode
//
//  Created by Jonathan Wight on 11/10/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CBetterCoreDataManager.h"

//#import "NSError_Extensions.h"

@interface CBetterCoreDataManager()
- (void)managedObjectContextDidSaveNotification:(NSNotification *)inNotification;
@end

@implementation CBetterCoreDataManager

@synthesize defaultMergePolicy;

- (NSManagedObjectContext *)newManagedObjectContext
{
NSManagedObjectContext *theManagedObjectContext = [super newManagedObjectContext];
if (self.defaultMergePolicy != NULL)
	theManagedObjectContext.mergePolicy = self.defaultMergePolicy;

if ([NSThread isMainThread] == NO)
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:theManagedObjectContext];

return(theManagedObjectContext);
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)inNotification
{
if ([NSThread mainThread] != [NSThread currentThread])
	{
	[self performSelectorOnMainThread:@selector(managedObjectContextDidSaveNotification:) withObject:inNotification waitUntilDone:YES];
	return;
	}

@try
	{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
	[self save];
	}
@catch (NSException * e)
	{
	NSLog(@"EXCEPTION RAISED");
//	NSLog(@"%@", self);
//	NSLog(@"%@", self.managedObjectContext);
//	NSLog(@"%@", self.persistentStoreCoordinator);
//	NSLog(@"%@", [self.persistentStoreCoordinator persistentStores]);
//	NSLog(@"%@", e);
//	NSLog(@"%@", inNotification);
//	[self presentError:[NSError errorWithException:e]];
	}
}


@end
