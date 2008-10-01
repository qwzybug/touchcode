//
//  UITableViewCell_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/08/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "UITableViewCell_Extensions.h"

@implementation UITableViewCell (UITableViewCell_Extensions)

- (id)copyWithZone:(NSZone *)inZone
{
UITableViewCell *theCopy = [[[self class] allocWithZone:inZone] initWithFrame:self.frame reuseIdentifier:self.reuseIdentifier];

theCopy.text = self.text;
theCopy.font = self.font;
theCopy.textAlignment = self.textAlignment;
theCopy.lineBreakMode = self.lineBreakMode;
theCopy.textColor = self.textColor;
theCopy.selectedTextColor = self.selectedTextColor;
theCopy.image = self.image;
theCopy.selectedImage = self.selectedImage;
//theCopy.backgroundView = self.backgroundView; // TODO copy
//theCopy.selectedBackgroundView = self.selectedBackgroundView; // TODO copy
theCopy.selectionStyle = self.selectionStyle;
theCopy.selected = self.selected;
theCopy.showsReorderControl = self.showsReorderControl;
theCopy.shouldIndentWhileEditing = self.shouldIndentWhileEditing;
theCopy.accessoryType = self.accessoryType;
//theCopy.accessoryView = self.accessoryView; // TODO copy
theCopy.hidesAccessoryWhenEditing = self.hidesAccessoryWhenEditing;
theCopy.indentationLevel = self.indentationLevel;
theCopy.indentationWidth = self.indentationWidth;
theCopy.editing = self.editing;
theCopy.target = self.target;
theCopy.editAction = self.editAction;
theCopy.accessoryAction = self.accessoryAction;

return(theCopy);

}

@end
