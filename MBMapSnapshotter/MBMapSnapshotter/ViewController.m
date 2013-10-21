//
//  ViewController.m
//  MBMapSnapshotter
//
//  Created by Philip Brechler on 21.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "ViewController.h"
#import "MBMapSnapshotter.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getImage:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.516667, 13.383333); //Berlin
    MBMapSnapshotter *mapSnapShotter = [[MBMapSnapshotter alloc]init];
    [mapSnapShotter setMapName:@"examples.map-9ijuk24y"];
    [mapSnapShotter getSnapshotWithCenter:coordinate size:CGSizeMake(300, 300) zoomLevel:15 finishingBlock:^(MBSnapshot *snapshot, NSError *error) {
        if (error){
            NSLog(@"Error %@",error);
        } else {
            [self.imageView setImage:snapshot.image];
        }
    }];
}

- (IBAction)getImageAndDraw:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.516667, 13.383333); //Berlin
    MBMapSnapshotter *mapSnapShotter = [[MBMapSnapshotter alloc]init];
    [mapSnapShotter setMapName:@"examples.map-9ijuk24y"];
    [mapSnapShotter getSnapshotWithCenter:coordinate size:CGSizeMake(300, 300) zoomLevel:15 finishingBlock:^(MBSnapshot *snapshot, NSError *error) {
        if (error){
            NSLog(@"Error %@",error);
        } else {
            CGPoint pointForBrandenburgGate = [snapshot pointForCoordinate:CLLocationCoordinate2DMake(52.516272, 13.377722)];
            
            UIGraphicsBeginImageContext(snapshot.image.size);
            [snapshot.image drawInRect:CGRectMake(0, 0, snapshot.image.size.width, snapshot.image.size.height)];
            
            UIImage *currentPointImage = [UIImage imageNamed:@"brandenburg_gate_small"];
            
            // Draw image2
            [currentPointImage drawInRect:CGRectMake(pointForBrandenburgGate.x-(currentPointImage.size.width/2),pointForBrandenburgGate.y-(currentPointImage.size.height/2),currentPointImage.size.width,currentPointImage.size.height)];
            
            UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.imageView setImage:resultingImage];
        }
    }];
}

@end
