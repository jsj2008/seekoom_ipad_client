/*
 *  VidyoClientSample_iOS_AppDelegate.m
 *
 *  Created by Chetan Gandhi on 08/19/11.
 *  Copyright 2011 Vidyo Inc. All rights reserved.
 *
 */

#import "VidyoClientSample_iOS_AppDelegate.h"
#include "VidyoClientSample.h"
#import "UserGuideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"

// Constants

@interface VidyoClientSample_iOS_AppDelegate()
@end

@implementation VidyoClientSample_iOS_AppDelegate

@synthesize window;
@synthesize loginViewController;
@synthesize categoryViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] initWithNibName:@"UserGuideViewController" bundle:nil];
        self.window.rootViewController = userGuideViewController;
    } else {
        VCLoginViewController *VCloginViewController = [[VCLoginViewController alloc] initWithNibName:@"VCLoginViewController" bundle:nil];

        self.window.rootViewController = VCloginViewController;

    }

    
    [self.window makeKeyAndVisible];
    // initialize client
    [self clientInit];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(orientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification"
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFECCNotification:)
												 name:@"showFECC"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideFECCNotification:)
												 name:@"hideFECC"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ControlCameraNotification:)
												 name:@"ControlCamera"
                                               object:nil];

    return YES;
}


- (void)ControlCameraNotification:(NSNotification *)notify{
    NSArray *obj = [notify object];
    for (int i = 0; i < [obj count]; i++) {
        NSString *uriString = [NSString stringWithFormat:[obj objectAtIndex:i]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:uriString forKey:@"uriString"];
        [defaults synchronize];
    }
}


- (void)showFECCNotification:(NSNotification *)notify{
    
    id uriString = [notify object];
    self.CameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    self.cameraViewController.uriString = (NSString *)uriString;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft){
        [self.cameraViewController.view setFrame:CGRectMake(420, 360, 300, 300)];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        [self.cameraViewController.view setFrame:CGRectMake(0 , 360, 300, 300)];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [self.cameraViewController.view setFrame:CGRectMake(230, 680, 300, 300)];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
         [self.cameraViewController.view setFrame:CGRectMake(230, 10, 300, 300)];
    }
    [self.window addSubview:self.cameraViewController.view];
}



- (void)hideFECCNotification:(NSNotification *)notify{
    [self.cameraViewController.view removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    VidyoClientRequestSetBackground request = {0};
	request.willBackground = VIDYO_TRUE;
	
	if (VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_SET_BACKGROUND, &request, sizeof(request)) == NO) {
		NSLog(@"problem going to background");
	}
	sleep(3);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    VidyoClientRequestSetBackground request = {0};
	request.willBackground = VIDYO_FALSE;
	
	if (VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_SET_BACKGROUND, &request, sizeof(request)) == NO) {
		NSLog(@"problem going to background");
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     */
	NSLog(@"applicationWillTerminate called");
    
	// try to shutdown VidyoClient library
	if (!_vidyoClientStarted)
	{
		return;
	}
	
	if (VidyoClientStop() != VIDYO_TRUE)
	{
		// not expected condition
		NSLog(@"VidyoClientStop() returned error!");
		return;
	}
	
	VidyoClientUninitialize();
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)orientationDidChange:(NSNotification *)notification
{
	NSLog(@"Orientation changed %@", notification);
	
	// determine device orientation
	VidyoClientInEventSetOrientation event = {0};
	event.orientation = (VidyoClientOrientation)lastKnownOrientation;
	event.control = VIDYO_CLIENT_ORIENTATION_CONTROL_BOTH;
	BOOL willSetOrientation = NO;
    [self.cameraViewController SetRate:[[UIDevice currentDevice] orientation]];
	switch([[UIDevice currentDevice] orientation])
	{
		case UIDeviceOrientationUnknown:
			VIDYO_CLIENT_LOG_DEBUG("Unknown");
			VIDYO_CLIENT_CONSOLE_LOG("Unknown\n");
			break;
		case UIDeviceOrientationPortrait:
			VIDYO_CLIENT_LOG_DEBUG("Portrait");
			VIDYO_CLIENT_CONSOLE_LOG("Portrait\n");
			event.orientation = VIDYO_CLIENT_ORIENTATION_UP;
			willSetOrientation = YES;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			VIDYO_CLIENT_LOG_DEBUG("PortraitUpsideDown");
			VIDYO_CLIENT_CONSOLE_LOG("PortraitUpsideDown\n");
			event.orientation = VIDYO_CLIENT_ORIENTATION_DOWN;
			willSetOrientation = YES;
			break;
		case UIDeviceOrientationLandscapeLeft:
			VIDYO_CLIENT_LOG_DEBUG("LandscapeLeft");
			VIDYO_CLIENT_CONSOLE_LOG("LandscapeLeft\n");
			event.orientation = VIDYO_CLIENT_ORIENTATION_RIGHT;
			willSetOrientation = YES;
			break;
		case UIDeviceOrientationLandscapeRight:
			VIDYO_CLIENT_LOG_DEBUG("LandscapeRight");
			VIDYO_CLIENT_CONSOLE_LOG("LandscapeRight\n");
			event.orientation = VIDYO_CLIENT_ORIENTATION_LEFT;
			willSetOrientation = YES;
			break;
		case UIDeviceOrientationFaceUp:
			VIDYO_CLIENT_LOG_DEBUG("FaceUp");
			VIDYO_CLIENT_CONSOLE_LOG("FaceUp\n");
			break;
		case UIDeviceOrientationFaceDown:
			VIDYO_CLIENT_LOG_DEBUG("FaceDown");
			VIDYO_CLIENT_CONSOLE_LOG("FaceDown\n");
			break;
	}
	
	if (!initiated && willSetOrientation)
	{
		initiated=YES;
	}
	
	// cache orientation if needed
	if (willSetOrientation)
	{
		VidyoClientRequestCallState callState = {0};
		VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_GET_CALL_STATE, &callState, sizeof(callState));
		// new orientation becomes known, set as last known orientation
		lastKnownOrientation = (unsigned)(event.orientation);
		if (callState.callState == VIDYO_CLIENT_CALL_STATE_IN_CONFERENCE)
		{
			[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear
							 animations:^{
								 [[UIApplication sharedApplication] setStatusBarOrientation:[[UIDevice currentDevice] orientation]];
							 }
							 completion:^(BOOL finished){
							 } ];
		}
	}
	
	// always send event to VidyoClient to set orientation, whether new or cached,
	// in case AppFramework objects were not created in time for first orientation change/poll
	(void)VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_SET_ORIENTATION,
							   &event, sizeof(VidyoClientInEventSetOrientation));
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk)
	 later.
     */
}

