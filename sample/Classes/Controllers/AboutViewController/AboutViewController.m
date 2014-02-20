//
//  AboutViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-7-25.
//
//

#import "AboutViewController.h"
#import "VCFoundation.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 680, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:kDoneButtonTitle
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(leftButtonClicked)];
//    [navigationItem setTitle:@"关于"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
}

- (void)leftButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
