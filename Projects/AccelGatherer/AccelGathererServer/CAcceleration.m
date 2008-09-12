//
//  CAcceleration.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 08/26/08
//  Copyright (c) 2008 Jonathan Wight
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

#import "CAcceleration.h"

#pragma mark begin emogenerator forward declarations
#pragma mark end emogenerator forward declarations

@implementation CAcceleration

#pragma mark begin emogenerator accessors

@dynamic y;

- (double)y
{
return([[self yValue] doubleValue]);
}

- (void)setY:(double)inY
{
[self setYValue:[NSNumber numberWithDouble:inY]];
}

@dynamic yValue;

- (NSNumber *)yValue
{
[self willAccessValueForKey:@"y"];
NSNumber *theResult = [self primitiveValueForKey:@"y"];
[self didAccessValueForKey:@"y"];
return(theResult);
}

- (void)setYValue:(NSNumber *)inY
{
[self willChangeValueForKey:@"y"];
[self setPrimitiveValue:inY forKey:@"y"];
[self didChangeValueForKey:@"y"];
}

@dynamic x;

- (double)x
{
return([[self xValue] doubleValue]);
}

- (void)setX:(double)inX
{
[self setXValue:[NSNumber numberWithDouble:inX]];
}

@dynamic xValue;

- (NSNumber *)xValue
{
[self willAccessValueForKey:@"x"];
NSNumber *theResult = [self primitiveValueForKey:@"x"];
[self didAccessValueForKey:@"x"];
return(theResult);
}

- (void)setXValue:(NSNumber *)inX
{
[self willChangeValueForKey:@"x"];
[self setPrimitiveValue:inX forKey:@"x"];
[self didChangeValueForKey:@"x"];
}

@dynamic timestamp;

- (NSDate *)timestamp
{
[self willAccessValueForKey:@"timestamp"];
NSDate *theResult = [self primitiveValueForKey:@"timestamp"];
[self didAccessValueForKey:@"timestamp"];
return(theResult);
}

- (void)setTimestamp:(NSDate *)inTimestamp
{
[self willChangeValueForKey:@"timestamp"];
[self setPrimitiveValue:inTimestamp forKey:@"timestamp"];
[self didChangeValueForKey:@"timestamp"];
}

@dynamic z;

- (double)z
{
return([[self zValue] doubleValue]);
}

- (void)setZ:(double)inZ
{
[self setZValue:[NSNumber numberWithDouble:inZ]];
}

@dynamic zValue;

- (NSNumber *)zValue
{
[self willAccessValueForKey:@"z"];
NSNumber *theResult = [self primitiveValueForKey:@"z"];
[self didAccessValueForKey:@"z"];
return(theResult);
}

- (void)setZValue:(NSNumber *)inZ
{
[self willChangeValueForKey:@"z"];
[self setPrimitiveValue:inZ forKey:@"z"];
[self didChangeValueForKey:@"z"];
}

#pragma mark emogenerator end accessors

@end
