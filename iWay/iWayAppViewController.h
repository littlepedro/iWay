//
//  iWayAppViewController.h
//  iWay
//
//  Created by stefano belfanti on 03/04/14.
//  Copyright (c) 2014 stefano belfanti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface iWayAppViewController : UIViewController
    
    
    @property (strong, nonatomic) IBOutlet UIProgressView *xBar;
    @property (strong, nonatomic) IBOutlet UIProgressView *yBar;
    @property (strong, nonatomic) IBOutlet UIProgressView *zBar;
    
    @property (strong, nonatomic) IBOutlet UILabel *xLabel;
    @property (strong, nonatomic) IBOutlet UILabel *yLabel;
    @property (strong, nonatomic) IBOutlet UILabel *zLabel;
    
    
    @property (strong, nonatomic) CMMotionManager *motionManager;

    @property (strong, nonatomic) NSOperationQueue *queue;
    @property (nonatomic) float motionLastYaw;
    
    



@end
