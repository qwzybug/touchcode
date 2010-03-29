#import <Foundation/Foundation.h>

#import "CJSONDeserializer.h"
#import "CJSONPath.h"

int main(int argc, char **argv)
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"file://localhost/Users/schwa/Development/Source/Mercurial/public/touchcode/Experimental/JSONPath/sample.json"]];

NSError *theError = NULL;
NSDictionary *theDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:&theError];


CJSONPath *thePath = [[[CJSONPath alloc] initWithString:@"$.store.book[*].author"] autorelease];
[thePath compile:&theError];


//
[thePool release];
//
return(0);
}