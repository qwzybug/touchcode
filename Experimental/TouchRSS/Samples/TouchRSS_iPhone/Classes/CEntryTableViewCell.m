//
//  CEntryTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CEntryTableViewCell.h"

@implementation CEntryTableViewCell

@synthesize titleLabel = outletTitleLabel;
@synthesize timestampLabel = outletTimestampLabel;

+ (CEntryTableViewCell *)cell
{
// TODO -- this is really silly.
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"CEntryTableViewCell" owner:self options:NULL];
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
