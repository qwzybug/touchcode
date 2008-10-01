#import <Foundation/Foundation.h>

#import "CGeoPoint.h"

static id TXPropertyList(NSString *inString)
{
NSData *theData = [inString dataUsingEncoding:NSUTF8StringEncoding];

NSPropertyListFormat theFormat;
NSString *theError = NULL;

id thePropertyList = [NSPropertyListSerialization propertyListFromData:theData mutabilityOption:NSPropertyListImmutable format:&theFormat errorDescription:&theError];
return(thePropertyList);
}

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

NSDictionary *theDictionary = TXPropertyList(@"{ coordinates = ( 0, 0 ); type = Point; foo = bar; }");

CGeoPoint *theGeoPoint = [CGeoPoint objectFromDictionary:theDictionary];
NSLog(@"%@", theGeoPoint);


NSLog(@"%@", [theGeoPoint asDictionary]);






[pool drain];
return 0;
}
