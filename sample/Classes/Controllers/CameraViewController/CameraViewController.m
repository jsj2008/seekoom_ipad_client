//
//  CameraViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-10-21.
//
//

#import "CameraViewController.h"
#import "VidyoClient.h"
#import "VidyoClientSample_iOS_AppDelegate.h"
@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize uriString = _uriString;
@synthesize testView = _testView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = NO;
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft){
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI * 1.5)];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI * 2)];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)upButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_TILTUP;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));

}

- (IBAction)downButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_TILTDOWN;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));
}

- (IBAction)leftButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_PANLEFT;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));
}

- (IBAction)rightButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_PANRIGHT;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));
}

- (IBAction)zoomInButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_ZOOMIN;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));
}

- (IBAction)zoomOutButton:(id)sender {
    VidyoClientInEventControlCamera controlCamera = {0};
    strlcpy(controlCamera.uri,[self.uriString UTF8String], [self.uriString length] + 1);
    controlCamera.cameraCommand = VIDYO_CLIENT_CAMERA_CONTROL_ZOOMOUT;
    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_CONTROL_CAMERA, &controlCamera, sizeof(VidyoClientInEventControlCamera));
}

-(void) SetRate: (UIInterfaceOrientation) toInterfaceOrientation{
    switch (toInterfaceOrientation) {

		case UIDeviceOrientationPortrait:
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI * 2)];
            [self.view setFrame:CGRectMake(230, 680, 300, 300)];
			break;
		case UIDeviceOrientationPortraitUpsideDown:
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
            [self.view setFrame:CGRectMake(230, 10, 300, 300)];
			break;
		case UIDeviceOrientationLandscapeLeft:
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [self.view setFrame:CGRectMake(0, 360, 300, 300)];
            break;
		case UIDeviceOrientationLandscapeRight:
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI * 1.5)];
            [self.view setFrame:CGRectMake(420, 360, 300, 300)];
            break;
        default:
            break;
    }
}

@end
