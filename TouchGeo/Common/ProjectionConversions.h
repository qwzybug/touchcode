//
//  ProjectionConversions.h
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

extern double ArcLengthOfMeridian(double phi);
extern double UTMCentralMeridian(double zone);
extern double FootpointLatitude(double y);
extern void MapLatLonToXY(double inLatitude, double inLongitude, double inMeridianLongitude, double *outX, double *outY);
extern void MapXYToLatLon(double x, double y, double lambda0, double philambda[2]);
extern void LatLonToUTMXY(double inLatitude, double inLongitude, int *outZone, double *outEastings, double *outNorthings);
extern void UTMXYToLatLon(double x, double y, int zone, int southhemi, double latlon[2]);
