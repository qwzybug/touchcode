//
//  CTouchAnalyticsManager.m
//  Uploadr
//
//  Created by Jonathan Wight on 10/23/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CTouchAnalyticsManager.h"

#import "CCoreDataManager.h"
#import "CJSONDataSerializer.h"
#import "NSData_Extensions.h"
#import "NSData_HMACExtensions.h"
#import "CURLOperation.h"
#import "NSOperationQueue_Extensions.h"
#import "CTemporaryData.h"
#import "CPersistentRequestManager.h"
#import "CTouchAnalyticsManager.h"
#import "NSManagedObjectContext_Extensions.h"
#import "CSerializedJSONData.h"

static CTouchAnalyticsManager *gInstance = NULL;

@implementation CTouchAnalyticsManager

@synthesize coreDataManager;
@synthesize operationQueue;
@synthesize requestManager;

+ (CTouchAnalyticsManager *)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	NSURL *theModelURL = [NSURL URLWithString:@"file://localhost/Volumes/Users/schwa/Development/Products/Debug/Analytics.mom"];
	coreDataManager = [[CCoreDataManager alloc] initWithModelUrl:theModelURL persistentStoreName:@"Message" forceReplace:NO storeType:NULL storeOptions:NULL];
	coreDataManager.delegate = self;
	
	operationQueue = [[NSOperationQueue currentQueue] retain];
	
	requestManager = [[CPersistentRequestManager alloc] init];
	}
return(self);
}

- (void)postMessage:(NSDictionary *)inMessage
{
NSInvocationOperation *theOperation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postMessage_:) object:inMessage] autorelease];
[self.operationQueue addOperation:theOperation];
}

- (void)postMessage_:(NSDictionary *)inMessage
{
NSData *theSerializedMessage = [[CJSONDataSerializer serializer] serializeDictionary:inMessage];

NSManagedObject *theObject = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.coreDataManager.managedObjectContext];
[theObject setValue:[NSDate date] forKey:@"created"];
[theObject setValue:theSerializedMessage forKey:@"message"];
[theObject setValue:[NSNumber numberWithInteger:theSerializedMessage.length] forKey:@"messageLength"];
[self.coreDataManager save];

[self processMessages];
}

- (void)processMessages
{
NSMutableArray *theMessagesArray = [NSMutableArray array];

NSError *theError = NULL;
//NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"inProgress == YES"];
NSArray *theMessages = [self.coreDataManager.managedObjectContext fetchObjectsOfEntityForName:@"Message" predicate:NULL error:&theError];
for (NSManagedObject *theMessage in theMessages)
	{
	CSerializedJSONData *theJSONData = [theMessage valueForKey:@"message"];
	[theMessagesArray addObject:theJSONData];

	[self.coreDataManager.managedObjectContext deleteObject:theMessage];
	}


NSDictionary *theMessage = [NSDictionary dictionaryWithObjectsAndKeys:
	@"HELLO WORLD", @"header",
	theMessagesArray, @"messages",
	NULL];
	
NSData *theContent = [[CJSONDataSerializer serializer] serializeObject:theMessage];

NSData *theKey = [@"sekret" dataUsingEncoding:NSUTF8StringEncoding];
NSURL *theURL = [NSURL URLWithString:@"http://localhost:8080/api/0/upload"];
NSString *theServiceIdentifier = @"test";
NSString *theContentType = @"text/plain";
NSData *theDigest = [theContent HMACDigestWithKey:theKey];
NSString *theHexDigest = [theDigest hexString];


//NSLog(@"%d", strlen(theDigest));

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
[theRequest setHTTPMethod:@"POST"];
[theRequest setValue:theContentType forHTTPHeaderField:@"Content-Type"];
[theRequest setValue:theHexDigest forHTTPHeaderField:@"x-hmac-body-hexdigest"];
[theRequest setValue:theServiceIdentifier forHTTPHeaderField:@"x-service-identifier"];

theRequest.HTTPBody = theContent;

NSLog(@"%@", self.requestManager);
[self.requestManager addRequest:theRequest];

[self.coreDataManager save];
}

#pragma mark -

- (void)coreDataManager:(CCoreDataManager *)inCoreDataManager didCreateNewManagedObjectContext:(NSManagedObjectContext *)inManagedObjectContext;
{
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:inManagedObjectContext];
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)notification
{
if ([NSThread mainThread] != [NSThread currentThread])
	{
	[self performSelectorOnMainThread:@selector(managedObjectContextDidSaveNotification:) withObject:notification waitUntilDone:YES];
	return;
	}

NSLog(@"DID SAVE NOTIFICATION");
[self.coreDataManager.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
[self.coreDataManager save];
}


@end
