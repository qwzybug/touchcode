//
//  CHTTPMessage_ConvenienceExtensions.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPMessage.h"

@interface CHTTPMessage (CHTTPMessage_ConvenienceExtensions)

+ (CHTTPMessage *)HTTPMessageResponseWithStatusCode:(NSInteger)inStatusCode bodyString:(NSString *)inBodyString;

@end
