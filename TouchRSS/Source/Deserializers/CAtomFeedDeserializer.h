//
//  CAtomFeedDeserializer.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CFeedDeserializer.h"

#include <libxml/xmlreader.h>

@interface CAtomFeedDeserializer : NSObject <CFeedDeserializer> {
	xmlTextReaderPtr reader;
	NSError *error;
}

@end
