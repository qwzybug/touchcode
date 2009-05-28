//
//  CEntryWebViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CEntryWebViewController.h"

#import "CBundleResourceURLProtocol.h"
#import "CFeedEntry.h"
#import "CTrivialTemplate.h"
#import "CFeedEntry.h"
//#import "CLinkHandler.h"

@implementation CEntryWebViewController

@synthesize entries;
@synthesize currentEntryIndex;
@synthesize template;
@synthesize nextPreviousEntrySegmentedControl = outletNextPreviousEntrySegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
self.template = NULL;
self.entries = NULL;
self.nextPreviousEntrySegmentedControl = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)viewDidLoad;
{
[super viewDidLoad];

if (self.navigationItem.title == NULL)
	self.navigationItem.title = @"News";

//    NSArray *theImages = [NSArray arrayWithObjects:
//        [UIImage imageNamed:@"up.png"],
//        [UIImage imageNamed:@"down.png"],
//        NULL];
//        
//    self.nextPreviousEntrySegmentedControl = [[UISegmentedControl alloc] initWithItems:theImages];
//    self.nextPreviousEntrySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    self.nextPreviousEntrySegmentedControl.tintColor = kTintColor;
//    self.nextPreviousEntrySegmentedControl.momentary = YES;
//    [self.nextPreviousEntrySegmentedControl addTarget:self action:@selector(actionNextPrevious:) forControlEvents:UIControlEventValueChanged];
//    CGRect segmentedFrame = self.nextPreviousEntrySegmentedControl.frame;
//    static const CGFloat kSubviewPadding = 8.0;
//    segmentedFrame.origin.x = CGRectGetWidth(headerView.bounds) - CGRectGetWidth(segmentedFrame) - kSubviewPadding;
//    segmentedFrame.origin.y = CGRectGetHeight(headerView.bounds) - CGRectGetHeight(segmentedFrame) - kSubviewPadding;
//    self.nextPreviousEntrySegmentedControl.frame = segmentedFrame;
//    [headerView addSubview:(headerView.segmentedControl = self.nextPreviousEntrySegmentedControl)];
//    [self.nextPreviousEntrySegmentedControl release];

[self updateUI];
}

- (void)loadHTMLForEntry:(CFeedEntry *)inEntry
{
[CBundleResourceURLProtocol load];

NSLog(@"loadHTMLForEntry: %@", inEntry);

NSDateFormatter *theDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theDateFormatter setGeneratesCalendarDates:NO];
[theDateFormatter setDateStyle:NSDateFormatterLongStyle];
[theDateFormatter setTimeStyle:NSDateFormatterLongStyle];

//NSString *theEncodedURLString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)inEntry.link.absoluteString, CFSTR(""), CFSTR(":/?&"), kCFStringEncodingUTF8) autorelease];

NSLog(@"Loading HTML for %@", inEntry.link);

NSMutableDictionary *theReplacementDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	inEntry, @"entry",
	inEntry.title, @"title",
	[theDateFormatter stringFromDate:inEntry.updated], @"updated",
	inEntry.content, @"content",
	inEntry.link, @"link",
//	[NSString stringWithFormat:@"%f", inEntry.latitude], @"latitude",
//	[NSString stringWithFormat:@"%f", inEntry.longitude], @"longitude",
	NULL];

NSError *theError = NULL;
// #############################################################################

//NSURL *theShareEventsLink = [[CLinkHandler instance] makeMailToLinkWithTemplateName:@"share_events_mail_body.txt" replacementDictionary:theReplacementDictionary];
//
//NSURL *theShareNewsLink = [[CLinkHandler instance] makeMailToLinkWithTemplateName:@"share_news_mail_body.txt" replacementDictionary:theReplacementDictionary];
//
//
//[theReplacementDictionary setObject:theShareEventsLink forKey:@"share_events_mail_link"];
//[theReplacementDictionary setObject:theShareNewsLink forKey:@"share_news_mail_link"];
//
NSString *theHTML = [self.template transform:theReplacementDictionary error:&theError];

[self loadHTMLString:theHTML baseURL:inEntry.link];
}

- (void)updateUI
{
NSLog(@"UpdateUI");

[outletNextPreviousEntrySegmentedControl setEnabled:self.currentEntryIndex > 0 forSegmentAtIndex:0];
[outletNextPreviousEntrySegmentedControl setEnabled:self.currentEntryIndex < self.entries.count - 1 forSegmentAtIndex:1];
//
CFeedEntry *theEntry = [self.entries objectAtIndex:self.currentEntryIndex];
[self loadHTMLForEntry:theEntry];
}

- (IBAction)actionNextPrevious:(id)inSender
{
NSInteger theDelta = ([outletNextPreviousEntrySegmentedControl selectedSegmentIndex] == 0) ? -1 : +1;
self.currentEntryIndex = MAX(MIN(self.currentEntryIndex + theDelta, self.entries.count - 1), 0);
//
[self updateUI];
}

@end
