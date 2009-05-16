//
//  CTidy.h
//  Obama 08
//
//  Created by Jonathan Wight on 9/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "tidy.h"
#include "buffio.h"

@interface CTidy : NSObject {
	TidyDoc tidyDocument;
	TidyBuffer errorBuffer;
}

- (BOOL)prepare:(NSError **)outError;
- (BOOL)finalize:(NSError **)outError;

- (NSData *)convertXMLToXML:(NSData *)inXML error:(NSError **)outError;

@end
