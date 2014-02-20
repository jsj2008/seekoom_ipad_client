/*
 *  VidyoClientSample.c
 *
 *  Created by Chetan Gandhi on 08/19/11.
 *  Copyright 2011 Vidyo Inc. All rights reserved.
 *
 */

#import <assert.h>
#import <ctype.h>
#import <stdarg.h>
#import <stdio.h>
#import <string.h>
#import <unistd.h>
#import <wchar.h>
#import "VidyoClientSample_iOS_AppDelegate.h"
#import "VidyoClientSample.h"
#import "ASIHTTPRequest.h"
#import "CameraViewController.h"
#import "UIAlertView+Blocks.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "VCFoundation.h"


#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0)

BOOL videoFlag = YES;
BOOL audioFlag = YES;

static void SoundFinished(SystemSoundID soundID) {
    AudioServicesPlaySystemSound(soundID);
}
// Callback for out-events from VidyoClient
void vidyoClientSampleOnVidyoClientEvent(VidyoClientOutEvent event,
										 VidyoVoidPtr param, VidyoUint paramSize,
										 VidyoVoidPtr data)
{
	VidyoClientOutEventLicense *eventLicense;
	VidyoClientOutEventSignIn *eventSignIn;
	VidyoClientSample_iOS_AppDelegate *appDelegate = (__bridge VidyoClientSample_iOS_AppDelegate*)data;
    
    
	printf("Received event=%d \n", event);
	
	if (event >= VIDYO_CLIENT_OUT_EVENT_MIN
		&& event <= VIDYO_CLIENT_OUT_EVENT_MAX)
	{
        switch (event) {
            case VIDYO_CLIENT_OUT_EVENT_PARTICIPANT_BUTTON_CLICK:
            {
                VidyoClientOutEventParticipantButtonClick *buttonClickEvent = (VidyoClientOutEventParticipantButtonClick*) param;
                NSLog(@"%s",buttonClickEvent->srcParticipantID);
                if (buttonClickEvent->buttonType == VIDYO_CLIENT_PARTICIPANT_BUTTON_FECC) {
                    if (buttonClickEvent->buttonState == VIDYO_CLIENT_BUTTON_STATE_ON) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFECC" object:[NSString stringWithUTF8String:buttonClickEvent->srcParticipantID]];
                        break;
                    }
                    else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideFECC" object:nil];
                    }
                }
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_LICENSE:
            {
                /*
                 * If there are any issues with Licenses, this event will be sent
                 * by the VidyoClient library
                 */
                eventLicense = (VidyoClientOutEventLicense *) param;
                
                VidyoUint error = eventLicense->error;
                VidyoUint vmConnectionPath = eventLicense->vmConnectionPath;
                VidyoBool OutOfLicenses = eventLicense->OutOfLicenses;
                
                NSLog(@"License Error: errorid=%d vmConnectionPath=%d OutOfLicense=%d", error, vmConnectionPath, OutOfLicenses);
                
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_SIGN_IN:
            {
                eventSignIn = (VidyoClientOutEventSignIn *) param;
                
                VidyoUint activeEid = eventSignIn->activeEid;
                VidyoBool signinSecured = eventSignIn->signinSecured;
                
                NSLog(@"activeEid=%d signinSecured=%@", activeEid, signinSecured?@"Yes":@"No");
                /*
                 * If the EID is not setup, it will resturn activeEid = 0
                 * in this case, we invoke the license request using below event
                 */
                if(!activeEid)
                    (void)VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_LICENSE, NULL, 0);
                
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_JOINING:
            {
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_SIGNED_IN:
            {
//                [SVProgressHUD dismissWithSuccess:@"登陆成功"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
                
                [SVProgressHUD dismissWithSuccess:@"登陆成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"lgoinSuccess" object:nil];
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_SIGNED_OUT:
            {
                VidyoClientOutEventSignedOut *signOut = (VidyoClientOutEventSignedOut*)param;
                if (signOut->cause == VIDYO_CLIENT_SERVER_SIGNED_OUT) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"signOut" object:nil];
                } else if (signOut->cause == VIDYO_CLIENT_USER_SIGNED_OUT) {
                    if ([[appDelegate loginViewController] isSigningIn]) {
                        [[appDelegate loginViewController] setIsSigningIn:FALSE];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"signFeild" object:nil];
                [SVProgressHUD dismissWithSuccess:@"登陆失败,portal错误"];
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_MEDIA_CONTROL:
            {
                VidyoClientOutEventMediaControl *eventMediaControl = (VidyoClientOutEventMediaControl*)param;
                switch (eventMediaControl->mediaCommand) {
                    case VIDYO_CLIENT_MEDIA_CONTROL_COMMAND_SILENCE:
                        if (eventMediaControl->mediaType == VIDYO_CLIENT_MEDIA_CONTROL_TYPE_AUDIO) {
                            audioFlag = NO;
                        } else if (eventMediaControl->mediaType == VIDYO_CLIENT_MEDIA_CONTROL_TYPE_VIDEO) {
                            videoFlag = NO;
                        }
                        break;
                    default:
                        break;
                }
                break;
            }
                
            case VIDYO_CLIENT_OUT_EVENT_INCOMING_CALL:
            {
                /* Auto-accept all incoming calls */
                //                VidyoClientOutEventIncomingCall *incomingCall = (VidyoClientOutEventIncomingCall*)param;
                //                NSLog(@"Incoming call from %@ %s . Accepting.", incomingCall->onCallFlag?@"user":@"room", incomingCall->invitingUser);
                //                VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_ANS0WER, NULL, 0);
                
                NSUserDefaults *autoUserDefault = [NSUserDefaults standardUserDefaults];
                NSInteger autoSwitchIsOnOff = [autoUserDefault integerForKey:@"autoUserDefaultKey"];
                
                if (autoSwitchIsOnOff == 1) {
                    SystemSoundID sameViewSoundID;
                    NSString *thesoundFilePath = [[NSBundle mainBundle] pathForResource:@"ringtonex5" ofType:@"caf"];
                    CFURLRef thesoundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:thesoundFilePath];
                    AudioServicesCreateSystemSoundID(thesoundURL, &sameViewSoundID);
                    AudioServicesAddSystemSoundCompletion(sameViewSoundID, NULL, NULL, SoundFinished, thesoundURL);
    
                        AudioServicesPlaySystemSound(sameViewSoundID);
                        CFRunLoopRun();
                    
                    
                    RIButtonItem *cancelItem = [RIButtonItem item];
                    cancelItem.label = kAnswerTitle;
                    cancelItem.action = ^
                    {
                        AudioServicesDisposeSystemSoundID(sameViewSoundID);
                        VidyoClientOutEventIncomingCall *incomingCall = (VidyoClientOutEventIncomingCall*)param;
                        NSLog(@"Incoming call from %@ %s . Accepting.", incomingCall->onCallFlag?@"user":@"room", incomingCall->invitingUser);
                        VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_ANSWER, NULL, 0);
                    };
                    
                    RIButtonItem *deleteItem = [RIButtonItem item];
                    deleteItem.label = kDeclineTitle;
                    deleteItem.action = ^
                    {
                        AudioServicesDisposeSystemSoundID(sameViewSoundID);
                        VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_DECLINE, NULL, 0);
                    };
                    
                    VidyoClientOutEventIncomingCall *incomingCall = (VidyoClientOutEventIncomingCall*)param;
                    UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:kNewCallTitle,[NSString stringWithUTF8String:incomingCall->invitingUser]] message:@"" cancelButtonItem:cancelItem otherButtonItems:deleteItem, nil];
                    [myalert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                    
                    break;
                } else {
                    VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_ANSWER, NULL, 0);
                    break;
                }
            }
            case VIDYO_CLIENT_OUT_EVENT_CONFERENCE_ACTIVE:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyboard" object:nil];
                if (IOS_NEWER_OR_EQUAL_TO_7) {
                    NSError *error = nil;
                    if ([[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVideoChat error:&error] != YES) {
                        NSLog(@"Failed to switch to AVAudioSessionModeVideoChat");
                        if (error) {
                            NSLog(@"AUDIO_SESSION SWITCH ERROR: %@", error);
                        }
                    }
                }
                
                VidyoClientOutEventEnabled enabled = {0};
                enabled.isEnabled = VIDYO_FALSE;
                VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_ENABLE_BUTTON_BAR,&enabled , sizeof(enabled));
                
                [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
                
                VidyoClientRequestSetBackground background = {0};
                background.willBackground = VIDYO_FALSE;
                (void)VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_SET_BACKGROUND, &background, sizeof(background));
                /* Add logic for joining to a conference logic */
                
                NSUserDefaults *cameraUserDefault = [NSUserDefaults standardUserDefaults];
                NSInteger cameraSwitchIsOnOff = [cameraUserDefault integerForKey:@"cameraUserDefaultKey"];
                
                NSUserDefaults *microphoneUserDefault = [NSUserDefaults standardUserDefaults];
                NSInteger microphoneSwitchIsOnOff = [microphoneUserDefault integerForKey:@"microphoneUserDefaultKey"];
                
                
                VidyoClientInEventMute muteEvent = {0};
                
                if (cameraSwitchIsOnOff == 0) {
                    muteEvent.willMute = VIDYO_FALSE;
                    if (videoFlag == NO) {
                        muteEvent.willMute = VIDYO_TRUE;
                    } else {
                        muteEvent.willMute = VIDYO_FALSE;
                    }
                } else {
                    muteEvent.willMute = VIDYO_TRUE;
                }
                (void)VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_MUTE_VIDEO, &muteEvent, sizeof(VidyoClientInEventMute));
                
                if (microphoneSwitchIsOnOff == 0) {
                    muteEvent.willMute = VIDYO_FALSE;
                    if (audioFlag == NO) {
                        
                        muteEvent.willMute = VIDYO_TRUE;
                    } else {
                        muteEvent.willMute = VIDYO_FALSE;
                    }
                } else {
                    muteEvent.willMute = VIDYO_TRUE;
                }
                
                (void)VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_MUTE_AUDIO_IN, &muteEvent, sizeof(VidyoClientInEventMute));
                

                
                
                VidyoClientPreviewMode previewMode = VIDYO_CLIENT_PREVIEW_MODE_NONE;
                (void)VidyoClientSendEvent(VIDYO_CLIENT_OUT_EVENT_PREVIEW,&previewMode,sizeof(VidyoClientPreviewMode));
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_CONFERENCE_ENDED:
            {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                audioFlag = YES;
                videoFlag = YES;
                break;
            }
            case VIDYO_CLIENT_OUT_EVENT_ADD_SHARE:
            {
                VidyoClientOutEventAddShare *share = (VidyoClientOutEventAddShare*)param;
                VidyoClientRequestWindowShares shares = {0};
                VidyoUint error;
                
                shares.requestType = LIST_SHARING_WINDOWS;
                error = VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_GET_WINDOW_SHARES, (void*)&shares, sizeof(VidyoClientRequestWindowShares));
                if (error != VIDYO_CLIENT_ERROR_OK)
                {
                    NSLog(@"Failed to send a request for window shares. Error response %u", error);
                    break;
                }
                /* See if we have a share in a list. If we do set current share to a new one. */
                for (int i = 1 /* index starts from 1 */ ; i <= shares.shareList.numApp; i++) {
                    if (strcmp(shares.shareList.remoteAppUri[i], share->URI) == 0)
                    {
                        shares.requestType = ADD_SHARING_WINDOW;
                        shares.shareList.currApp = shares.shareList.newApp = i;
                        error = VidyoClientSendRequest(VIDYO_CLIENT_REQUEST_SET_WINDOW_SHARES, (void*)&shares, sizeof(VidyoClientRequestWindowShares));
                        if (error != VIDYO_CLIENT_ERROR_OK)
                        {
                            NSLog(@"Failed to send a request to change window share. Error response %u", error);
                            break;
                        }
                        break;
                    }
                }
                NSLog(@"Share URL is not found in the share list");
                break;
            }
            default:
                break;
        }
        
	}
	else
	{
        NSLog(@"Unknown event %d", event);
	}
}

