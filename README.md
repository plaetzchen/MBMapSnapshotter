MBMapSnapshotter
================

Use MBMapSnapshotter to retrieve an image from the MapBox.com static image service with your custom style. After downloading the image the class will call a block with a MBSnapshot Object from witch you can retrieve the UIImage itself and also get the CGPoint in the image for a give CLLocationCoordinate2d (useful to draw custom markers or routes on it)

Installation
------------

Make this repo a submodule of your git repository or just fork it. You'll also need AFNetworking. I'm currently working on a CocoaPods Podspec

Usage
-----

```obj-c
#import <CLLocation/CLLocation.h>
#import "AFNetworking.h"
#import "MBMapSnapshotter.h"

- (void)takeSnapshot {
  CLLocationCoordinate2D coordnate = CLLocationCoordnate2DMake(52.516667, 13.383333) //Berlin
  MBMapSnapshotter *mapSnapShotter = [[MBMapSnapshotter alloc]init];
  [mapSnapShotter setMapName:@"mapbox.world-bright"];
  [mapSnapShotter getSnapshotWithCenter:coordinate size:CGSizeMake(480, 320) zoomLevel:14 finishingBlock:^(MBSnapshot *snapshot, NSError *error) {
    if (error){
      NSLog(@"Error %@", error);
    } else {
      [_imageView setImage snapshot.image];
    }
  }];
}
```
You can also use <pre>- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate</pre> to get a point in the image for a give coordinate.

Issues
------

* The images are 1x only, if you need Retina images you will need to request the 2x size
* The minimum size is 4x4 pixels, the maximum size is 640x640 (restriction by MapBox.com)
* The image property of MBSnapshot is not read-only right now so you should be aware that the coordinates will only be true for the initial map image
