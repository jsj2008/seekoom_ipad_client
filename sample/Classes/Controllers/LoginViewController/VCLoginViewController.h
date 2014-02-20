//
//  VCLoginViewController.h
//  VCCloudClient
//
//  Created by lee on 13-1-29.
//  Copyright (c) 2013年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "GradientButton.h"

@interface VCLoginViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate>
{
    BOOL                isSigningIn;
    MBProgressHUD       *HUD;
    
    UIImageView         *_imageView;
    UITextField         *_portalTextField;
    UITextField         *_userNameTextField;
    UITextField         *_passwordTextField;
    UIButton            *_loginButton;
    UILabel             *_errorLabel;
}
@property (nonatomic, strong) UIAlertView *signingInAlert;
@property (strong, nonatomic) UITextField *portalTextField;
@property (strong, nonatomic) UITextField *userNameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UILabel *errorLabel;
@property (nonatomic, assign) BOOL isSigningIn;

- (IBAction)loginClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *Landscape;

@end
