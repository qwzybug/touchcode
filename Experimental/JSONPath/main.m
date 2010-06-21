//
//  main.m
//  TouchCode
//
//  Created by Jonathan Wight on 20100422.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

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