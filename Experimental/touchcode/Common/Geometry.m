//
//  Geometry.m
//  SimpleSequenceGrabber
//
//  Created by Jonathan Wight on 10/15/2005.
//  Copyright 2005 Toxic Software. All rights reserved.
//

#import "Geometry.h"

CGRect ScaleAndAlignRectToRect(CGRect inImageRect, CGRect inDestinationRect, EImageScaling inScaling, EImageAlignment inAlignment)
{
CGRect theScaledImageRect;

if (inScaling == ImageScaling_ToFit)
	{
	theScaledImageRect.origin = inDestinationRect.origin;
	theScaledImageRect.size = inDestinationRect.size;
	}
else
	{
	CGSize theScaledImageSize = inImageRect.size;

	if (inScaling == ImageScaling_Proportionally)
		{
		float theScaleFactor = 1.0f;
		if (inDestinationRect.size.width / inImageRect.size.width < inDestinationRect.size.height / inImageRect.size.height)
			{
			theScaleFactor = inDestinationRect.size.width / inImageRect.size.width;
			}
		else
			{
			theScaleFactor = inDestinationRect.size.height / inImageRect.size.height;
			}
		theScaledImageSize.width *= theScaleFactor;
		theScaledImageSize.height *= theScaleFactor;
		
		theScaledImageRect.size = theScaledImageSize;
		}
	else if (inScaling == ImageScaling_None)
		{
		theScaledImageRect.size.width = theScaledImageSize.width;
		theScaledImageRect.size.height = theScaledImageSize.height;
		}
	//
	if (inAlignment == ImageAlignment_Center)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Top)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_Left)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Bottom)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_Right)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	}
return(theScaledImageRect);
}

NSString *NSStringFromCIntegerPoint(CIntegerPoint inPoint)
{
return([NSString stringWithFormat:@"%d,%d", inPoint.x, inPoint.y]);
}

extern CIntegerPoint CIntegerPointFromString(NSString *inString)
{
NSScanner *theScanner = [NSScanner scannerWithString:inString];
CIntegerPoint thePoint;

BOOL theResult = [theScanner scanInteger:&thePoint.x];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanString:@"," intoString:NULL];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanInteger:&thePoint.y];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];

return(thePoint);
}


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
NSString *NSStringFromCGAffineTransform(CGAffineTransform t)
{
return([NSString stringWithFormat:@"%g, %g, %g, %g, %g, %g", t.a, t.b, t.c, t.d, t.tx, t.ty]);
}
#endif /* defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE */