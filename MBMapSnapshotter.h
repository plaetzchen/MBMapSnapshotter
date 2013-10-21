//
//  MBMapSnapshotter.h
//  PebbleNav
//
//  Created by Philip Brechler on 18.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MBSnapshot.h"

@interface MBMapSnapshotter : NSObject

@property (nonatomic, strong) NSString *mapName;

- (void)getSnapshotWithCenter:(CLLocationCoordinate2D)coordinate size:(CGSize)size zoomLevel:(int)zoom finishingBlock:(void (^)(MBSnapshot *snapshot,NSError *error))finishBlock;

@end
