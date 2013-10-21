//
//  MBMapSnapshotter.m
//  PebbleNav
//
//  Created by Philip Brechler on 18.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "MBMapSnapshotter.h"
#import "AFNetworking.h"

@implementation MBMapSnapshotter


- (void)getSnapshotWithCenter:(CLLocationCoordinate2D)coordinate size:(CGSize)size zoomLevel:(int)zoom finishingBlock:(void (^)(MBSnapshot *snapshot,NSError *error))finishBlock {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tiles.mapbox.com/v3/%@/%f,%f,%d/%dx%d.png",self.mapName, coordinate.longitude, coordinate.latitude, zoom,(int)size.width,(int)size.height]];
    NSMutableURLRequest *imageRequest = [[NSMutableURLRequest alloc]initWithURL:URL];
    [imageRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation *imageOperation = [[AFHTTPRequestOperation alloc]initWithRequest:imageRequest];
    AFImageResponseSerializer *serializer = [AFImageResponseSerializer serializer];
    [serializer setImageScale:1.0];
    imageOperation.responseSerializer = serializer;
    [imageOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBSnapshot *snapShotToReturn = [[MBSnapshot alloc]initWithImage:responseObject centerCoordinate:coordinate zoomLevel:zoom];
        finishBlock(snapShotToReturn,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finishBlock(nil,error);
    }];
    [imageOperation start];

}
@end
