//
//  CTidy.m
//  Obama 08
//
//  Created by Jonathan Wight on 9/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTidy.h"

@implementation CTidy

- (void)dealloc
{
[self finalize:NULL];
//
[super dealloc];
}

- (BOOL)prepare:(NSError **)outError
{
if (tidyDocument)
	{
	if ([self finalize:outError] == NO)
		return(NO);
	}

tidyDocument = tidyCreate();

BOOL theResult = NO;

theResult = tidyOptSetBool(tidyDocument, TidyXmlTags, YES);
if (theResult == NO)
	return(NO);

theResult = tidyOptSetBool(tidyDocument, TidyXmlOut, YES);
if (theResult == NO)
	return(NO);

int theResultCode = 0;

//theResultCode = tidySetOutCharEncoding(tidyDocument, "utf8");
//NSAssert(theResult >= 0, @"tidySetOutCharEncoding() should return 0");

tidyBufInit(&errorBuffer);
theResultCode = tidySetErrorBuffer(tidyDocument, &errorBuffer);
NSAssert(theResultCode >= 0, @"tidySetErrorBuffer() should return 0");

return(YES);
}

- (BOOL)finalize:(NSError **)outError
{
if (tidyDocument)
	{
	tidyBufFree(&errorBuffer);
	tidyRelease(tidyDocument);
	tidyDocument = NULL;
	}
return(YES);
}

- (NSData *)convertXMLToXML:(NSData *)inXML error:(NSError **)outError;
{
if ([self prepare:outError] == NO)
	return(NULL);

TidyBuffer theInputBuffer;

tidyBufAlloc(&theInputBuffer, [inXML length]);
memcpy(theInputBuffer.bp, [inXML bytes], [inXML length]);
theInputBuffer.size = [inXML length];

int theResultCode = tidyParseBuffer(tidyDocument, &theInputBuffer);
if (theResultCode < 0)
	{
	if (outError)
		{
		NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithUTF8String:(char *)errorBuffer.bp], NSLocalizedDescriptionKey,
			NULL];
		*outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:theResultCode userInfo:theUserInfo];
		}
	return(NO);
	}

theResultCode = tidyCleanAndRepair(tidyDocument);
if (theResultCode < 0)
	{
	return(NULL);
	}
//rc = tidyRunDiagnostics(tdoc);
theResultCode = tidyOptSetBool(tidyDocument, TidyForceOutput, YES);
NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");

TidyBuffer theOutputBuffer;
tidyBufInit(&theOutputBuffer);

theResultCode = tidySaveBuffer(tidyDocument, &theOutputBuffer);
if (theResultCode < 0)
	return(NULL);

NSAssert(theOutputBuffer.bp != NULL, @"The buffer should not be null.");
NSData *theOutputXML = [NSData dataWithBytes:theOutputBuffer.bp length:theOutputBuffer.size];

tidyBufFree(&theOutputBuffer);

tidyBufFree(&theInputBuffer);


if ([self finalize:outError] == NO)
	return(NULL);


return(theOutputXML);
}

@end
