//
//  CSpinnerTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 08/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import "CSpinnerTableViewCell.h"

@implementation CSpinnerTableViewCell

@dynamic spinning;
@synthesize activityIndictor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != NULL)
	{
	self.activityIndictor = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	self.activityIndictor.hidesWhenStopped = YES;
	}
return(self);
}

- (void)dealloc
{
self.activityIndictor = NULL;
//
[super dealloc];
}

- (BOOL)spinning
{
return(self.activityIndictor.isAnimating);
}

- (void)setSpinning:(BOOL)inSpinning
{
if (inSpinning)
	{
	self.accessoryView = self.activityIndictor;
	[self.activityIndictor startAnimating];
	}
else
	{
	self.accessoryView = NULL;
	[self.activityIndictor stopAnimating];
	}
}


@end
