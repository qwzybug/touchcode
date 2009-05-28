//
//  CTableSection.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
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

#import "CTableSection.h"

#import "CTableRow.h"

@implementation CTableSection

@synthesize tag;
@synthesize table;
@synthesize rows;
@synthesize headerTitle;
@synthesize footerTitle;
@synthesize headerView;
@synthesize footerView;

- (id)init;
{
if ((self = [super init]) != NULL)
	{
	self.rows = [NSMutableArray array];
	}
return(self);
}

- (id)initWithTag:(NSString *)inTag
{
if ((self = [self init]) != NULL)
	{
	self.tag = inTag;
	}
return(self);
}

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle
{
if ((self = [self initWithTag:inTag]) != NULL)
	{
	self.headerTitle = inTitle;
	}
return(self);
}

- (void)dealloc
{
self.table = NULL;
self.tag = NULL;
self.rows = NULL;
self.headerTitle = NULL;
self.footerTitle = NULL;
self.headerView = NULL;
self.footerView = NULL;
//
[super dealloc];
}

- (CTableRow *)addRow:(CTableRow *)inRow
{
inRow.section = self;
[self.rows addObject:inRow];
return(inRow);
}

- (void)removeRow:(CTableRow *)inRow
{
	[self.rows removeObject:inRow];
}

- (CTableRow *)addCell:(UITableViewCell *)inCell;
{
CTableRow *theRow = [[[CTableRow alloc] initWithTag:NULL cell:inCell] autorelease];
[self addRow:theRow];
return(theRow);
}

- (NSArray *)visibleRows
{
NSMutableArray *theVisibleRows = [NSMutableArray array];
for (CTableRow *theRow in self.rows)
	{
	if (theRow.hidden == NO)
		[theVisibleRows addObject:theRow];
	}
return(theVisibleRows);
}

@end
