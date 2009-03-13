//
//  CTableSection.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
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
