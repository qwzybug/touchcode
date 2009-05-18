//
//  UIColor_Blending.h
//  ColorMixer
//
//  Created by Christopher Liscio on 1/14/09.
//  Copyright 2009 SuperMegaUltraGroovy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (Blending)

// The passed-in array contains a set of NSDictionary objects laid out like so:
// 
//      { 'color':UIColor*, 'weight':NSNumber* },
//      { 'color':UIColor*, 'weight':NSNumber* },
//      ...
//
// A resulting color is determined by weighting the individual colors by their 
// weights as specified in the NSDictionary.
//
// The incoming weights should ideally add up to 1.  If not, the results are
// undefined.
+ (id)blendedColorFromWeightingArray:(NSArray*)inArray;

- (double)redComponent;
- (double)greenComponent;
- (double)blueComponent;
- (double)alphaComponent;

- (double)hueComponent;
- (double)saturationComponent;
- (double)brightnessComponent;

@end
