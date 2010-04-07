//
//  NSURL_DataExtensions.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (NSURL_DataExtensions)

+ (NSURL *)dataURLWithData:(NSData *)inData mimeType:(NSString *)inMimeType charset:(NSString *)inCharset;

@end
