//
//  CSwitchTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/1/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CSwitchTableViewCell.h"

@interface CSwitchTableViewCell ()
@property (readwrite, nonatomic, retain) UILabel *label;
@property (readwrite, nonatomic, retain) UIView *valueView;
@end;

@implementation CSwitchTableViewCell

@synthesize label = outletLabel;
@synthesize valueView = outletValueView;
@dynamic valueSwitch;

+ (CSwitchTableViewCell *)cell
{
// TODO -- this is really silly.
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"CSwitchTableViewCell" owner:self options:NULL];
for (id theObject in theObjects)
	if ([theObject isKindOfClass:self])
		return(theObject);
NSAssert(NO, @"Could not find object of class CSwitchTableViewCell in nib");
return(NULL);
}

- (void)dealloc
{
self.label = NULL;
self.valueView = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)text
{
return(self.label.text);
}

- (void)setText:(NSString *)inText
{
self.label.text = inText;
}

- (UISwitch *)valueSwitch
{
return((UISwitch *)self.valueView);
}

@end
