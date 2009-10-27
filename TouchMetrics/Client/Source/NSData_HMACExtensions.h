//
//  NSData_HMACExtensions.h
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_HMACExtensions)

- (NSData *)HMACDigestWithKey:(NSData *)inKey;

@end
