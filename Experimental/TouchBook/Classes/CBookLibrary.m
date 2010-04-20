//
//  CBookLibrary.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CBookLibrary.h"

#import "CBookContainer.h"

@implementation CBookLibrary

@synthesize books;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	books = [[NSMutableArray alloc] init];

	NSString *thePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Books"];
	for (NSString *theSubpath in [[NSFileManager defaultManager] subpathsAtPath:thePath])
		{
		NSURL *theURL = [NSURL fileURLWithPath:[thePath stringByAppendingPathComponent:theSubpath]];
		NSString *thePath = [(id)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)theURL.path, NULL, NULL, kCFStringEncodingUTF8) autorelease];

		NSString *theURLString = [NSString stringWithFormat:@"x-zipfile://%@/", thePath];
		theURL = [NSURL URLWithString:theURLString];
		
		CBookContainer *theContainer = [[[CBookContainer alloc] initWithURL:theURL] autorelease];
		
		[self.books addObject:theContainer];
		}
	}
return(self);
}



@end
