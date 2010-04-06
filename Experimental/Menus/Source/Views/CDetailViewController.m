    //
//  CDetailViewController.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CDetailViewController.h"

#import "CHostingView.h"

@implementation CDetailViewController

@synthesize navigationBar;
@synthesize hostingView;


- (void)dealloc {
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

- (UIViewController *)viewController
{
return(self.hostingView.viewController);
}

- (void)setViewController:(UIViewController *)inViewController
{
self.hostingView.viewController = inViewController;
}


@end
