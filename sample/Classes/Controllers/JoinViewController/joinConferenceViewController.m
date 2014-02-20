//
//  joinConferenceViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-7-4.
//
//

#import "joinConferenceViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "NSString+Base64.h"
#import "Members.h"
#import "GDataXMLNode.h"
#import <QuartzCore/QuartzCore.h>
#import "VidyoClientSample_iOS_AppDelegate.h"
#import "SearchCoreManager.h"
#import "Users.h"
#import "VCFoundation.h"
#import "FPPopoverController.h"
#import "DemoViewController.h"
#import "VidyoClient.h"
#import "SettingViewController.h"
#import "ILBarButtonItem.h"
#import "AboutViewController.h"
#import "CategoryViewController.h"
#import "CQMFloatingController.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "CheckNetwork.h"
#import "SVProgressHUD.h"

#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0)


@interface joinConferenceViewController ()

@end

@implementation joinConferenceViewController
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize isLockLabel = _isLockLabel;
@synthesize linkButton = _linkButton;
@synthesize aboutButton = _aboutButton;
@synthesize pinTextField = _pinTextField;
@synthesize pinJoinButton = _pinJoinButton;
@synthesize imageView = _imageView;
@synthesize entity = _entity;
@synthesize workingMember = _workingMember;
@synthesize workingContacts = _workingContacts;
@synthesize entityID = _entityID;
@synthesize pinPassword = _pinPassword;
@synthesize mObject = _mObject;
@synthesize searchByName = _searchByName;
@synthesize contactDic = _contactDic;
@synthesize offlineContactDic = _offlineContactDic;
@synthesize searchByPhone = _searchByPhone;
@synthesize myEntityID = _myEntityID;
@synthesize parserSearch;
@synthesize entityIDString = _entityIDString;
@synthesize roomURLString = _roomURLString;
@synthesize navigationBar = _navigationBar;
@synthesize joinButton = _joinButton;
@synthesize displayNameLabel = _displayNameLabel;
@synthesize extensionLabel = _extensionLabel;
@synthesize roomDic = _roomDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchCoreMember Reset];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [_navigationBar setFrame:CGRectMake(0, 20, 1024, 44)];
            [self.tableView setFrame:CGRectMake(0, 108, 280, 660)];
            [self.imageView setFrame:CGRectMake(280, 65, 745, 712)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(500, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(550, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(860, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [_navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
            [self.tableView setFrame:CGRectMake(0, 88, 280, 680)];
            [self.imageView setFrame:CGRectMake(280, 45, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(500, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(550, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(860, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        }
    } else {
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [_navigationBar setFrame:CGRectMake(0, 20, 768, 44)];
            [self.tableView setFrame:CGRectMake(0, 108, 280, 916)];
            [self.imageView setFrame:CGRectMake(280, 65, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(400, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(450, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(625, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [_navigationBar setFrame:CGRectMake(0, 0, 768, 44)];
            [self.tableView setFrame:CGRectMake(0, 88, 280, 936)];
            [self.imageView setFrame:CGRectMake(280, 45, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(400, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(450, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(625, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [NSThread detachNewThreadSelector:@selector(myTaskMethod) toTarget:self withObject:nil];
}

- (void)myTaskMethod
{
    @autoreleasepool {
        
        NSString *searchMemberMessage = [NSString stringWithFormat:
                                         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                         "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                         "<env:Body>"
                                         "<ns1:SearchRequest>"
                                         "<ns1:Filter>"
                                         "<ns1:limit>999</ns1:limit>"
                                         "<ns1:query>*</ns1:query>"
                                         "</ns1:Filter>"
                                         "</ns1:SearchRequest>"
                                         "</env:Body>"
                                         "</env:Envelope>"];
        [self searchMember:searchMemberMessage];
        
        NSString *searchRoomMessage = [NSString stringWithFormat:
                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                       "<env:Body>"
                                       "<ns1:SearchRequest>"
                                       "<ns1:Filter>"
                                       "<ns1:EntityType>Room</ns1:EntityType>"
                                       "</ns1:Filter>"
                                       "</ns1:SearchRequest>"
                                       "</env:Body>"
                                       "</env:Envelope>"];
        
        [self searchRoom:searchRoomMessage];
        
//        NSString *searchRoom = [NSString stringWithFormat:
//                                @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                                "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"
//                                "<soap:Body>"
//                                "<GetInviteContent xmlns=\"http://util.user.vidyo.com\">"
//                                "<in0>v.seekoom.com</in0>"
//                                "<GetTaskList xmlns=\"http://tempuri.org/\">"
//                                "<in1>lee</in1>"
//                                "<in2>111111</in2>"
//                                "</GetInviteContent>"
//                                "</soap:Body>"
//                                "</soap:Envelope>"];
//        
//        [self searchRoomPIN:searchRoom];

        NSString *getInviteContentMessage = [NSString stringWithFormat:
                                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                             "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user/v1_1\">"
                                             "<env:Body>"
                                             "<ns1:GetInviteContentRequest/>"
                                             "</env:Body>"
                                             "</env:Envelope>"];

        [self getInviteContent:getInviteContentMessage];
        
        
        [self.tableView reloadData];
    }
}


- (void)getInviteContent:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/v1_1/VidyoPortalUserService?wsdl", potalString];
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
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    
    [theRequest startSynchronous];

    NSString *responseString = [theRequest responseString];
    NSLog(@"%@",responseString);
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user/v1_1",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:GetInviteContentResponse" namespaces:mapping error:&error];
    
    if (error) {
        return;
    } else {

        for (GDataXMLElement *displayName in items) {
            GDataXMLElement *contentTypeElement = [[displayName elementsForName:@"ns1:content"] objectAtIndex:0];
            NSString *contentString = [contentTypeElement stringValue];
            self.contentString = contentString;
            
            
        }
    }
}


-(NSString*) getStringOfBody:(NSString *)body withStrart:(NSString *)startString withSub:(int)startStringSub withEnd:(NSString *)endString
{
    NSRange a,b;
    NSString *temp;
    a = [body rangeOfString:startString];
    if (a.location != NSNotFound ) {
        temp = [body substringFromIndex:(a.location + startStringSub)];
        if (b.location != NSNotFound)
        {
            if ([endString isEqual:@""])
            {
                return temp;
            }
            b = [temp rangeOfString:endString];
            return [temp substringToIndex:b.location];
        }
    }
    return @"";
}

- (void)searchRoomPIN:(NSString *)soapMessage
{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *potalString = [defaults objectForKey:@"potal"];
    //    NSString *nameString = [defaults objectForKey:@"username"];
    //    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.seekoom.com/VidyoUserUtilService/services/VidyoUserUtilServicePort"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
    //    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    
    //    [theRequest addRequestHeader:@"Authorization" value:auth];
//    [theRequest addRequestHeader:@"Host" value:[url host]];
//    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
//    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    
    [theRequest startSynchronous];
    
    NSString *responseString = [theRequest responseString];
    NSLog(@"%@",responseString);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchCoreMember = [[SearchCoreManager alloc] init];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_secondimage_landscape.png"]]];
    
    self.tableView = [[UITableView alloc] init];
    
    self.linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.linkButton setTitle:kRoomLinkTitle forState:UIControlStateNormal];
    [self.linkButton addTarget:self action:@selector(roomLickClick:) forControlEvents:UIControlEventTouchUpInside];
    self.linkButton.hidden = YES;
    
    self.imageView = [[UIImageView alloc] init];
    
    self.displayNameLabel = [[UILabel alloc] init];
    [self.displayNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.displayNameLabel setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    
    self.extensionLabel = [[UILabel alloc] init];
    [self.extensionLabel setBackgroundColor:[UIColor clearColor]];
    [self.extensionLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    self.isLockLabel = [[UILabel alloc] init];
    [self.isLockLabel setBackgroundColor:[UIColor clearColor]];
    [self.isLockLabel setTextColor:[UIColor redColor]];
    [self.isLockLabel setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    [self.isLockLabel setText:@""];
    
    self.pinTextField = [[UITextField alloc] init];
    self.pinTextField.secureTextEntry = YES;
    [self.pinTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    self.pinJoinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pinJoinButton setTitle:kJoinConferenceTitle forState:UIControlStateNormal];
    [self.pinJoinButton addTarget:self action:@selector(pinJoinClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.aboutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.aboutButton addTarget:self action:@selector(aboutClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.joinButton = [[UIButton alloc] init];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"ipad_button.png"] forState:UIControlStateNormal];
    [self.joinButton setTitle:kJoinConferenceTitle forState:UIControlStateNormal];
    [self.joinButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.joinButton addTarget:self action:@selector(joinConferenceClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 280, 44)];
        [self.searchBar setBarTintColor:[UIColor clearColor]];
    } else {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 280, 44)];
    }
    [self.searchBar setBackgroundColor:[UIColor lightGrayColor]];
    self.searchBar.placeholder = kSearchRoomPlacHold;
    
    self.navigationBar = [[UINavigationBar alloc] init];
    [_navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
    
    UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:kJoinConferenceTitle];
    [_navigationBar setTintColor:[UIColor whiteColor]];
    [_navigationBar pushNavigationItem:NavTitle animated:YES];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_image.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:_navigationBar];
    
    ILBarButtonItem *backBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"ipad_setting.png"]
                        selectedImage:[UIImage imageNamed:@"ipad_setting.png"]
                               target:self
                               action:@selector(backBUttonClick)];
    
    NavTitle.leftBarButtonItem = backBtn;
    
    /* Right bar button item */
    ILBarButtonItem *settingsBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"ipad_back.png"]
                        selectedImage:[UIImage imageNamed:@"ipad_back.png"]
                               target:self
                               action:@selector(settingButtonClick)];
    
    NavTitle.rightBarButtonItem = settingsBtn;
    
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.height, self.tableView.bounds.size.width)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [_navigationBar setFrame:CGRectMake(0, 20, 1024, 44)];
            [self.tableView setFrame:CGRectMake(0, 108, 280, 660)];
            [self.imageView setFrame:CGRectMake(280, 65, 745, 712)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(500, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(550, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(860, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [_navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
            [self.tableView setFrame:CGRectMake(0, 88, 280, 680)];
            [self.imageView setFrame:CGRectMake(280, 45, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(500, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(550, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(860, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        }
    } else {
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [_navigationBar setFrame:CGRectMake(0, 20, 768, 44)];
            [self.tableView setFrame:CGRectMake(0, 108, 280, 916)];
            [self.imageView setFrame:CGRectMake(280, 65, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(400, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(450, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(625, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [_navigationBar setFrame:CGRectMake(0, 0, 768, 44)];
            [self.tableView setFrame:CGRectMake(0, 88, 280, 936)];
            [self.imageView setFrame:CGRectMake(280, 45, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.displayNameLabel setFrame:CGRectMake(400, 250, 290, 45)];
            [self.extensionLabel setFrame:CGRectMake(400, 290, 290, 45)];
            [self.isLockLabel setFrame:CGRectMake(400, 310, 435, 45)];
            [self.pinTextField setFrame:CGRectMake(400, 360, 200, 30)];
            [self.pinJoinButton setFrame:CGRectMake(650, 355, 80, 44)];
            [self.joinButton setFrame:CGRectMake(450, 400, 180, 44)];
            [self.linkButton setFrame:CGRectMake(625, 115, 130, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        }
    }
    
    NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
    self.contactDic = conDic;
    
    self.roomDic = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *nameIDArray = [[NSMutableArray alloc] init];
    self.searchByName = nameIDArray;
    
    NSString *myAccountMessage = [NSString stringWithFormat:
                                  @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                  "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                  "<env:Body>"
                                  "<ns1:MyAccountRequest>"
                                  "</ns1:MyAccountRequest>"
                                  "</env:Body>"
                                  "</env:Envelope>"];
    [self myAccount:myAccountMessage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.pinTextField.delegate = self;
    [self.view addSubview:_tableView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.pinTextField];
    [self.view addSubview:self.displayNameLabel];
    [self.view addSubview:self.extensionLabel];
    [self.view addSubview:_searchBar];
    [self.view addSubview:self.joinButton];
    [self.view addSubview:self.linkButton];
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.isLockLabel];
    [self.view addSubview:self.pinJoinButton];
    
    self.pinTextField.hidden = YES;
    self.pinJoinButton.hidden = YES;
    self.mycopyButton.hidden = YES;
    
}

- (void)backBUttonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingButtonClick
{
    SettingViewController *setting = [[SettingViewController alloc] init];
    setting.modalPresentationStyle = UIModalPresentationFormSheet;
    setting.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:setting animated:YES completion:nil];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        setting.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 2, self.view.superview.frame.size.width / 1.5);
        setting.view.superview.center = CGPointMake(setting.view.superview.frame.size.width, setting.view.superview.frame.size.height - 150);
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        setting.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 2, self.view.superview.frame.size.width / 1.5);
        setting.view.superview.center = CGPointMake(setting.view.superview.frame.size.width - 120, setting.view.superview.frame.size.height);
    }
}

- (void)searchMember:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    
    [theRequest startSynchronous];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:SearchResponse" namespaces:mapping error:&error];
    
    if (error) {
        return;
    } else {
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            parserObj = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (GDataXMLElement *name in names) {
                Members *onlineContact = [[Members alloc] init];
                _workingMember = [[Members alloc] init];
                
                GDataXMLElement *entityTypeElement = [[name elementsForName:@"ns1:EntityType"] objectAtIndex:0];
                NSString *entityTypeString = [entityTypeElement stringValue];
                
                GDataXMLElement *nameElement = [[name elementsForName:@"ns1:displayName"] objectAtIndex:0];
                NSString *nameString = [nameElement stringValue];
                
                GDataXMLElement *statusElement = [[name elementsForName:@"ns1:MemberStatus"] objectAtIndex:0];
                NSString *statusString = [statusElement stringValue];
                
                GDataXMLElement *extensionElement = [[name elementsForName:@"ns1:extension"] objectAtIndex:0];
                NSString *extensionString = [extensionElement stringValue];
                
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];
                
                GDataXMLElement *roomStatusElement = [[name elementsForName:@"ns1:RoomStatus"] objectAtIndex:0];
                NSString *roomStatusString = [roomStatusElement stringValue];
                
                NSArray *roomMode = [name elementsForName:@"ns1:RoomMode"];
                
                for (GDataXMLElement *room in roomMode) {
                    GDataXMLElement *isLockedElement = [[room elementsForName:@"ns1:isLocked"] objectAtIndex:0];
                    NSString *isLockedString = [isLockedElement stringValue];
                    
                    GDataXMLElement *hasPinElement = [[room elementsForName:@"ns1:hasPin"] objectAtIndex:0];
                    NSString *hasPinString = [hasPinElement stringValue];
                    
                    GDataXMLElement *roomPinElement = [[room elementsForName:@"ns1:roomPIN"] objectAtIndex:0];
                    NSString *roomPINString = [roomPinElement stringValue];
                    
                    self.workingMember.isLocked = isLockedString;
                    self.workingMember.hasPin = hasPinString;
                    self.workingMember.roomPin = roomPINString;
                    
                    onlineContact.isLocked = isLockedString;
                    onlineContact.hasPin = hasPinString;
                    onlineContact.roomPin = roomPINString;
                }
                
                self.workingMember.displayName = nameString;
                self.workingMember.status = statusString;
                self.workingMember.extension = extensionString;
                self.workingMember.entityID = entityIDString;
                self.workingMember.entityType = entityTypeString;
                self.workingMember.roomStatus = roomStatusString;
                [parserObj addObject:_workingMember];
                
                NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
                [format setNumberStyle:NSNumberFormatterNoStyle];
                onlineContact.localID = [format numberFromString:entityIDString];
                
                onlineContact.status = statusString;
                onlineContact.displayName = nameString;
                onlineContact.extension = extensionString;
                onlineContact.entityID = entityIDString;
                onlineContact.entityType = entityTypeString;
                onlineContact.roomStatus = roomStatusString;
                
                [self.contactDic setObject:onlineContact forKey:onlineContact.localID];
                [self.searchCoreMember AddContact:onlineContact.localID name:onlineContact.displayName phone:nil];
            }
        }
    }
}

- (void)searchRoom:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    
    [theRequest startSynchronous];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:SearchResponse" namespaces:mapping error:&error];
    
    if (error) {
        return;
    } else {
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
        
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            parserObj = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (GDataXMLElement *name in names) {
                Members *onlineContact = [[Members alloc] init];
                _workingMember = [[Members alloc] init];
                
                GDataXMLElement *entityTypeElement = [[name elementsForName:@"ns1:EntityType"] objectAtIndex:0];
                NSString *entityTypeString = [entityTypeElement stringValue];
                
                GDataXMLElement *nameElement = [[name elementsForName:@"ns1:displayName"] objectAtIndex:0];
                NSString *nameString = [nameElement stringValue];
                
                GDataXMLElement *statusElement = [[name elementsForName:@"ns1:MemberStatus"] objectAtIndex:0];
                NSString *statusString = [statusElement stringValue];
                
                GDataXMLElement *extensionElement = [[name elementsForName:@"ns1:extension"] objectAtIndex:0];
                NSString *extensionString = [extensionElement stringValue];
                
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];
                
                GDataXMLElement *roomStatusElement = [[name elementsForName:@"ns1:RoomStatus"] objectAtIndex:0];
                NSString *roomStatusString = [roomStatusElement stringValue];
                
                NSArray *roomMode = [name elementsForName:@"ns1:RoomMode"];
                
                for (GDataXMLElement *room in roomMode) {
                    GDataXMLElement *isLockedElement = [[room elementsForName:@"ns1:isLocked"] objectAtIndex:0];
                    NSString *isLockedString = [isLockedElement stringValue];
                    
                    GDataXMLElement *hasPinElement = [[room elementsForName:@"ns1:hasPIN"] objectAtIndex:0];
                    NSString *hasPinString = [hasPinElement stringValue];
                    
                    GDataXMLElement *roomPinElement = [[room elementsForName:@"ns1:roomPIN"] objectAtIndex:0];
                    NSString *roomPINString = [roomPinElement stringValue];
                    
                    self.workingMember.isLocked = isLockedString;
                    self.workingMember.hasPin = hasPinString;
                    self.workingMember.roomPin = roomPINString;
                    
                    onlineContact.isLocked = isLockedString;
                    onlineContact.hasPin = hasPinString;
                    onlineContact.roomPin = roomPINString;
                }
                
                self.workingMember.displayName = nameString;
                self.workingMember.status = statusString;
                self.workingMember.extension = extensionString;
                self.workingMember.entityID = entityIDString;
                self.workingMember.entityType = entityTypeString;
                self.workingMember.roomStatus = roomStatusString;
                [parserObj addObject:_workingMember];
                
                NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
                [format setNumberStyle:NSNumberFormatterNoStyle];
                onlineContact.localID = [format numberFromString:entityIDString];
                
                onlineContact.status = statusString;
                onlineContact.displayName = nameString;
                onlineContact.extension = extensionString;
                onlineContact.entityID = entityIDString;
                onlineContact.entityType = entityTypeString;
                onlineContact.roomStatus = roomStatusString;
                
                [self.roomDic setObject:onlineContact forKey:onlineContact.localID];
                [self.searchCoreMember AddContact:onlineContact.localID name:onlineContact.displayName phone:nil];
                
            }
        }
    }
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCoreMember  Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
}

- (void)doneLoadingTableViewData
{
    if ([CheckNetwork isExistenceNetwork]) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [self.contactDic removeAllObjects];
        [self.roomDic removeAllObjects];
        
        NSString *searchMemberMessage = [NSString stringWithFormat:
                                         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                         "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                         "<env:Body>"
                                         "<ns1:SearchRequest>"
                                         "<ns1:Filter>"
                                         "<ns1:limit>999</ns1:limit>"
                                         "<ns1:query>*</ns1:query>"
                                         "</ns1:Filter>"
                                         "</ns1:SearchRequest>"
                                         "</env:Body>"
                                         "</env:Envelope>"];
        [self searchMember:searchMemberMessage];
        
        NSString *searchRoomMessage = [NSString stringWithFormat:
                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                       "<env:Body>"
                                       "<ns1:SearchRequest>"
                                       "<ns1:Filter>"
                                       "<ns1:EntityType>Room</ns1:EntityType>"
                                       "</ns1:Filter>"
                                       "</ns1:SearchRequest>"
                                       "</env:Body>"
                                       "</env:Envelope>"];
        
        [self searchRoom:searchRoomMessage];
        [self.tableView reloadData];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logOut" object:nil];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if ( section == 1) {
        if ([self.searchBar.text length] <= 0) {
            return [self.contactDic count] + [self.roomDic count];
        } else {
            return [self.searchByName count] + [self.searchByPhone count];
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kMyRoomTitle;
    } else {
        return kRoomListTitle;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nameString = [defaults objectForKey:@"username"];
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [cell.textLabel.font fontWithSize:15];
    }
    
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
		cell2.textLabel.font = [cell2.textLabel.font fontWithSize:15];
    }
    
    
    if (indexPath.section == 0) {
        Members *con = [_entity objectAtIndex:indexPath.row];
        cell2.textLabel.text = con.displayName;
        
        if ([con.roomStatus isEqualToString:@"Occupied"]) {
            if ([con.hasPin isEqualToString:@"true"] && [con.isLocked isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
            } else if ([con.hasPin isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
            } else if ([con.isLocked isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
            } else {
                cell2.imageView.image = [UIImage imageNamed:@"RoomBusy@2x.png"];
            }
        } else {
            if ([con.hasPin isEqualToString:@"true"] && [con.isLocked isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
            } else if ([con.hasPin isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
            } else if ([con.isLocked isEqualToString:@"true"]) {
                cell2.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
            } else {
                cell2.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
            }
        }
        return cell2;
    }
    else if (indexPath.section == 1)
    {
        if ([self.searchBar.text length] <= 0)
        {
            NSArray *sortkeys = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.contactDic objectForKey:key]];
            }
            
            NSArray *roomSortkeys = [[self.roomDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *roomSortValues = [NSMutableArray array];
            for (NSString *key in roomSortkeys) {
                [roomSortValues addObject:[self.roomDic objectForKey:key]];
            }
            
            NSMutableArray *sortByRoom = [NSMutableArray array];
            
            for(int i = 0;i < [roomSortValues count]; i++){
                Members *member = [roomSortValues objectAtIndex:i];
                [sortByRoom addObject:member];
            }
            
            for (int i = 0; i < [sortValues count]; i++) {
                Members *roomMember = [sortValues objectAtIndex:i];
                [sortByRoom addObject:roomMember];
            }
            
            Members *contact = [sortByRoom objectAtIndex:indexPath.row];
            

            
            
            cell.textLabel.text = contact.displayName;
            cell.detailTextLabel.text = contact.extension;
            
            if ([contact.roomStatus isEqualToString:@"Occupied"]) {
                if ([contact.hasPin isEqualToString:@"true"] && [contact.isLocked isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                } else if ([contact.hasPin isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                } else if ([contact.isLocked isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"RoomBusy@2x.png"];
                }
            } else {
                if ([contact.hasPin isEqualToString:@"true"] && [contact.isLocked isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                } else if ([contact.hasPin isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                } else if ([contact.isLocked isEqualToString:@"true"]) {
                    cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
            }
            return cell;
            
            //            if (![contact.status isEqualToString:@"Offline"] || [contact.entityType isEqualToString:@"Room"] || [contact.roomStatus isEqualToString:@"Occupied"]) {
            //                cell.textLabel.text = contact.displayName;
            //                cell.detailTextLabel.text = contact.extension;
            //
            //                if ([contact.roomStatus isEqualToString:@"Occupied"]) {
            //                    cell.imageView.image = [UIImage imageNamed:@"RoomBusy@2x.png"];
            //                } else {
            //                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
            //                }
            //                return cell;
            //            }
        } else {
            NSNumber *localID = nil;
            NSString *formatString = nil;
            NSMutableString *matchString = [NSMutableString string];
            NSMutableArray *matchPos = [NSMutableArray array];
            
            if (indexPath.row < [_searchByName count]) {
                localID = [self.searchByName objectAtIndex:indexPath.row];
                
                if([self.searchBar.text length]) {
                    [self.searchCoreMember GetPinYin:localID pinYin:matchString matchPos:matchPos];
                    
                    NSNumberFormatter *numberf = [[NSNumberFormatter alloc] init];
                    formatString = [numberf stringFromNumber:localID];
                }
            }
            
            Members *mems = [self.roomDic objectForKey:localID];
            
            if (mems == nil) {
                mems = [self.contactDic objectForKey:localID];
            }
            
            if (![mems.status isEqualToString:@"Offline"] || [mems.entityType isEqualToString:@"Room"] || [mems.roomStatus isEqualToString:@"Occupied"]) {
                cell.textLabel.text = mems.displayName;
                cell.detailTextLabel.text = mems.extension;
                
                if ([mems.roomStatus isEqualToString:@"Occupied"]) {
                    if ([mems.hasPin isEqualToString:@"true"] && [mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                    } else if ([mems.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                    } else if ([mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomFullLock_2.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"RoomBusy@2x.png"];
                    }
                } else {
                    if ([mems.hasPin isEqualToString:@"true"] && [mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                    } else if ([mems.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                    } else if ([mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomLock_2@2x.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                    }
                }
                return cell;
            }
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        Members *myAccountMember = [_entity objectAtIndex:indexPath.row];
        _displayNameLabel.text = myAccountMember.displayName;
        _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,myAccountMember.extension];
        self.linkButton.hidden = NO;
        if ([myAccountMember.isLocked isEqualToString:@"true"] && [myAccountMember.hasPin isEqualToString:@"true"] && ![myAccountMember.entityID isEqualToString:self.myEntityID]) {
            self.isLockLabel.text = @"房间目前处在PIN码进入+锁定状态";
        } else if ([myAccountMember.isLocked isEqualToString:@"true"]) {
            self.isLockLabel.text = kRoomLockTitle;
        } else if ([myAccountMember.hasPin isEqualToString:@"true"]) {
            self.isLockLabel.text = kRoomHasPINTitle;
        } else {
            self.isLockLabel.text = @"";
        }
        self.joinButton.hidden = NO;
        self.pinJoinButton.hidden = YES;
        self.pinTextField.hidden = YES;
        self.entityID = myAccountMember.entityID;
    } else {
        if ([self.searchBar.text length] <= 0)
        {
            self.linkButton.hidden = YES;
            
            NSArray *sortkeys = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.contactDic objectForKey:key]];
            }
            
            NSArray *roomSortkeys = [[self.roomDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *roomSortValues = [NSMutableArray array];
            for (NSString *key in roomSortkeys) {
                [roomSortValues addObject:[self.roomDic objectForKey:key]];
            }
            
            NSMutableArray *sortByRoom = [NSMutableArray array];
            
            for(int i = 0;i < [roomSortValues count]; i++){
                Members *member = [roomSortValues objectAtIndex:i];
                [sortByRoom addObject:member];
            }
            
            for (int i = 0; i < [sortValues count]; i++) {
                Members *roomMember = [sortValues objectAtIndex:i];
                [sortByRoom addObject:roomMember];
            }
            
            Members *sortByRoomMembers = [sortByRoom objectAtIndex:indexPath.row];
            
            self.entityID = sortByRoomMembers.entityID;
            self.pinPassword = sortByRoomMembers.roomPin;
            
            _displayNameLabel.text = sortByRoomMembers.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,sortByRoomMembers.extension];
            
            
            if ([sortByRoomMembers.isLocked isEqualToString:@"true"] && [sortByRoomMembers.hasPin isEqualToString:@"true"] && ![sortByRoomMembers.entityID isEqualToString:self.myEntityID]) {
                self.isLockLabel.text = kroomStatusTitle;
                self.joinButton.hidden = YES;
                self.pinTextField.hidden = YES;
                self.pinJoinButton.hidden = YES;
            } else if ([sortByRoomMembers.isLocked isEqualToString:@"true"]) {
                self.isLockLabel.text = kroomStatusTitle;
                self.pinTextField.hidden = YES;
                self.joinButton.hidden = YES;
                self.pinJoinButton.hidden = YES;
            } else if ([sortByRoomMembers.hasPin isEqualToString:@"true"]) {
                self.isLockLabel.text = kIsLockLabel;
                self.joinButton.hidden = YES;
                self.pinTextField.hidden = NO;
                self.pinJoinButton.hidden = NO;
            } else {
                self.isLockLabel.text = @"";
                self.joinButton.hidden = NO;
                self.pinTextField.hidden = YES;
                self.pinJoinButton.hidden = YES;
            }
            
            if ([sortByRoomMembers.entityID isEqualToString:self.myEntityID]) {
                self.isLockLabel.text = @"";
                self.pinJoinButton.hidden = YES;
                self.pinTextField.hidden = YES;
                self.joinButton.hidden = NO;
            }
        } else {
            NSNumber *localID = nil;
            NSString *formatString = nil;
            NSMutableString *matchString = [NSMutableString string];
            NSMutableArray *matchPos = [NSMutableArray array];
            
            if (indexPath.row < [_searchByName count]) {
                localID = [self.searchByName objectAtIndex:indexPath.row];
                
                if([self.searchBar.text length]) {
                    [self.searchCoreMember GetPinYin:localID pinYin:matchString matchPos:matchPos];
                    
                    NSNumberFormatter *numberf = [[NSNumberFormatter alloc] init];
                    formatString = [numberf stringFromNumber:localID];
                }
            }
            
            Members *searchMembers = [self.contactDic objectForKey:localID];
            
            self.entityID = searchMembers.entityID;
            self.pinPassword = searchMembers.roomPin;
            
            _displayNameLabel.text = searchMembers.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,searchMembers.extension];
            
            if ([searchMembers.isLocked isEqualToString:@"true"] && [searchMembers.hasPin isEqualToString:@"true"]) {
                self.isLockLabel.text = kroomStatusTitle;
                self.joinButton.hidden = YES;
                self.pinTextField.hidden = YES;
                self.pinJoinButton.hidden = YES;
            } else if ([searchMembers.isLocked isEqualToString:@"true"]) {
                self.isLockLabel.text = kroomStatusTitle;
                self.pinTextField.hidden = YES;
                self.joinButton.hidden = YES;
                self.pinJoinButton.hidden = YES;
            } else if ([searchMembers.hasPin isEqualToString:@"true"]) {
                self.isLockLabel.text = kIsLockLabel;
                self.joinButton.hidden = YES;
                self.pinTextField.hidden = NO;
                self.pinJoinButton.hidden = NO;
            } else {
                self.isLockLabel.text = @"";
                self.joinButton.hidden = NO;
                self.pinTextField.hidden = YES;
                self.pinJoinButton.hidden = YES;
            }
        }
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

#pragma mark - Example Code

- (void)myAccount:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
    [theRequest setTimeOutSeconds:30.0];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:MyAccountResponse" namespaces:mapping error:&error];
    if (error) {
        return;
    } else {
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
        for (GDataXMLElement *displayName in items) {
            _entity = [[NSMutableArray alloc] initWithCapacity:0];
            _mObject = [[Members alloc] init];
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            
            for (GDataXMLElement *name in names) {
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];
                
                self.myAccoutString = entityIDString;
                
                GDataXMLElement *extensionElement = [[name elementsForName:@"ns1:extension"] objectAtIndex:0];
                NSString *extensionString = [extensionElement stringValue];
                
                GDataXMLElement *displayNameElement = [[name elementsForName:@"ns1:displayName"] objectAtIndex:0];
                NSString *displayNameString = [displayNameElement stringValue];
                
                GDataXMLElement *roomStatusElement = [[name elementsForName:@"ns1:RoomStatus"] objectAtIndex:0];
                NSString *roomStatusString = [roomStatusElement stringValue];
                
                NSArray *roomMode = [name elementsForName:@"ns1:RoomMode"];
                
                for (GDataXMLElement *room in roomMode) {
                    GDataXMLElement *roomURLElement = [[room elementsForName:@"ns1:roomURL"] objectAtIndex:0];
                    NSString *roomURLString = [roomURLElement stringValue];
                    self.roomURLString = roomURLString;
                    
                    GDataXMLElement *isLockedElement = [[room elementsForName:@"ns1:isLocked"] objectAtIndex:0];
                    NSString *isLockedString = [isLockedElement stringValue];
                    
                    GDataXMLElement *hasPinElement = [[room elementsForName:@"ns1:hasPin"] objectAtIndex:0];
                    NSString *hasPinString = [hasPinElement stringValue];
                    
                    GDataXMLElement *roomPinElement = [[room elementsForName:@"ns1:roomPin"] objectAtIndex:0];
                    NSString *roomPINString = [roomPinElement stringValue];
                    
                    self.mObject.isLocked = isLockedString;
                    self.mObject.hasPin = hasPinString;
                    self.mObject.roomPin = roomPINString;
                    
                }
                self.myEntityID = entityIDString;
                self.mObject.entityID = entityIDString;
                self.mObject.displayName = displayNameString;
                self.mObject.roomStatus = roomStatusString;
                self.mObject.extension = extensionString;
                [_entity addObject:self.mObject];
            }
        }
    }
}

- (void)inviteConfenceByEntityID:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
    if (!error) {
    }
}

- (void)joinConference:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
}

- (void)joinConferencePin:(NSString *)soapMessage
{
    [SVProgressHUD show];

    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *potalString = [defaults objectForKey:@"potal"];
        NSString *nameString = [defaults objectForKey:@"username"];
        NSString *passwordString = [defaults objectForKey:@"password"];
        
        NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
        [theRequest setTimeOutSeconds:15.0];
        [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
        
        [theRequest startSynchronous];
        NSError *error = [theRequest error];
    
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
        NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
        NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:JoinConferenceResponse" namespaces:mapping error:&error];

        if ([items count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"PIN码错误"
                              message:@"需要输入正确的PIN码才能进入会议室."
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"确定", nil];
        [alert show];
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD dismissWithSuccess:@"成功进入会议室"];
        }
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
        NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
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
            [theRequest setTimeOutSeconds:15.0];
            [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
            [theRequest startSynchronous];
    
            NSError *error = [theRequest error];
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:@"PIN码错误"
                                    message:@"需要输入正确的PIN码才能进入会议室. 是否重试?"
                                    delegate:self
                                    cancelButtonTitle:@"否"
                                    otherButtonTitles:@"是", nil];
                [alert show];
            }
    
            NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
            NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
            NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:JoinConferenceResponse" namespaces:mapping error:&error];
    
            for (GDataXMLElement *ok in items) {
                GDataXMLElement *okElement = [[ok elementsForName:@"ns1:OK"] objectAtIndex:0];
                NSString *okString = [okElement stringValue];
                if (![okString isEqualToString:@"OK"]) {
                    UIAlertView *alert = [[UIAlertView alloc]
                                        initWithTitle:@"PIN码错误"
                                        message:@"需要输入正确的PIN码才能进入会议室. 是否重试?"
                                        delegate:self
                                        cancelButtonTitle:@"否"
                                        otherButtonTitles:@"是", nil];
                                        [alert show];
                }
            }*/
}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSString *responseString = [request responseString];
//    NSLog(@"%@",responseString);
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    
//    NSString *responseString = [request responseString];
//    NSLog(@"%@",responseString);
//    [SVProgressHUD dismissWithSuccess:@"成功进入会议室" afterDelay:3.f];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)joinConferenceClick
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
    [_HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
    
    NSString *joinConferenceMessage = [NSString stringWithFormat:
                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                       "<env:Body>"
                                       "<ns1:JoinConferenceRequest>"
                                       "<ns1:conferenceID>%@</ns1:conferenceID>"
                                       "</ns1:JoinConferenceRequest>"
                                       "</env:Body>"
                                       "</env:Envelope>",self.entityID];
    
    [self joinConference:joinConferenceMessage];
}

- (void)myMixedTask
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = kJoinConferenceLoading;
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.05f;
        _HUD.progress = progress;
        usleep(100000);
    }
}

- (IBAction)aboutClicked:(id)sender {
    AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    about.modalPresentationStyle = UIModalPresentationFormSheet;
    about.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:about animated:YES completion:nil];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        about.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 1.75, self.view.superview.frame.size.width / 1.5);
        about.view.superview.center = CGPointMake(about.view.superview.frame.size.width - 100, about.view.superview.frame.size.height - 150);
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        about.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 1.75, self.view.superview.frame.size.width / 1.5);
        about.view.superview.center = CGPointMake(about.view.superview.frame.size.width - 240, about.view.superview.frame.size.height);
    }
    
}

- (void)pinJoinClicked {
    
    if ([self.pinTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"PIN码错误"
                              message:@"需要输入PIN码才能进入会议室"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        [self.pinTextField resignFirstResponder];
        
        NSString *joinConferenceMessage = [NSString stringWithFormat:
                                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                           "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                           "<env:Body>"
                                           "<ns1:JoinConferenceRequest>"
                                           "<ns1:conferenceID>%@</ns1:conferenceID>"
                                           "<ns1:pin>%@</ns1:pin>"
                                           "</ns1:JoinConferenceRequest>"
                                           "</env:Body>"
                                           "</env:Envelope>",self.entityID, self.pinTextField.text];
        
        [self joinConferencePin:joinConferenceMessage];
        [self.pinTextField setText:@""];
        
        //    NSString *joinConferenceMessage = [NSString stringWithFormat:
        //                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        //                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
        //                                       "<env:Body>"
        //                                       "<ns1:JoinConferenceRequest>"
        //                                       "<ns1:conferenceID>%@</ns1:conferenceID>"
        //                                       "<ns1:pin>%@</ns1:pin>"
        //                                       "</ns1:JoinConferenceRequest>"
        //                                       "</env:Body>"
        //                                       "</env:Envelope>",self.entityID, self.pinTextField.text];
        //
        //    [self joinConferencePin:joinConferenceMessage];
        /*if ([self.pinTextField.text isEqualToString:self.pinPassword]) {
         
         _HUD = [[MBProgressHUD alloc] initWithView:self.view];
         [self.view addSubview:_HUD];
         [_HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
         
         NSString *joinConferenceMessage = [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
         "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
         "<env:Body>"
         "<ns1:JoinConferenceRequest>"
         "<ns1:conferenceID>%@</ns1:conferenceID>"
         "<ns1:pin>%@</ns1:pin>"
         "</ns1:JoinConferenceRequest>"
         "</env:Body>"
         "</env:Envelope>",self.entityID, self.pinPassword];
         
         [self joinConference:joinConferenceMessage];
         } else {
         UIAlertView *pinAlter = [[UIAlertView alloc] initWithTitle:nil message:@"您输入的PIN码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [pinAlter show];
         }*/
    }
}

- (void)roomLickClick:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                           cancelButtonItem:nil
                                      destructiveButtonItem:nil
                                           otherButtonItems:nil, nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    RIButtonItem *emailButton = [RIButtonItem item];
    emailButton.label = kInviteByEmailButtonTitle;
    emailButton.action = ^{
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        [mailComposeViewController setMailComposeDelegate:self];
        [mailComposeViewController setSubject:kEmailTitle];
        
//        NSString *body = [NSString stringWithFormat:@"<style>h3 a{color:red}</style>您好,<br/>已邀请您参加在如下虚拟会议室举行的 VidyoConference 会议<br/>若要以访客身份加入，请点击此链接:<br/><h3>%@</h3>若要使用 VidyoVoice 通过电话加入，请拨打此号码:<br/>重要提示：此会议期间查看的任何视频、音频和/或材料均可能被录制下来。一旦您加入会议，即表示您同意 (i) 此等录制；以及 (ii) 日后由会议主持人决定让他人查看此等录制内容。如果您不同意，请在开始录制之前与会议主持人讨论，或者不要参加会议。请注意，任何此等录制内容均可能作为诉讼相关的证据。<br/><br/>如果您是新用户，请在呼叫前查阅我们的《访客速查指南》:<br/>Windows:http://vidyo.com/22w<br/>Mac:http://vidyo.com/22m<br/><br/>需要入门帮助？请查阅 Vidyo 知识中心网站:http://www.vidyo.com/knowledge-center/",self.roomURLString];
        
        NSString *body = self.contentString;
        
        [mailComposeViewController setMessageBody:body isHTML:YES];
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        
    };
    
    RIButtonItem *mycopyButton = [RIButtonItem item];
    mycopyButton.label = kCopylinkButtonTitle;
    mycopyButton.action = ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.roomURLString;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.delegate = self;
        HUD.labelText = kCopyCompletedTitle;
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
    };
    
    RIButtonItem *messageButton = [RIButtonItem item];
    messageButton.label = kTextlinkButtonTitle;
    messageButton.action = ^{
        MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
        [message setMessageComposeDelegate:self];
        NSString *pinString = [self getStringOfBody:self.contentString withStrart:@"PIN:" withSub:4 withEnd:@")"];
        NSString *htmlBody;
        
        if (![pinString isEqualToString:@""]) {
            htmlBody = [NSString stringWithFormat:@"请点击以下链接参加会议:%@ , Room PIN:%@",self.roomURLString,pinString];
        } else {
            htmlBody = [NSString stringWithFormat:@"请点击以下链接参加会议:%@",self.roomURLString];
        }
        message.body = htmlBody;
        
        [self presentViewController:message animated:YES completion:nil];
    };
    
    
    if ([MFMessageComposeViewController canSendText] && [MFMailComposeViewController canSendMail]) {
        [self.actionSheet addButtonItem:emailButton];
        [self.actionSheet addButtonItem:mycopyButton];
        [self.actionSheet addButtonItem:messageButton];
    }
    else if ([MFMessageComposeViewController canSendText])
    {
        [self.actionSheet addButtonItem:mycopyButton];
        [self.actionSheet addButtonItem:messageButton];
    } else if([MFMailComposeViewController canSendMail]) {
        [self.actionSheet addButtonItem:emailButton];
        [self.actionSheet addButtonItem:mycopyButton];
    } else {
        [self.actionSheet addButtonItem:mycopyButton];
    }
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        [self.actionSheet showFromRect:CGRectMake(890, 40, 200, 200) inView:self.view animated:YES];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        [self.actionSheet showFromRect:CGRectMake(650, 40, 200, 200) inView:self.view animated:YES];
        
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"cancel");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
        case MessageComposeResultSent:
            NSLog(@"发送成功");
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog( @"邮件发送取消");
            break;
        case MFMailComposeResultSaved:
            NSLog( @"邮件保存成功");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
