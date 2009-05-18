//
//  UIColor_Blending.m
//  ColorMixer
//
//  Created by Christopher Liscio on 1/14/09.
//  Copyright 2009 SuperMegaUltraGroovy. All rights reserved.
//

#import "UIColor_Blending.h"

static unsigned int RED = 0;
static unsigned int GREEN = 1;
static unsigned int BLUE = 2;

#define HSB_MIX 0

@interface UIColor()
- (double)componentWithIndex:(unsigned int)inIndex;
@end

@implementation UIColor (Blending)

+ (id)blendedColorFromWeightingArray:(NSArray*)inArray;
{
    NSParameterAssert( inArray != nil );
    NSParameterAssert( [inArray count] > 0 );
    
#if (HSB_MIX)
    double finalHue = 0.;
    double finalSaturation = 0.;
    double finalBrightness = 0.;
    double finalAlpha = 0.;
    double finalWeight = 0.;
    
    for ( NSDictionary *d in inArray ) {
        UIColor *c = [d objectForKey:@"color"];
        NSNumber* weightNumber = [d objectForKey:@"weight"];
        double weight = [weightNumber doubleValue];
     
        finalHue += [c hueComponent] * weight;
        finalSaturation += [c saturationComponent] * weight;
        finalBrightness += [c brightnessComponent] * weight;
        finalAlpha += [c alphaComponent] * weight;
        
        finalWeight += weight;
    }
        
    return [UIColor 
        colorWithHue:finalHue / finalWeight
        saturation:finalSaturation / finalWeight
        brightness:finalBrightness / finalWeight
        alpha:finalAlpha / finalWeight];
#else
    double finalRed = 0.;
    double finalGreen = 0.;
    double finalBlue = 0.;
    double finalAlpha = 0.;
    double finalWeight = 0.;
        
    for ( NSDictionary *d in inArray ) {
        UIColor *c = [d objectForKey:@"color"];
        NSNumber* weightNumber = [d objectForKey:@"weight"];
        double weight = [weightNumber doubleValue];
     
        finalRed += [c redComponent] * weight;
        finalGreen += [c greenComponent] * weight;
        finalBlue += [c blueComponent] * weight;
        finalAlpha += [c alphaComponent] * weight;
        
        finalWeight += weight;
    }
        
    return [UIColor 
        colorWithRed:finalRed / finalWeight
        green:finalGreen / finalWeight
        blue:finalBlue / finalWeight
        alpha:finalAlpha / finalWeight];
#endif
}

// Using math from the Wikipedia page:
//  http://en.wikipedia.org/wiki/HSL_color_space
- (double)hueComponent
{
    double red = [self redComponent];
    double green = [self greenComponent];
    double blue = [self blueComponent];
    
    double max = MAX( red, MAX( green, blue ) );
    double min = MIN( red, MIN( green, blue ) );
    
    double hue;
    
    if ( max == min ) {
        hue = 0.;
    }
    
    else if ( max == red ) {
        hue = ( 60. * ( ( green - blue ) / ( max - min ) ) );
        hue = fmod( hue, 360. );
    }
    
    else if ( max == green ) {
        hue = ( 60. * ( ( blue - red ) / ( max - min ) ) + 120. );
    }
    
    else if ( max == blue ) {
        hue = ( 60. * ( ( red - green ) / ( max - min ) ) + 240. );
    }
    
    return hue / 360.;
}

- (double)saturationComponent
{
    double red = [self redComponent];
    double green = [self greenComponent];
    double blue = [self blueComponent];
    
    double max = MAX( red, MAX( green, blue ) );
    double min = MIN( red, MIN( green, blue ) );    
    
    if ( max == min ) {
        return 0;
    }
    
    double brightness = [self brightnessComponent];
    
    if ( brightness <= 0.5 ) {
        return ( max - min ) / ( max + min );
    }
    else {
        return ( max - min ) / ( 2. - ( max + min ) );
    }
}

- (double)brightnessComponent
{
    double red = [self redComponent];
    double green = [self greenComponent];
    double blue = [self blueComponent];
    
    double max = MAX( red, MAX( green, blue ) );
    double min = MIN( red, MIN( green, blue ) );    
    
    if ( max == 0 ) {
        return 0.;
    }
    
    return ( 1. - ( min / max ) );
}

- (double)redComponent
{
    return [self componentWithIndex:RED];
}

- (double)greenComponent
{
    return [self componentWithIndex:GREEN];
}

- (double)blueComponent
{
    return [self componentWithIndex:BLUE];
}

- (double)alphaComponent
{
    CGColorRef color = [self CGColor];
    return CGColorGetAlpha( color );
}

- (double)componentWithIndex:(unsigned int)inIndex
{
    CGColorRef color = [self CGColor];
    const CGFloat *components = CGColorGetComponents( color );
    const unsigned int count = CGColorGetNumberOfComponents( color );
    if ( inIndex >= count ) {
        return 0;
    }
    return components[inIndex];    
}

@end
