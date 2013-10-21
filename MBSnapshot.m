//
//  MBSnapshot.m
//  PebbleNav
//
//  Created by Philip Brechler on 18.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "MBSnapshot.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

const double radiusEarthKilometres = 6372.7982;

@implementation MBSnapshot

- (instancetype)initWithImage:(UIImage *)image centerCoordinate:(CLLocationCoordinate2D)center zoomLevel:(float)zoom {
    self = [super init];
    if (self) {
        self.image = image;
        self.center = center;
        self.zoom = zoom;
        [self getBoundsForCenterCoordinate:self.center withZoom:self.zoom andSize:self.image.size];
    }
    return self;
}

- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate {
    return [self getPointForCoordinate:coordinate inImage:self.image withCenter:self.center withZoomLevel:self.zoom];
}

#pragma mark - Map helpers


- (void)getBoundsForCenterCoordinate:(CLLocationCoordinate2D)coord withZoom:(float)zoom andSize:(CGSize)size {
    double latradians = DEGREES_TO_RADIANS(coord.latitude);
    double earth_circ = (2 * M_PI * radiusEarthKilometres) * 1000;
    double meterPerPixel = earth_circ * cos(latradians) / pow(2,zoom+8);
    double metersHalfSizeWidth = (size.width/2) * meterPerPixel;
    double metersHalfSizeHeight = (size.height/2) * meterPerPixel;
    double distanceMeters = sqrt(pow(metersHalfSizeWidth, 2)+pow(metersHalfSizeHeight, 2));
    
    double rad_alpha = DEGREES_TO_RADIANS(90) - asin((metersHalfSizeWidth / distanceMeters));
    
    double rad_bearing_north_west = DEGREES_TO_RADIANS(270) + rad_alpha;
    double rad_bearing_south_east = DEGREES_TO_RADIANS(90) + rad_alpha;

    MBSnapshotBoundingCoordinates theBoundingCoordinates  =  {.north_west_coordinate = [self findPointAtDistanceFrom:coord bearingRadians:rad_bearing_north_west distanceKilometers:distanceMeters/1000], .south_east_coordinate= [self findPointAtDistanceFrom:coord bearingRadians:rad_bearing_south_east distanceKilometers:distanceMeters/1000] };
    
    self.boundingCoordinates = theBoundingCoordinates;
}

- (CLLocationCoordinate2D)findPointAtDistanceFrom:(CLLocationCoordinate2D)startPoint bearingRadians:(double)initialBearingRadians distanceKilometers:(double)distanceKilometres {
    
    double distRatio = distanceKilometres / radiusEarthKilometres;
    double distRatioSine = sin(distRatio);
    double distRatioCosine = cos(distRatio);
    
    double startLatRad = DEGREES_TO_RADIANS(startPoint.latitude);
    double startLonRad = DEGREES_TO_RADIANS(startPoint.longitude);
    
    double startLatCos = cos(startLatRad);
    double startLatSin = sin(startLatRad);
    
    double endLatRads = asin((startLatSin * distRatioCosine) + (startLatCos * distRatioSine * cos(initialBearingRadians)));
    
    double endLonRads = startLonRad + atan2(sin(initialBearingRadians) * distRatioSine * startLatCos,distRatioCosine - startLatSin * sin(endLatRads));
    
    
    return CLLocationCoordinate2DMake(RADIANS_TO_DEGREES(endLatRads), RADIANS_TO_DEGREES(endLonRads));
}

- (CGPoint)getPointForCoordinate:(CLLocationCoordinate2D)coord inImage:(UIImage *)image withCenter:(CLLocationCoordinate2D)center withZoomLevel:(float)zoom {
   
    
    CLLocationCoordinate2D topLeft = self.boundingCoordinates.north_west_coordinate;
    CLLocationCoordinate2D bottomRight = self.boundingCoordinates.south_east_coordinate;
    
    CGFloat xPoint = image.size.width * (coord.longitude - topLeft.longitude)/(bottomRight.longitude - topLeft.longitude);
    CGFloat yPoint = image.size.height * ( 1 - (coord.latitude - bottomRight.latitude)/(topLeft.latitude - bottomRight.latitude));

    return CGPointMake(xPoint, yPoint);
}
@end
