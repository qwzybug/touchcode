//
//  CBetterOperation.m
//  TouchCode
//
//  Created by Jonathan Wight on 4/28/09.
//  Copyright 2009 Small Society. All rights reserved.
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

#import "CBetterOperation.h"

@implementation CBetterOperation

@synthesize userInfo;
@synthesize delegate;
@synthesize result;
@synthesize error;

- (void)dealloc
{
self.userInfo = NULL;
self.delegate = NULL;
self.result = NULL;
self.error = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)delegateProxyWithResult:(id)inResult
{
	[self.delegate operation:self didAttainResult:inResult];
}

- (void)delegateProxyWithError:(NSError*)inError
{
	[self.delegate operation:self didFailWithError:inError];	
}

- (void)attainResult:(id)inResult
{
	self.result = inResult;

	// you could do this check in delegateProxyWithResult, but probably avoid a context switch by doing it here.
	if (self.delegate && [self.delegate respondsToSelector:@selector(operation:didAttainResult:)])
	{
		[self performSelectorOnMainThread:@selector(delegateProxyWithResult:) withObject:inResult waitUntilDone:YES];
	}
}

- (void)failWithError:(NSError *)inError
{
	NSAssert(inError != NULL, @"inError should not be NULL");

	self.error = inError;

	if (self.delegate && [self.delegate respondsToSelector:@selector(operation:didFailWithError:)])
	{
		[self performSelectorOnMainThread:@selector(delegateProxyWithError:) withObject:inError waitUntilDone:YES];
	}
}

@end
