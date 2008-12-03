//
//  CWebViewController.m
//  Nearby
//
//  Created by Jonathan Wight on 05/27/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CWebViewController.h"

//#import "CLinkHandler.h"

@interface CWebViewController ()
@property (readwrite, nonatomic, retain) NSURL *currentURL;

@property (readwrite, nonatomic, retain) UIWebView *webView;
@property (readwrite, nonatomic, retain) UIToolbar *toolbar;
@property (readwrite, nonatomic, retain) UIBarButtonItem *backButton;
@property (readwrite, nonatomic, retain) UIBarButtonItem *forwardsButton;
@end

#pragma mark -

@implementation CWebViewController

@synthesize homeURL;
@synthesize initialHTMLString;
@synthesize dontChangeTitle;
@synthesize currentURL;
@synthesize webView;
@synthesize toolbar = outletToolbar;
@synthesize backButton = outletBackButton, forwardsButton = outletForwardsButton;

+ (id)webViewController;
{
CWebViewController *theWebViewController = [[[self alloc] initWithNibName:NULL bundle:NULL] autorelease];
return(theWebViewController);
}

- (void)dealloc
{
self.webView.delegate = NULL;

self.homeURL = NULL;
self.initialHTMLString = NULL;
self.currentURL = NULL;
//
self.webView = NULL;
self.toolbar = NULL;
self.backButton = NULL;
self.forwardsButton = NULL;

//
[super dealloc];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
[super viewDidLoad];

self.webView.scalesPageToFit = YES;
self.webView.detectsPhoneNumbers = NO;

if (self.initialHTMLString)
	[self loadHTMLString:self.initialHTMLString baseURL:self.homeURL];
else if (self.homeURL)
	[self loadURL:self.homeURL];

self.backButton.enabled = self.webView.canGoBack;
self.forwardsButton.enabled = self.webView.canGoForward;
}

- (void)loadURL:(NSURL *)inURL;
{
NSURLRequest *theRequest = [NSURLRequest requestWithURL:inURL];
[self.webView loadRequest:theRequest];
}

- (void)loadHTMLString:(NSString *)inHTML baseURL:(NSURL *)inBaseURL;
{
self.initialHTMLString = inHTML;
self.homeURL = inBaseURL;
[self.webView loadHTMLString:inHTML baseURL:inBaseURL];
}

#pragma mark -

- (void)updateToolbar
{
self.backButton.enabled = self.webView.canGoBack;
self.forwardsButton.enabled = self.webView.canGoForward;
}

#pragma mark -

- (IBAction)actionBack:(id)inSender
{
[self.webView goBack];
}

- (IBAction)actionForwards:(id)inSender
{
[self.webView goForward];
}

- (IBAction)actionReload:(id)inSender
{
[self.webView reload];
}

- (IBAction)actionHome:(id)inSender
{
if (self.initialHTMLString)
	[self loadHTMLString:self.initialHTMLString baseURL:self.homeURL];
else if (self.homeURL)
	[self loadURL:self.homeURL];
}

- (IBAction)actionUtilityPopup:(id)inSender
{
UIActionSheet *theActionSheet = [[[UIActionSheet  alloc] initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Open in Safari", @"E-mail Link", NULL] autorelease];
[theActionSheet showFromToolbar:self.toolbar];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
/*
NSURL *theURL = [request URL];
if ([[CLinkHandler instance] shouldHandleURL:theURL] == YES)
	{
	[[CLinkHandler instance] openURL:theURL];
	return(NO);
	}
*/
return(YES);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
if (!self.dontChangeTitle)
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];

self.currentURL = [[NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]] standardizedURL];

[self updateToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
if (buttonIndex == 0)
	{
	[[UIApplication sharedApplication] openURL:self.currentURL];
	}
else if (buttonIndex == 1)
	{
//	NSString *theTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//	NSURL *theLink = [[CLinkHandler instance] makeMailLink:[self.currentURL description] title:theTitle templateName:@"share_page_mail.txt"];
//	[[UIApplication sharedApplication] openURL:theLink];
	}
}

@end
