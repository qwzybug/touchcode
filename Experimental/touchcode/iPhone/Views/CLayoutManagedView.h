//
//  CLayoutManagedView.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLayoutManagedView : UIView {
}

- (void)adjustLayout;

@end

#pragma mark -

@interface CLayoutManagedView (Convenience_Extensions)
- (void)addLabelsWithTitles:(NSArray *)inTitles properties:(NSDictionary *)inProperties;
- (void)setHighlighted:(BOOL)inHighlighted;
@end