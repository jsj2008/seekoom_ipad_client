//
//  CategoryViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-7-1.
//
//

#import "CategoryViewController.h"
#import "FrontViewController.h"
#import "joinConferenceViewController.h"
#import "MBProgressHUD.h"
#import "VCFoundation.h"
#import "WelcomeViewController.h"



@implementation CategoryViewController
@synthesize imageView = _imageView;
@synthesize inviteButton = _inviteButton;
@synthesize joinButton = _joinButton;
@synthesize exitButton = _exitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.view.bounds = CGRectMake(0, 0, 1024, 768);
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.inviteButton setFrame:CGRectMake(180, 300, 150, 315)];
        [self.joinButton setFrame:CGRectMake(690, 300, 150, 315)];
        [self.exitButton setFrame:CGRectMake(950, 700, 50, 50)];
    } else  {
        self.view.bounds = CGRectMake(0, 0, 768, 1024);
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.inviteButton setFrame:CGRectMake(325, 120, 150, 315)];
        [self.joinButton setFrame:CGRectMake(325, 520, 150, 315)];
        [self.exitButton setFrame:CGRectMake(700, 950, 50, 50)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.inviteButton setFrame:CGRectMake(180, 300, 150, 315)];
        [self.joinButton setFrame:CGRectMake(690, 300, 150, 315)];
        [self.exitButton setFrame:CGRectMake(950, 700, 50, 50)];
    } else {
        //shu
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.inviteButton setFrame:CGRectMake(325, 120, 150, 315)];
        [self.joinButton setFrame:CGRectMake(325, 520, 150, 315)];
        [self.exitButton setFrame:CGRectMake(700, 950, 50, 50)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_secondimage_landscape.png"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signedOutNotificaion:)
												 name:@"SignedOut" object:nil];
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.imageView setImage:[UIImage imageNamed:@"ipad_secondimage_landscape.png"]];
    
    self.inviteButton = [[UIButton alloc] init];
    [self.inviteButton setTitleColor:[UIColor colorWithRed:0.f/255.f green:167.f/255.f blue:238.f/255.f alpha:1] forState:UIControlStateNormal];
    [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"ipad_invitebackground.png"] forState:UIControlStateNormal];
    [self.inviteButton setTitle:kInviteConferenceTitle forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteConferenceClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.joinButton = [[UIButton alloc] init];
    [self.joinButton.titleLabel setTextColor:[UIColor blueColor]];
    [self.joinButton setTitle:kJoinConferenceTitle forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor colorWithRed:0.f/255.f green:167.f/255.f blue:238.f/255.f alpha:1] forState:UIControlStateNormal];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"ipad_joinbackground.png"] forState:UIControlStateNormal];
    [self.joinButton addTarget:self action:@selector(joinConferenceClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setImage:[UIImage imageNamed:@"enter_2.png"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.view.bounds = CGRectMake(0, 0, 1024, 768);
        [self.imageView setFrame:CGRectMake(0, 0, 1024, 768)];
        [self.inviteButton setFrame:CGRectMake(180, 300, 150, 315)];
        [self.joinButton setFrame:CGRectMake(690, 300, 150, 315)];
        [self.exitButton setFrame:CGRectMake(950, 700, 50, 50)];
    } else  {
        self.view.bounds = CGRectMake(0, 0, 768, 1024);
        [self.imageView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.inviteButton setFrame:CGRectMake(325, 120, 150, 315)];
        [self.joinButton setFrame:CGRectMake(325, 520, 150, 315)];
        [self.exitButton setFrame:CGRectMake(700, 950, 50, 50)];
    }
    
//    [self.view setAutoresizesSubviews:UIViewAutoresizingNone];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.inviteButton];
    [self.view addSubview:self.joinButton];
    [self.view addSubview:self.exitButton];
    

}


- (void)signedOutNotificaion:(NSNotification*)notify
{
//        VCLoginViewController *vc = [[VCLoginViewController alloc] initWithNibName:@"VCLoginViewController" bundle:nil];
//        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitButtonClick
{
    [self dismissViewControllerAnimated:NO completion:nil];

//    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
//    [self presentViewController:welcomeViewController animated:YES completion:nil];
}

- (IBAction)inviteConferenceClick:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)joinConferenceClick:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    [HUD showWhileExecuting:@selector(myMixedTask1) onTarget:self withObject:nil animated:YES];
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

- (void)myMixedTask
{
    FrontViewController *front = [[FrontViewController alloc] initWithNibName:@"FrontViewController_iPad" bundle:nil];
    front.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:front animated:YES completion:nil];
    
//    inviteConferenceViewController *front = [[inviteConferenceViewController alloc] initWithNibName:@"inviteConferenceViewController" bundle:nil];
//    front.modalPresentationStyle = UIModalPresentationFullScreen;
//    front.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:front animated:YES completion:nil];
//    [front release];
    
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = kConnectLoading;
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.05f;
        HUD.progress = progress;
        usleep(50000);
    }
}

- (void)myMixedTask1 {
    // Indeterminate mode
    joinConferenceViewController *join = [[joinConferenceViewController alloc] initWithNibName:@"joinConferenceViewController" bundle:nil];
    join.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:join animated:YES completion:nil];
    
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = kConnectLoading;
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.05f;
        HUD.progress = progress;
        usleep(50000);
    }
    
}

@end
