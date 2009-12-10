//
//  Geometry.h
//  TouchCode
//
//  Created by Jonathan Wight on 10/15/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
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

typedef enum {
   ImageScaling_Proportionally = 0,
   ImageScaling_ToFit,
   ImageScaling_None,
} EImageScaling;

typedef enum {
   ImageAlignment_Center = 0,
   ImageAlignment_Top,
   ImageAlignment_TopLeft,
   ImageAlignment_TopRight,
   ImageAlignment_Left,
   ImageAlignment_Bottom,
   ImageAlignment_BottomLeft,
   ImageAlignment_BottomRight,
   ImageAlignment_Right
} EImageAlignment;

extern CGRect ScaleAndAlignRectToRect(CGRect inImageRect, CGRect inDestinationRect, EImageScaling inScaling, EImageAlignment inAlignment);

static inline Float64 RadiansToDegrees(Float64 inValue)
{
return(inValue * (180.0 / M_PI));
}

static inline Float64 DegreesToRadians(Float64 inValue)
{
return(inValue * (M_PI / 180.0));
}

static inline Float64 SemicirclesToDegrees(Float64 inValue)
{
return(inValue * (180.0 / pow(2.0, 31.0)));
}

static inline Float64 DegreesToSemicircles(Float64 inValue)
{
return(inValue * (pow(2.0, 31.0) / 180.0));
}

static inline Float64 SemicirclesToRadians(Float64 inValue)
{
return(DegreesToRadians(SemicirclesToDegrees(inValue)));
}

static inline Float64 RadiansToSemicircles(Float64 inValue)
{
return(DegreesToSemicircles(RadiansToDegrees(inValue)));
}

static inline Float64 FeetToMeters(Float64 inValue)
{
return(inValue * 12.0 * 2.54 / 100.0);
}

static inline Float64 MetersToFeet(Float64 inValue)
{
return(inValue * 100.0 / 2.54 / 12.0);
}

static inline CGPoint Rotation(CGPoint inCenter, CGFloat inAngle, CGFloat inLength)
{
CGFloat theCosine = cos(DegreesToRadians(fmod(90.0 - inAngle, 360.0)));
CGFloat theSine = sin(DegreesToRadians(fmod(90.0 - inAngle, 360.0)));
CGPoint thePoint = {
	.x = inCenter.x + theCosine * inLength,
	.y = inCenter.y + theSine * inLength,
	};
return(thePoint);
}

static inline CGRect CGRectFromPoints(CGPoint P1, CGPoint P2)
{
CGRect theRect = { .origin = P1, .size = { .width = fabs(P2.x - P1.x), .height = fabs(P2.y - P1.y) } };

theRect.origin.x = MIN(P1.x, P2.x);
theRect.origin.y = MIN(P1.y, P2.y);

return(theRect);
}

static inline CGRect CGRectFromOriginAndSize(CGPoint inOrigin, CGSize inSize)
{
CGRect theRect = { .origin = inOrigin, .size = inSize };
return(theRect);
}

static inline int quadrant(CGFloat x, CGFloat y)
{
if (x >= 0)
	{
	if (y >= 0)
		return 0;
	if (y < 0)
		return 1;
	}
if (x < 0 && y < 0)
	return 2;
else
	return 3;
}

static inline CGFloat angle(CGFloat x, CGFloat y)
{
const int q = quadrant(x, y);
if (q == 0)
	{
	if (y == 0)
		return 90.0;
	return RadiansToDegrees(atan(x / y));
	}
else if (q == 1)
	return 180.0 + RadiansToDegrees(atan(x / y));
else if (q == 2)
	return 180.0 + RadiansToDegrees(atan(x / y));
else
	{
	if (x == 0.0)
		return 0.0;
	return 360.0 + RadiansToDegrees(atan(x / y));
	}
}

static inline CGPoint CGPointClampToRect(CGPoint p, CGRect r)
{
// TODO replace with MIN and MAX
if (p.x < CGRectGetMinX(r))
	{
	p.x = CGRectGetMinX(r);
	}
else if (p.x > CGRectGetMaxX(r))
	{
	p.x = CGRectGetMaxX(r);
	}

if (p.y < CGRectGetMinY(r))
	{
	p.y = CGRectGetMinY(r);
	}
else if (p.y > CGRectGetMaxY(r))
	{
	p.y = CGRectGetMaxY(r);
	}
return(p);
}

static inline CGPoint CGPointSubtract(CGPoint p1, CGPoint p2)
{
return(CGPointMake(p1.x - p2.x, p1.y - p2.y));
}

static inline CGRect CGRectUnionOfRectsInArray(NSArray *inArray)
{
CGRect theUnionRect = CGRectZero;
for (NSValue *theValue in inArray)
	{
	CGRect theRect = [theValue CGRectValue];
	theUnionRect = CGRectUnion(theRect, theUnionRect);
	}
return(theUnionRect);
}

static inline CGFloat distance(CGPoint start, CGPoint finish)
{
const CGFloat theDistance = sqrtf(powf(fabsf(start.x - finish.x), 2.0) + powf(fabsf(start.y - finish.y), 2.0));
return(theDistance);
}

static inline CGFloat magnitude(CGPoint point)
{
const CGFloat theMagnitude = sqrtf(fabsf(point.x * point.x) + fabsf(point.y * point.y));
return(theMagnitude);
}

#pragma mark -

struct CIntegerPoint {
	NSInteger x;
	NSInteger y;
};
typedef struct CIntegerPoint CIntegerPoint;

struct CIntegerSize {
	NSInteger width;
	NSInteger height;
};
typedef struct CIntegerSize CIntegerSize;

struct CIntegerRect {
	CIntegerPoint origin;
	CIntegerSize size;
};
typedef struct CIntegerRect CIntegerRect;

static inline CIntegerPoint CIntegerPointMake(NSInteger x, NSInteger y)
{
const CIntegerPoint thePoint = { .x = x, .y = y };
return(thePoint);
}

extern NSString *NSStringFromCIntegerPoint(CIntegerPoint inPoint);
extern CIntegerPoint CIntegerPointFromString(NSString *inString);


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
extern NSString *NSStringFromCGAffineTransform(CGAffineTransform t);
#endif /* defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE */
