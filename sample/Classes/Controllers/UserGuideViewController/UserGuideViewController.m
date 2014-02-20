//
//  UserGuideViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-8-28.
//
//

#import "UserGuideViewController.h"
#import "VCLoginViewController.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (IBAction)confimClick:(id)sender {
    VCLoginViewController *loginViewController = [[VCLoginViewController alloc] initWithNibName:@"VCLoginViewController" bundle:nil];
    loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginViewController animated:YES completion:nil];
}
@end
