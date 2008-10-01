//
//  CWebViewController.h
//  Nearby
//
//  Created by Jonathan Wight on 05/27/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	NSURL *homeURL;
	NSString *initialHTMLString;
	BOOL dontChangeTitle;
	
	NSURL *currentURL;

	IBOutlet UIWebView *webView;
	IBOutlet UIToolbar *outletToolbar;
	IBOutlet UIBarButtonItem *outletBackButton;
	IBOutlet UIBarButtonItem *outletForwardsButton;
}

@property (readwrite, nonatomic, retain) NSURL *homeURL;
@property (readwrite, nonatomic, retain) NSString *initialHTMLString;
@property (readwrite, nonatomic, assign) BOOL dontChangeTitle;
@property (readonly, nonatomic, retain) NSURL *currentURL;

@property (readonly, nonatomic, retain) UIWebView *webView;
@property (readonly, nonatomic, retain) UIToolbar *toolbar;
@property (readonly, nonatomic, retain) UIBarButtonItem *backButton;
@property (readonly, nonatomic, retain) UIBarButtonItem *forwardsButton;

+ (id)webViewController;

- (void)loadURL:(NSURL *)inURL;
- (void)loadHTMLString:(NSString *)inHTML baseURL:(NSURL *)inBaseURL;

- (IBAction)back:(id)inSender;
- (IBAction)forwards:(id)inSender;
- (IBAction)reload:(id)inSender;
- (IBAction)home:(id)inSender;
- (IBAction)action:(id)inSender;


@end
