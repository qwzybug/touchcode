//
//  CTouchBookPageViewController.h
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

