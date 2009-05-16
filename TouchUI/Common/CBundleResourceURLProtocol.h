//
//  CBundleResourceURLProtocol.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBundleResourceURLProtocol : NSURLProtocol {
}

+ (NSString *)MIMETypeForPath:(NSString *)inPath;
+ (BOOL)isPathWhitelisted:(NSString *)inPath;

@end
