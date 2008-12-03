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

- (id)initWithTable:(UITableView *)inTable
{
if ((self = [self init]) != NULL)
	{
	self.table = inTable;
	}
return(self);
}

- (void)dealloc
{
self.table = NULL;
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
