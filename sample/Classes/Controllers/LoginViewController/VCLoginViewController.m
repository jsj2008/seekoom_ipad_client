//
//  VCLoginViewController.m
//  VCCloudClient
//
//  Created by lee on 13-1-29.
//  Copyright (c) 2013年 lee. All rights reserved.
//

#import "VCLoginViewController.h"
#import "VCFoundation.h"
#import "SLGlowingTextField.h"
#import "DBValidator.h"
#import "VidyoClient.h"
#import "VidyoClientConstants.h"
#import "VidyoClientMessages.h"
#import "VidyoClientParameters.h"
#import "ASIHTTPRequest.h"
#import "NSString+Base64.h"
#import "GDataXMLNode.h"
#import "Users.h"
#import "FrontViewController.h"
#import "VidyoClientSample_iOS_AppDelegate.h"
#import "CategoryViewController.h"
#import "VCFoundation.h"
#import "CheckNetwork.h"
#import "SVProgressHUD.h"

@implementation VCLoginViewController
@synthesize portalTextField = _portalTextField;
@synthesize userNameTextField = _userNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize loginButton = _loginButton;
@synthesize imageView = _imageView;
@synthesize errorLabel = _errorLabel;
@synthesize isSigningIn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.view.bounds = CGRectMake(0, 0, 1024, 768);
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_landscape.png"]];
        [self.portalTextField setFrame:CGRectMake(390, 132, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(390, 172, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(390, 212, 300, 30)];
        [self.loginButton setFrame:CGRectMake(320, 300, 380, 55)];
        [self.errorLabel setFrame:CGRectMake(380, 260, 300, 32)];
        
    } else {
        self.view.bounds = CGRectMake(0, 0, 768, 1024);
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_portrait.png"]];
        [self.portalTextField setFrame:CGRectMake(260, 133, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(260, 173, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(260, 213, 300, 30)];
        [self.loginButton setFrame:CGRectMake(205, 300, 380, 55)];
        [self.errorLabel setFrame:CGRectMake(280, 260, 300, 32)];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.view.bounds = CGRectMake(0, 0, 1024, 768);
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_landscape.png"]];
        [self.portalTextField setFrame:CGRectMake(390, 132, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(390, 172, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(390, 212, 300, 30)];
        [self.loginButton setFrame:CGRectMake(320, 300, 380, 55)];
    } else {
        self.view.bounds = CGRectMake(0, 0, 768, 1024);
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_portrait.png"]];
        [self.portalTextField setFrame:CGRectMake(260, 133, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(260, 173, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(260, 213, 300, 30)];
        [self.loginButton setFrame:CGRectMake(205, 300, 380, 55)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_secondimage_landscape.png"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOutNotification:)
												 name:@"signOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInErrNotification:)
												 name:@"signInErr" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgoinSuccessNotification:)
												 name:@"lgoinSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signFeildNotification:)
												 name:@"signFeild" object:nil];
    
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setImage:[UIImage imageNamed:@"ipad_login_landscape.png"]];
    
    self.portalTextField = [[UITextField alloc] init];
    [self.portalTextField setBorderStyle:UITextBorderStyleNone];
    self.portalTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.portalTextField.placeholder = kPortalTextField;
    self.portalTextField.keyboardType = UIKeyboardTypeURL;
    self.portalTextField.returnKeyType = UIReturnKeyNext;
    
    self.userNameTextField = [[UITextField alloc] init];
    [self.userNameTextField setBorderStyle:UITextBorderStyleNone];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.userNameTextField.placeholder = kUserNameTextField;
    
    self.passwordTextField = [[UITextField alloc] init];
    [self.passwordTextField setBorderStyle:UITextBorderStyleNone];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.placeholder = kPasswordTextField;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    
    self.errorLabel = [[UILabel alloc] init];
    [self.errorLabel setBackgroundColor:[UIColor clearColor]];
    self.errorLabel.textColor = [UIColor redColor];
    [self.errorLabel setFrame:CGRectMake(380, 260, 300, 32)];
    [self.errorLabel setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    [self.errorLabel setText:@""];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"ipad_loiginButton_image_background.png"] forState:UIControlStateNormal];
    [self.loginButton setTitle:kLoginButtonTitle forState:UIControlStateNormal];
    [self.loginButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.view.bounds = CGRectMake(0, 0, 1024, 768);
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_landscape.png"]];
        [self.portalTextField setFrame:CGRectMake(390, 132, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(390, 172, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(390, 212, 300, 30)];
        [self.loginButton setFrame:CGRectMake(320, 300, 380, 55)];
    } else {
        self.view.bounds = CGRectMake(0, 0, 768, 1024);
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.imageView setImage:[UIImage imageNamed:@"ipad_login_portrait.png"]];
        [self.portalTextField setFrame:CGRectMake(260, 133, 300, 30)];
        [self.userNameTextField setFrame:CGRectMake(260, 173, 300, 30)];
        [self.passwordTextField setFrame:CGRectMake(260, 213, 300, 30)];
        [self.loginButton setFrame:CGRectMake(205, 300, 380, 55)];
    }
    
    self.portalTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    self.portalTextField.text = potalString;
    self.userNameTextField.text = nameString;
    self.passwordTextField.text = passwordString;
    
    NSString *potalRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    DBValidationRegexRule *regexRule = [[DBValidationRegexRule alloc] initWithObject:self.portalTextField keyPath:@"text" regex:potalRegex failureMessage:@"无法解析服务器地址"];
    [self.portalTextField addValidationRule:regexRule];
    self.loginButton.enabled = YES;
    
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.portalTextField];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.errorLabel];
    
}

- (void)lgoinSuccessNotification:(NSNotification*)notify{
    CategoryViewController *category = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    [self presentViewController:category animated:NO completion:nil];
}


-(void) signFeildNotification :(NSNotification *)notify{
    [self loginUserinterface:YES];
}

- (void)logOutNotification:(NSNotification*)notify{
    VidyoClientInEventLogIn event = {0};
    
    NSString *userPortal = self.portalTextField.text;
    NSString *userPortalString = [NSString stringWithFormat:@"http://%@",userPortal];
    NSString *userVName = self.userNameTextField.text;
    NSString *userVPass = self.passwordTextField.text;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userPortal forKey:@"potal"];
    [defaults setObject:userVName forKey:@"username"];
    [defaults setObject:userVPass forKey:@"password"];
    [defaults synchronize];
    
    strlcpy(event.portalUri, [userPortalString UTF8String], sizeof(event.portalUri));
    strlcpy(event.userName, [userVName UTF8String], sizeof(event.userName));
    strlcpy(event.userPass, [userVPass UTF8String], sizeof(event.userPass));
    
    
    if (!VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_SIGNOFF, &event, sizeof(VidyoClientInEventLogIn)) == false)
    {
        [self.view removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)signOutNotification:(NSNotification*)notify{
    UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"您的账号在别处登录" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    myalert.delegate = self;
    [myalert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
}


- (void)signInErrNotification:(NSNotification*)notify{
    
    UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"potal地址错误" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    myalert.delegate = self;
    [myalert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
//    VCLoginViewController *vc = [[VCLoginViewController alloc] initWithNibName:@"VCLoginViewController" bundle:nil];
//    [[[UIApplication sharedApplication] keyWindow] performSelectorOnMainThread:@selector(setRootViewController:) withObject:vc waitUntilDone:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.portalTextField) {
        [self.userNameTextField becomeFirstResponder];
    } else if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
        [self login];
    }
    return YES;
}
- (void)viewDidUnload
{
    [self setPortalTextField:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [self setErrorLabel:nil];
    [self setLandscape:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (IBAction)loginClicked:(id)sender
{
    if ([CheckNetwork isExistenceNetwork]) {
        [self loginUserinterface:NO];
        [self login];
    }
    else{
        [self loginUserinterface:YES];
    }
    [self.portalTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (void)loginClient:(NSString *)soapMessage
{
    [SVProgressHUD show];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/v1_1/VidyoPortalUserService?wsdl",self.portalTextField.text];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", self.userNameTextField.text, self.passwordTextField.text] base64];
    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    
    theRequest.delegate = self;
    [theRequest addRequestHeader:@"Authorization" value:auth];
    [theRequest addRequestHeader:@"Host" value:[url host]];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    [theRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithSuccess:@"登陆成功"];
    [self myTask];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"登陆失败"];
    [self errorTask];
}

- (void)errorTask {
    // Do something usefull in here instead of sleeping ...
    [_errorLabel setText:kLoginFailedTitle];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    
    VidyoClientInEventLogIn event = {0};
    
    NSString *userPortal = self.portalTextField.text;
    NSString *userPortalString = [NSString stringWithFormat:@"http://%@",userPortal];
    NSString *userVName = self.userNameTextField.text;
    NSString *userVPass = self.passwordTextField.text;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userPortal forKey:@"potal"];
    [defaults setObject:userVName forKey:@"username"];
    [defaults setObject:userVPass forKey:@"password"];
    [defaults synchronize];
    
    strlcpy(event.portalUri, [userPortalString UTF8String], sizeof(event.portalUri));
    strlcpy(event.userName, [userVName UTF8String], sizeof(event.userName));
    strlcpy(event.userPass, [userVPass UTF8String], sizeof(event.userPass));
    
    if (VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_LOGIN, &event, sizeof(VidyoClientInEventLogIn)) == false)
    {
        CategoryViewController *category = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        [self presentViewController:category animated:NO completion:nil];
    }
    [_errorLabel setText:@""];
    
}

- (void)login
{
    NSMutableArray *failureMessages = [NSMutableArray array];
    NSArray *textFields = @[self.portalTextField];
    for (id object in textFields) {
        [failureMessages addObjectsFromArray:[object validate]];
    }
    
    if (failureMessages.count > 0) {
        [_errorLabel setText:[failureMessages componentsJoinedByString:@"\n"]];
    } else {
        
        [self.view endEditing:TRUE];
        
//        NSString *loginMessage = [NSString stringWithFormat:
//                                  @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
//                                  "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user/v1_1/\">"
//                                  "<env:Body>"
//                                  "<ns1:LogInRequest>"
//                                  "<ns1:ClientType>I</ns1:ClientType>"
//                                  "</ns1:LogInRequest>"
//                                  "</env:Body>"
//                                  "</env:Envelope>"];
//        
//        [self loginClient:loginMessage];
        
        [SVProgressHUD show];
        VidyoClientInEventLogIn event = {0};
        
        NSString *userPortal = self.portalTextField.text;
        NSString *userPortalString = [NSString stringWithFormat:@"http://%@",userPortal];
        NSString *userVName = self.userNameTextField.text;
        NSString *userVPass = self.passwordTextField.text;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userPortal forKey:@"potal"];
        [defaults setObject:userVName forKey:@"username"];
        [defaults setObject:userVPass forKey:@"password"];
        [defaults synchronize];
        
        strlcpy(event.portalUri, [userPortalString UTF8String], sizeof(event.portalUri));
        strlcpy(event.userName, [userVName UTF8String], sizeof(event.userName));
        strlcpy(event.userPass, [userVPass UTF8String], sizeof(event.userPass));

        
        if (VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_LOGIN, &event, sizeof(VidyoClientInEventLogIn)) == false)
        {
           
        } else {
            isSigningIn = TRUE;
        }
        
        [_errorLabel setText:@""];
    }
}

-(void) loginUserinterface: (BOOL)isbool{
    self.portalTextField.userInteractionEnabled = isbool;
    self.passwordTextField.userInteractionEnabled = isbool;
    self.userNameTextField.userInteractionEnabled = isbool;
    self.loginButton.userInteractionEnabled = isbool;
}

@end
