//
//  NSIndexPath_Extensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (NSIndexPath_Extensions)

+ (id)indexPathWithString:(NSString *)inString;
- (NSString *)stringValue;

@end
