//
//  CAcceleration.h
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 08/26/08
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#pragma mark begin emogenerator forward declarations
#pragma mark end emogenerator forward declarations

/** Acceleration */
@interface CAcceleration : NSManagedObject {
}

#pragma mark begin emogenerator accessors

// Attributes
@property (readwrite, assign) double y;
@property (readwrite, retain) NSNumber *yValue;
@property (readwrite, assign) double x;
@property (readwrite, retain) NSNumber *xValue;
@property (readwrite, retain) NSDate *timestamp;
@property (readwrite, assign) double z;
@property (readwrite, retain) NSNumber *zValue;

// Relationships

#pragma mark end emogenerator accessors

@end
