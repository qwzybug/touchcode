//
//  TouchBookViewController.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBookContainer;
@class CBook;
@class CSection;

@interface CTouchBookPageViewController : UIViewController {
	UIWebView *webView;

	NSURL *URL;
	CBookContainer *bookContainer;
	CBook *currentBook;
	CSection *currentSection;
}

@property (readwrite, nonatomic, retain) NSURL *URL;
@property (readwrite, nonatomic, retain) IBOutlet UIWebView *webView;
@property (readwrite, nonatomic, retain) CBookContainer *bookContainer;
@property (readwrite, nonatomic, retain) CBook *currentBook;
@property (readwrite, nonatomic, retain) CSection *currentSection;

- (IBAction)nextSection:(id)inSender;

@end

