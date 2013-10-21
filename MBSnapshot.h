//
//  MBSnapshot.h
//  PebbleNav
//
//  Created by Philip Brechler on 18.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef struct {
    CLLocationCoordinate2D north_west_coordinate;
    CLLocationCoordinate2D south_east_coordinate;
} MBSnapshotBoundingCoordinates;

@interface MBSnapshot : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CLLocationCoordinate2D center;
@property (nonatomic) float zoom;
@property (nonatomic) MBSnapshotBoundingCoordinates boundingCoordinates;

- (instancetype)initWithImage:(UIImage *)image centerCoordinate:(CLLocationCoordinate2D)center zoomLevel:(float)zoom;
- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate;

@end
