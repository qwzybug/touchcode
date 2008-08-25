//
//  CCompletionTicket.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CCompletionTicket.h"

@interface CCompletionTicket ()
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, nonatomic, retain) NSPointerArray *delegatePointers;
@property (readwrite, nonatomic, retain) id userInfo;
@end

@implementation CCompletionTicket

@synthesize identifier;
@dynamic delegates;
@synthesize delegatePointers;
@synthesize userInfo;

- (id)initWithIdentifier:(NSString *)inIdentifier delegates:(NSArray *)inDelegates userInfo:(id)inUserInfo
{
if ((self = [super init]) != NULL)
	{
	self.identifier = inIdentifier;
	self.delegatePointers = [[[NSPointerArray alloc] initWithOptions:NSPointerFunctionsZeroingWeakMemory | NSPointerFunctionsObjectPersonality] autorelease];
	for (id theDelegate in inDelegates)
		{
		NSAssert([theDelegate conformsToProtocol:@protocol(CCompletionTicketDelegate)], @"TODO");
		[self.delegatePointers addPointer:theDelegate];
		}
	self.userInfo = inUserInfo;
	}
return(self);
}

- (id)initWithIdentifier:(NSString *)inIdentifier delegate:(id <CCompletionTicketDelegate>)inDelegate userInfo:(id)inUserInfo;
{
if ((self = [self initWithIdentifier:inIdentifier delegates:[NSArray arrayWithObject:inDelegate] userInfo:inUserInfo]) != NULL)
	{
	
	}
return(self);
}

- (void)dealloc
{
self.identifier = NULL;
self.delegatePointers = NULL;
self.userInfo = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSArray *)delegates
{
NSMutableArray *theArray = [NSMutableArray arrayWithCapacity:self.delegatePointers.count];
for (id <CCompletionTicketDelegate> theDelegate in self.delegatePointers)
	{
	[theArray addObject:theDelegate];
	}
return(theArray);
}

#pragma mark -

- (void)addDelegate:(id <CCompletionTicketDelegate>)inDelegate;
{
[self.delegatePointers addPointer:inDelegate];
}

- (void)didCompleteForTarget:(id)inTarget result:(id)inResult
{
for (id <CCompletionTicketDelegate> theDelegate in self.delegatePointers)
	{
	if ([theDelegate respondsToSelector:@selector(completionTicket:didCompleteForTarget:result:)])
		[theDelegate completionTicket:self didCompleteForTarget:inTarget result:inResult];
	}
}

- (void)didFailForTarget:(id)inTarget error:(NSError *)inError
{
for (id <CCompletionTicketDelegate> theDelegate in self.delegatePointers)
	{
	if ([theDelegate respondsToSelector:@selector(completionTicket:didFailForTarget:error:)])
		[theDelegate completionTicket:self didFailForTarget:inTarget error:inError];
	}
}

- (void)didCancelForTarget:(id)inTarget
{
for (id <CCompletionTicketDelegate> theDelegate in self.delegatePointers)
	{
	if ([theDelegate respondsToSelector:@selector(completionTicket:didCancelForTarget:)])
		[theDelegate completionTicket:self didCancelForTarget:inTarget];
	}
}

@end
