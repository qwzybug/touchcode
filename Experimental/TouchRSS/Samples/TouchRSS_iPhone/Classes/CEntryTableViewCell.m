//
//  CEntryTableViewCell.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CEntryTableViewCell.h"

@implementation CEntryTableViewCell

@synthesize titleLabel = outletTitleLabel;
@synthesize timestampLabel = outletTimestampLabel;

+ (CEntryTableViewCell *)cell
{
// TODO -- this is really silly.
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"EntryTableViewCell" owner:self options:NULL];
for (id theObject in theObjects)
	if ([theObject isKindOfClass:self])
		return(theObject);
NSAssert(NO, @"Could not find object of class CEntryTableViewCell in nib");
return(NULL);
}

- (void)dealloc
{
self.titleLabel = NULL;
self.timestampLabel = NULL;
//
[super dealloc];
}

- (NSString *)text
{
return(self.titleLabel.text);
}

- (void)setText:(NSString *)inText
{
self.titleLabel.text = inText;
}

@end
