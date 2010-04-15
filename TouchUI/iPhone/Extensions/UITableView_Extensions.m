//
//  UITableView_Extensions.m
//  Small Society
//
//  Created by Jonathan Wight on 7/15/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "UITableView_Extensions.h"

@implementation UITableView (UITableView_Extensions)

- (void)setTableHeaderLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

if (self.style == UITableViewStyleGrouped)
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)] autorelease];
	theLabel.lineBreakMode = UILineBreakModeWordWrap;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
	theLabel.frame = CGRectMake(20, 10, 280, theSize.height);

	UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))] autorelease];
	//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
else
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)] autorelease];
	theLabel.lineBreakMode = UILineBreakModeWordWrap;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
	theLabel.frame = CGRectMake(20, 10, 280, theSize.height);

	UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame) + 10)] autorelease];
	//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
}

- (void)setTableFooterLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)] autorelease];
theLabel.lineBreakMode = UILineBreakModeWordWrap;
theLabel.numberOfLines = 0;
theLabel.text = inText;
theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
theLabel.opaque = NO;
theLabel.backgroundColor = [UIColor clearColor];
//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
theLabel.frame = CGRectMake(20, 0, 280, theSize.height);

UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))] autorelease];
//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
[theView addSubview:theLabel];

self.tableFooterView = theView;
}

@end
