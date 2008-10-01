//
//  NSScanner_HTMLExtensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSScanner (NSScanner_HTMLExtensions)

- (BOOL)scanHTMLEntityIntoString:(NSString **)outString;

@end
