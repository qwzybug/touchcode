//
//  NSData_Base64Extensions.h
//
//  Created by Jonathan Wight on 5/10/06.
//  Copyright (c) 2006 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @category NSObject (NSData_Base64Extensions)
 */
@interface NSData (NSData_Base64Extensions)

+ (id)dataWithBase64EncodedString:(NSString *)inString;
- (NSString *)asBase64EncodedString;

@end
