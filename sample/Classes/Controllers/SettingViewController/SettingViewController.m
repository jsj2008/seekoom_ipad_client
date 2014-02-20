//
//  SettingViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-3-18.
//
//

#import "SettingViewController.h"
#import "VCLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+Base64.h"
#import "GDataXMLNode.h"
#import "VidyoClient.h"
#import "VCFoundation.h"
#import "VidyoClientSample_iOS_AppDelegate.h"


@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize cameraSwitch = _cameraSwitch, microphoneSwitch = _microphoneSwitch, backgroundSwitch = _backgroundSwitch, networkSwitch = _networkSwitch, autoSwitch = _autoSwitch;

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
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 512, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"logout_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 50, 30);
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:kDoneButtonTitle
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(leftButtonClicked)];
    [navigationItem setTitle:kSettingsTitle];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setRightBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    UIButton *loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOutButton setBackgroundImage:[UIImage imageNamed:@"iphone_logout_button.png"] forState:UIControlStateNormal];
    [loginOutButton setTitle:kLogoutTitle forState:UIControlStateNormal];
    [loginOutButton setFrame:CGRectMake(35, 450, 450, 44)];
    [loginOutButton addTarget:self
                       action:@selector(loginoutClicked)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:loginOutButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
	NSUserDefaults *cameraUserDefault = [NSUserDefaults standardUserDefaults];
	_cameraSwitchIsOnOff = [cameraUserDefault integerForKey:@"cameraUserDefaultKey"];
    
    NSUserDefaults *microphoneUserDefault = [NSUserDefaults standardUserDefaults];
	_microphoneSwitchIsOnOff = [microphoneUserDefault integerForKey:@"microphoneUserDefaultKey"];
    
    NSUserDefaults *backgroundUserDefault = [NSUserDefaults standardUserDefaults];
	_backgroundSwitchIsOnOff = [backgroundUserDefault integerForKey:@"backgroundUserDefaultKey"];
    
    NSUserDefaults *networkUserDefault = [NSUserDefaults standardUserDefaults];
	_networkSwitchIsOnOff = [networkUserDefault integerForKey:@"networkUserDefaultKey"];
    
    NSUserDefaults *autoUserDefault = [NSUserDefaults standardUserDefaults];
	_autoSwitchIsOnOff = [autoUserDefault integerForKey:@"autoUserDefaultKey"];
    
    self.cameraSwitch = [[UISwitch alloc] init];
	self.cameraSwitch.on=(_cameraSwitchIsOnOff == 1) ? NO : YES;
	[self.cameraSwitch addTarget:self action:@selector(cameraSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.microphoneSwitch = [[UISwitch alloc] init];
	self.microphoneSwitch.on=(_microphoneSwitchIsOnOff == 1) ? NO : YES;
	[self.microphoneSwitch addTarget:self action:@selector(microphoneSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.backgroundSwitch = [[UISwitch alloc] init];
	self.backgroundSwitch.on=(_backgroundSwitchIsOnOff == 1) ? NO : YES;
	[self.backgroundSwitch addTarget:self action:@selector(backgroundSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.networkSwitch = [[UISwitch alloc] init];
    self.networkSwitch.on = NO;
	self.networkSwitch.on = (_networkSwitchIsOnOff == 1) ? NO : YES;
	[self.networkSwitch addTarget:self action:@selector(netoworkSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.autoSwitch = [[UISwitch alloc] init];
	self.autoSwitch.on = YES;
    self.autoSwitch.on = (_autoSwitchIsOnOff == 1) ? NO : YES;
	[self.autoSwitch addTarget:self action:@selector(autoSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)cameraSwitchAction:(id)sender
{
	_cameraSwitchIsOnOff = ([sender isOn] == 1) ? 0 : 1;
	
	NSUserDefaults *cameraUserDefault = [NSUserDefaults standardUserDefaults];
	[cameraUserDefault setInteger:_cameraSwitchIsOnOff forKey:@"cameraUserDefaultKey"];
}

-(void)microphoneSwitchAction:(id)sender
{
	_microphoneSwitchIsOnOff = ([sender isOn] == 1) ? 0 : 1;
	
	NSUserDefaults *microphoneUserDefault = [NSUserDefaults standardUserDefaults];
	[microphoneUserDefault setInteger:_microphoneSwitchIsOnOff forKey:@"microphoneUserDefaultKey"];
}

-(void)backgroundSwitchAction:(id)sender
{
	_backgroundSwitchIsOnOff = ([sender isOn] == 1) ? 0 : 1;
	
	NSUserDefaults *backgroundUserDefault = [NSUserDefaults standardUserDefaults];
	[backgroundUserDefault setInteger:_backgroundSwitchIsOnOff forKey:@"backgroundUserDefaultKey"];
}

-(void)autoSwitchAction:(id)sender
{
	_autoSwitchIsOnOff = ([sender isOn] == 1) ? 0 : 1;
	
	NSUserDefaults *autoUserDefault = [NSUserDefaults standardUserDefaults];
	[autoUserDefault setInteger:_autoSwitchIsOnOff forKey:@"autoUserDefaultKey"];
}

-(void)netoworkSwitchAction:(id)sender
{
	_networkSwitchIsOnOff = ([sender isOn] ==1) ? 0 : 1;
	
	NSUserDefaults *networkUserDefault = [NSUserDefaults standardUserDefaults];
	[networkUserDefault setInteger:_networkSwitchIsOnOff forKey:@"networkUserDefaultKey"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kDeviceSettingTitle;
    }
    else if (section == 1) {
        return kBackgroundingTitle;
    } else if (section == 2) {
        return kNetworkSettingTitle;
    }
    return NULL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        case 2:
            return 1;
    }
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    static NSString *cellIdentifier2 = @"Cell2";
	UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    static NSString *cellIdentifier3 = @"Cell3";
	UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    
    if (nil == cell2)
	{
		cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
	}
    
    if (nil == cell3)
	{
		cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
	}
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.accessoryView = _cameraSwitch;
                cell.textLabel.text = kCameraTitle;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if (indexPath.row == 1) {
                cell.accessoryView = _microphoneSwitch;
                cell.textLabel.text = kMicrophoneTitle;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if (indexPath.row == 2) {
                cell.accessoryView = _autoSwitch;
                cell.textLabel.text = kAutoAnswerSwitchTitle;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
            return cell;
        case 1:
        {
            if (indexPath.row == 0) {
                cell2.accessoryView = _backgroundSwitch;
                cell2.textLabel.textAlignment = NSTextAlignmentLeft;
                cell2.textLabel.text = kBackgroundSwitchTitle;
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
            return cell2;
        case 2:
        {
            if (indexPath.row == 0) {
                cell3.accessoryView = _networkSwitch;
                cell3.textLabel.textAlignment = NSTextAlignmentLeft;
                cell3.textLabel.text = kVidyoProxyButtonTitle;
                cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
            return cell3;
    }
    return nil;
}

- (void)leftButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
- (void)loginoutClicked
{
    VidyoClientInEventLogIn event = {0};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    strlcpy(event.portalUri, [potalString UTF8String], sizeof(event.portalUri));
    strlcpy(event.userName, [nameString UTF8String], sizeof(event.userName));
    strlcpy(event.userPass, [passwordString UTF8String], sizeof(event.userPass));
    
    
    if (!VidyoClientSendEvent(VIDYO_CLIENT_IN_EVENT_SIGNOFF, &event, sizeof(VidyoClientInEventLogIn)) == false)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        VCLoginViewController *vc = [[VCLoginViewController alloc] initWithNibName:@"VCLoginViewController" bundle:nil];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    }
}



- (void)logOutClient:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl",potalString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    
    [theRequest addRequestHeader:@"Authorization" value:auth];
    [theRequest addRequestHeader:@"Host" value:[url host]];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeOutSeconds:60.0];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    
    NSError *error = [theRequest error];
    if (error) {
        return;
    } else {
        
    }
}
@end
