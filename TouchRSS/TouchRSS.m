#import <Foundation/Foundation.h>

#import "CRSSFeedDeserializer.h"
#import "CRSSObject.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CRSSFeedDeserializer *theDeserializer = [[[CRSSFeedDeserializer alloc] init] autorelease];

for (CRSSObject *theObject in theDeserializer)
	{
	NSLog(@"%@", theObject);
	}

[pool drain];
return 0;
}



