extern double ArcLengthOfMeridian(double phi);
extern double UTMCentralMeridian(double zone);
extern double FootpointLatitude(double y);
extern void MapLatLonToXY(double inLatitude, double inLongitude, double inMeridianLongitude, double *outX, double *outY);
extern void MapXYToLatLon(double x, double y, double lambda0, double philambda[2]);
extern void LatLonToUTMXY(double inLatitude, double inLongitude, int *outZone, double *outEastings, double *outNorthings);
extern void UTMXYToLatLon(double x, double y, int zone, int southhemi, double latlon[2]);
