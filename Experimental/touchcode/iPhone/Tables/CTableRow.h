//
//  CTableRow.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTableSection;

@interface CTableRow : NSObject {
	CTableSection *section; // Never retained
	NSString *tag;
	UITableViewCell *cell;
	BOOL hidden;
	BOOL selectable;
	SEL selectionAction;
	BOOL editable;
	CGFloat height;
	UITableViewCellEditingStyle editingStyle;
}

@property (readwrite, nonatomic, assign) CTableSection *section;
@property (readwrite, nonatomic, retain) NSString *tag;
@property (readwrite, nonatomic, retain) UITableViewCell *cell;
@property (readwrite, nonatomic, assign) BOOL hidden;
@property (readwrite, nonatomic, assign) BOOL selectable;
@property (readwrite, nonatomic, assign) SEL selectionAction;
@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, assign) CGFloat height;
@property (readwrite, nonatomic, assign) UITableViewCellEditingStyle editingStyle;

- (id)initWithTag:(NSString *)inTag;
- (id)initWithTag:(NSString *)inTag cell:(UITableViewCell *)inCell;

@end

#pragma mark -

@interface CTableRow (CTableRow_ConvenienceExtensions)

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle;
- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle value:(NSString *)inValue;
- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle value:(NSString *)inValue accessoryType:(UITableViewCellAccessoryType)inAccessoryType;

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle buttonImage:(UIImage *)inImage target:(id)inTarget action:(SEL)inAction;


@end
