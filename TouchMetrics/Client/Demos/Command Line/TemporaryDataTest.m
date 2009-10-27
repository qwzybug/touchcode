//
//  TemporaryDataTest.m
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "TemporaryDataTest.h"

#import "CTemporaryData.h"

@implementation TemporaryDataTest

- (void)testFoo
{
CTemporaryData *theData = [[[CTemporaryData alloc] initWithDataLimit:0] autorelease];

NSError *theError = NULL;
[theData writeData:[@"Hello" dataUsingEncoding:NSASCIIStringEncoding] error:&theError];
[theData writeData:[@"World" dataUsingEncoding:NSASCIIStringEncoding] error:&theError];

NSString *theResult = [[[NSString alloc] initWithData:theData.data encoding:NSASCIIStringEncoding] autorelease];
STAssertEqualObjects(theResult, @"HelloWorld", @"FOO");
}

@end
