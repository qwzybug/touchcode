//
//  CTouchBookPageViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CTouchBookPageViewController.h"

#import "CBookContainer.h"
#import "CBook.h"
#import "CSection.h"
#import "CZipfile.h"

@implementation CTouchBookPageViewController

@synthesize URL;
@synthesize webView;
@synthesize bookContainer;
@synthesize currentBook;
@synthesize currentSection;

- (void)viewDidLoad
{
[super viewDidLoad];
//

//NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Dumas - The Count of Monte Cristo" ofType:@"epub"];
//NSString *thePath = [[NSBundle mainBundle] pathForResource:@"melville-moby-dick" ofType:@"epub"];
NSString *thePath = self.URL.path;

thePath = [(id)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)thePath, NULL, NULL, kCFStringEncodingUTF8) autorelease];

NSString *theString = [NSString stringWithFormat:@"x-zipfile://%@/", thePath];
NSURL *theURL = [NSURL URLWithString:theString];

bookContainer = [[CBookContainer alloc] initWithURL:theURL];
currentBook = [[self.bookContainer.books objectAtIndex:0] retain];
currentSection = [[self.currentBook.sections objectAtIndex:0] retain];

NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.currentSection.URL];
[self.webView loadRequest:theRequest];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)nextSection:(id)inSender
{
NSUInteger theSectionIndex = [self.currentBook.sections indexOfObject:self.currentSection];
self.currentSection = [self.currentBook.sections objectAtIndex:theSectionIndex + 1];
NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.currentSection.URL];
[self.webView loadRequest:theRequest];
}

@end
