//
//  ViewController.h
//  MBMapSnapshotter
//
//  Created by Philip Brechler on 21.10.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *imageView;

- (IBAction)getImage:(id)sender;

- (IBAction)getImageAndDraw:(id)sender;

@end
