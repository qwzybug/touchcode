#import <Foundation/Foundation.h>

#import "CRSSFeedDeserializer.h"
#import "CRSSObject.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

NSData *theData = [NSData dataWithContentsOfFile:@"/Users/schwa/Desktop/test.rss"];

CRSSFeedDeserializer *theDeserializer = [[[CRSSFeedDeserializer alloc] initWithData:theData] autorelease];

for (CRSSObject *theObject in theDeserializer)
	{
	NSLog(@"%@", theObject);
	}

[pool drain];
return 0;
}



