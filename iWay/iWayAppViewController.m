//
//  iWayAppViewController.m
//  iWay
//
//  Created by stefano belfanti on 03/04/14.
//  Copyright (c) 2014 stefano belfanti. All rights reserved.
//

#import "iWayAppViewController.h"

//@interface iWayAppViewController ()
//@synthesize xBar,yBar,zBar,motionController,queue;
//@end

@implementation iWayAppViewController
float c;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = 0.05;
    self.motionManager.deviceMotionUpdateInterval = 0.05;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMDeviceMotion *gData, NSError *error) {
                                        [self outputData:gData.attitude];
                                    }];
    }

	// Do any additional setup after loading the view, typically from a nib.

-(void)outputData:(CMAttitude*)acce
{
    //self.xLabel.text = [NSString stringWithFormat:@" %.2f",(180/M_PI)*acce.pitch];
    
    float xfloat = (180/M_PI)*acce.pitch;
    int xint = xfloat;
    self.xLabel.text = [NSString stringWithFormat:@" %i",xint];
    ////////////////////
    CMQuaternion quat = acce.quaternion;
    double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
    
    // TODO improve the yaw interval (stuck to [-PI/2, PI/2] due to arcsin definition
    
    yaw *= -1;      // reverse the angle so that it reflect a *liquid-like* behavior
    yaw += M_PI_2;  // because for the motion manager 0 is the calibration value (but for us 0 is the horizontal axis)
    
    if (self.motionLastYaw == 0) {
        self.motionLastYaw = yaw;
    }
    
    // kalman filtering
    static float q = 0.1;   // process noise
    static float r = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.motionLastYaw;
    p = p + q;
    k = p / (p + r);
    x = x + k*(yaw - x);
    p = (1 - k)*p;
    self.motionLastYaw = x;
    NSLog(@"new x %.2f",x);
    ////////////////////
}
-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    //NSLog(@"gyro X = %f", rotation.x);
    //self.xLabel.text = [NSString stringWithFormat:@" %.2f",rotation.x];
    self.xBar.progress = ABS(rotation.x);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
