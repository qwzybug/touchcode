//
//  main.m
//  TouchCode
//
//  Created by  on 20090528.
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

#import "CPointerArray.h"

int main(int argc, void **argv)
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//

CPointerArray *theArray = [[[CPointerArray alloc] init] autorelease];

NSLog(@"%@", theArray);

[theArray addPointer:@"1"];
[theArray addPointer:@"2"];
[theArray addPointer:@"3"];
[theArray addPointer:@"4"];
[theArray addPointer:@"5"];
[theArray addPointer:@"6"];
[theArray addPointer:@"7"];
[theArray addPointer:@"8"];
[theArray addPointer:@"9"];
[theArray addPointer:@"10"];
[theArray addPointer:@"11"];
[theArray addPointer:@"12"];
[theArray addPointer:@"13"];
[theArray addPointer:@"14"];
[theArray addPointer:@"15"];
[theArray addPointer:@"16"];
[theArray addPointer:@"17"];
[theArray addPointer:@"18"];
[theArray addPointer:@"19"];
[theArray addPointer:@"20"];

for (id theObject in theArray)
	NSLog(@"Object: %@", [theObject description]);


//
[thePool release];
return(0);
}