#pragma mark -
#pragma mark Client initialization


// Perform client initialization, including startup of VidyoClient library
- (void)clientInit
{
    VidyoBool ret;
	// check if this method already previously entered
	if (_vidyoClientStarted)
		return;
    
	// configure console logging
	VidyoClientConsoleLogConfigure(VIDYO_CLIENT_CONSOLE_LOG_CONFIGURATION_ALL);
	
	// determine video rectangle, from geometry of main window, assuming portrait right-side up orientation
	VidyoRect videoRect
	= {(VidyoInt)(window.frame.origin.x), (VidyoInt)(window.frame.origin.y),
		(VidyoUint)(window.frame.size.width), (VidyoUint)(window.frame.size.height)};
    
    
    
    
	// determine path, default base filename, and levels and categories, used for logging
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
	const char *pathToLogDir = [documentsDirectory cStringUsingEncoding:NSUTF8StringEncoding];
	
	VidyoClientLogParams logParams = {0};
	
	logParams.logBaseFileName = "VidyoSample_";
	logParams.pathToLogDir = pathToLogDir;
	logParams.logLevelsAndCategories = "warning info@AppGui info@App info@AppEmcpClient info@LmiApp";
	
	
	if (VidyoClientInitialize(vidyoClientSampleOnVidyoClientEvent, (__bridge VidyoVoidPtr)(self), &logParams) == VIDYO_FALSE)
	{
		NSLog(@"VidyoClientInit() returned failure!\n");
		goto FAIL;
	}
	
	VidyoClientProfileParams profileParams = {0};
	
	// startup VidyoClient library
	ret = VidyoClientStart(vidyoClientSampleOnVidyoClientEvent,
						   (__bridge VidyoVoidPtr)(self),
						   &logParams,
						   (__bridge VidyoWindowId) window,
						   &videoRect,
						   NULL,
						   &profileParams,
						   VIDYO_FALSE);
	
	if (!ret)
	{
		NSLog(@"VidyoClientStart() returned failure!\n");
		goto FAIL;
	}
	else
	{
		NSLog(@"VidyoClientStart() returned success!\n");
	}
    
//    VidyoClientInEventSetOrientation orientation = {0};
//    orientation.orientation = VIDYO_CLIENT_ORIENTATION_RIGHT;
//    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_SET_ORIENTATION, &orientation, sizeof(VidyoClientInEventSetOrientation));
    
	[self bootstrap];
	return;
    
	// cleanup on failure, exiting program
FAIL: /*[[UIApplication sharedApplication] terminate:self]*/;
}

-(void) bootstrap
{
	VidyoClientRequestConfiguration conf = {0};
	VidyoUint error;
	if ((error = VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_GET_CONFIGURATION, &conf, sizeof(VidyoClientRequestConfiguration))) != VIDYO_CLIENT_ERROR_OK) {
		NSLog(@"Failed to request configuration with error %u", error);
	} else {
		[[UIApplication sharedApplication] setStatusBarOrientation:[[UIDevice currentDevice] orientation]];
		/* Default configuration */
        
		conf.enableShowConfParticipantName = VIDYO_TRUE;
		conf.enableHideCameraOnJoin = VIDYO_FALSE;
		conf.enableBackgrounding = VIDYO_TRUE;
		/* Disable autologin */
		conf.userID[0] = '\0';
		conf.portalAddress[0] = '\0';
		conf.serverAddress[0] = '\0';
		conf.password[0] = '\0';
		conf.selfViewLoopbackPolicy = 2;
		if (VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_SET_CONFIGURATION, &conf, sizeof(VidyoClientRequestConfiguration)) != VIDYO_CLIENT_ERROR_OK) {
			NSLog(@"Failed to set configuration");
		}
	}
}



// Getter for attribute, indicating if VidyoClientStart() has been called
- (BOOL)vidyoClientStarted
{
	return _vidyoClientStarted;
}

@end
