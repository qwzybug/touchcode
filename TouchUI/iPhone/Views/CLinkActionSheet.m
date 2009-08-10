//
//  CLinkActionSheet.m
//  TouchCode
//
//  Created by Jonathan Wight on 2/7/09.
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

#import "CLinkActionSheet.h"

@implementation CLinkActionSheet

@synthesize URL;

- (id)initWithLink:(NSURL *)inURL
{
return([self initWithLink:inURL defaultApplicationName:NULL]);
}

- (id)initWithLink:(NSURL *)inURL defaultApplicationName:(NSString *)inDefaultApplicationName
{
NSString *theButtonTitle = NULL;

if (inDefaultApplicationName == NULL)
	{
	if ([inURL.scheme isEqualToString:@"http"] || [inURL.scheme isEqualToString:@"http"])
		{
		inDefaultApplicationName = @"Safari";
		}
	else if ([inURL.scheme isEqualToString:@"mailto"])
		{
		inDefaultApplicationName = @"Mail";
		}
	}

if (inDefaultApplicationName != NULL)
	theButtonTitle = [NSString stringWithFormat:@"Open in %@", inDefaultApplicationName];
else
	theButtonTitle = @"Open external link.";

if ((self = [super initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:theButtonTitle, NULL]) != NULL)
	{
	self.URL = inURL;
	}
return(self);
}

- (void)dealloc
{
self.URL = NULL;
//
[super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
if (buttonIndex == 0)
	{
	BOOL theResult = [[UIApplication sharedApplication] openURL:self.URL];
	if (theResult == NO)
		{
		#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR == 1
		if ([self.URL.scheme isEqualToString:@"mailto"])
			{
			UIAlertView *theAlertView = [[[UIAlertView alloc] initWithTitle:@"OOPS" message:@"The simulator doesn't support mailto: URLs. But thanks for trying." delegate:NULL cancelButtonTitle:@"Darn" otherButtonTitles:NULL] autorelease];
			[theAlertView show];
			}
		#else
			NSString *theMessage = [NSString stringWithFormat:@"Could not open URL with '%@' scheme.", self.URL.scheme];
			UIAlertView *theAlertView = [[[UIAlertView alloc] initWithTitle:NULL message:theMessage delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL] autorelease];
			[theAlertView show];
		#endif
		}
	}
}

@end
