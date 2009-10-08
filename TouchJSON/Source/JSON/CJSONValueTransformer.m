//
//  CJSONValueTransformer.m
//  TouchCode
//
//  Created by Andrew Pouliot on 10/7/09.
//  Copyright 2009 Small Society. All rights reserved.
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


#import "CJSONValueTransformer.h"

#import "CJSONScanner.h"
#import "CJSONSerializer.h"

@implementation CJSONValueTransformer

+ (void)load {
	NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	[NSValueTransformer setValueTransformer:[[[self alloc] init] autorelease] forName:NSStringFromClass([self class])];
	[thePool release];
}

+ (Class)transformedValueClass {
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)inValue {
	CJSONSerializer *serializer = [CJSONSerializer new];
	id object = [serializer serializeObject:inValue];
	[serializer release];
	return object;
}

- (id)reverseTransformedValue:(id)value {
	if ([value isKindOfClass:[NSString class]]) {
		value = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
	}
	if ([value isKindOfClass:[NSData class]]) {
		CJSONScanner *scanner = [CJSONScanner scannerWithData:(NSData *)value];
		id outObject = nil;
		[scanner scanJSONObject:&outObject error:nil];
		return outObject;
	}
	return nil;
}

@end
