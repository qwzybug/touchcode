//
//  CTextViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/2/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTextViewCell.h"

@implementation CTextViewCell

@synthesize textView = outletTextView;

+ (CTextViewCell *)cell
{
// TODO -- this is really silly.
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"CTextViewCell" owner:self options:NULL];
for (id theObject in theObjects)
	if ([theObject isKindOfClass:self])
		return(theObject);
NSAssert(NO, @"Could not find object of class CTextViewCell in nib");
return(NULL);
}

@end
