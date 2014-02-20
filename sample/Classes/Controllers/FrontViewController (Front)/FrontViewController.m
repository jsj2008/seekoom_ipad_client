
/*
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may
 be used to endorse or promote products derived from this software
 without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FrontViewController.h"
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
#import "ILBarButtonItem.h"
#import "SettingViewController.h"
#import "FileItemTableCell.h"
#import "AboutViewController.h"
#import "joinConferenceViewController.h"
#import "DemoViewController.h"
#import "VCLoginViewController.h"
#import "CheckNetwork.h"

@implementation FrontViewController
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
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
@synthesize participantID = _participantID;
@synthesize navigationBar = _navigationBar;
@synthesize inviteButton = _inviteButton;
@synthesize clearButton = _clearButton;
@synthesize aboutButton = _aboutButton;
@synthesize searchByOnlineName = _searchByOnlineName;
@synthesize searchCore = _searchCore;
@synthesize searchCoreMember = _searchCoreMember;
@synthesize FPPopViewController = _FPPopViewController;
@synthesize LegacyDic = _LegacyDic;
@synthesize myContactsDic =_myContactsDic;
@synthesize parserSearch;
@synthesize refreshDelegate;
@synthesize currentPage;

#pragma mark - View lifecycle

#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0)


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [self.imageView setFrame:CGRectMake(280, 65, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.tableView setFrame:CGRectMake(0, 152, 280, 616)];
            [_navigationBar setFrame:CGRectMake(0, 20, 1024, 44)];
            [self.inviteButton setFrame:CGRectMake(550, 260, 180, 44)];
            [self.clearButton setFrame:CGRectMake(550, 420, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [self.imageView setFrame:CGRectMake(280, 45, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.tableView setFrame:CGRectMake(0, 132, 280, 636)];
            [_navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
            [self.inviteButton setFrame:CGRectMake(550, 260, 180, 44)];
            [self.clearButton setFrame:CGRectMake(550, 420, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        }
    } else  {
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [self.imageView setFrame:CGRectMake(280, 65, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.tableView setFrame:CGRectMake(0, 152, 280, 872)];
            [_navigationBar setFrame:CGRectMake(0, 20, 768, 44)];
            [self.inviteButton setFrame:CGRectMake(420, 420, 180, 44)];
            [self.clearButton setFrame:CGRectMake(420, 520, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [self.imageView setFrame:CGRectMake(280, 45, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.tableView setFrame:CGRectMake(0, 132, 280, 892)];
            [_navigationBar setFrame:CGRectMake(0, 0, 768, 44)];
            [self.inviteButton setFrame:CGRectMake(420, 420, 180, 44)];
            [self.clearButton setFrame:CGRectMake(420, 520, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadTable];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchCoreMember Reset];
    [self.searchCore Reset];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPopClickNoti:)
												 name:@"dismissPopClick" object:nil];
    

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setEditing:YES animated:YES];
    
    
    _parserObj = [[NSMutableArray alloc] initWithCapacity:0];
    _sArray = [[NSMutableArray alloc] initWithCapacity:0];
    _fArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.imageView = [[UIImageView alloc] init];
    
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 280, 88)];
        [self.searchBar setBarTintColor:[UIColor clearColor]];
    } else {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 280, 88)];
    }
//    [self.searchBar setBarStyle:UIBarStyleDefault];
    [self.searchBar setBackgroundColor:[UIColor lightGrayColor]];
    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:kSearchBarScopeOnlineTitle,kSearchBarScopeAllTitle, nil]];
    //    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:kSearchBarScopeOnlineTitle, nil]];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = YES;
    self.searchBar.placeholder = kSearchContactPlacHold;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_secondimage_landscape.png"]]];
    
    self.aboutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.aboutButton addTarget:self action:@selector(AboutClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.inviteArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.inviteArray removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllClick:)
												 name:@"All" object:nil];
    
    self.navigationBar = [[UINavigationBar alloc] init];
    
    self.inviteButton = [[UIButton alloc] init];
    [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"ipad_button.png"] forState:UIControlStateNormal];
    [self.inviteButton setTitle:kInviteConferenceTitle forState:UIControlStateNormal];
    [self.inviteButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.inviteButton addTarget:self action:@selector(inviteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.clearButton = [[UIButton alloc] init];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"ipad_clear_background_image.png"] forState:UIControlStateNormal];
    [self.clearButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.clearButton setTitle:kCleanMyConferenceTitle forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(cleanMyConfence:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:kInviteConferenceTitle];
    
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_image.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar pushNavigationItem:NavTitle animated:YES];
    [_navigationBar setTintColor:[UIColor whiteColor]];
    [self.view addSubview:_navigationBar];
    
    
    
    ILBarButtonItem *settingsBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"ipad_setting.png"]
                        selectedImage:[UIImage imageNamed:@"ipad_setting.png"]
                               target:self
                               action:@selector(navBackBt)];
    NavTitle.leftBarButtonItem = settingsBtn;
    
    
    
    /* Right bar button item */
    
    ILBarButtonItem *searchBtn =
    
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"ipad_back.png"]
                        selectedImage:[UIImage imageNamed:@"ipad_back.png"]
                               target:self
                               action:@selector(setttingBt)];
    NavTitle.rightBarButtonItem = searchBtn;
    
    _reloads = -1;
    _pullToRefreshManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tableView withClient:self];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.myContactsDic = [[NSMutableDictionary alloc] init];
    
    self.contactDic = [[NSMutableDictionary alloc] init];
    
    self.searchByName = [[NSMutableArray alloc] init];
    
    self.searchByOnlineName  = [[NSMutableArray alloc] init];
    
    self.searchCoreMember = [[SearchCoreManager alloc] init];
    
    self.searchCore = [[SearchCoreManager alloc] init];
    
    self.parserObj = [[NSMutableArray alloc] init];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [self.imageView setFrame:CGRectMake(280, 65, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.tableView setFrame:CGRectMake(0, 152, 280, 616)];
            [_navigationBar setFrame:CGRectMake(0, 20, 1024, 44)];
            [self.inviteButton setFrame:CGRectMake(550, 260, 180, 44)];
            [self.clearButton setFrame:CGRectMake(550, 420, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 1024, 768);
            [self.imageView setFrame:CGRectMake(280, 45, 745, 732)];
            [self.imageView setImage:[UIImage imageNamed:@"700.png"]];
            [self.tableView setFrame:CGRectMake(0, 132, 280, 636)];
            [_navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
            [self.inviteButton setFrame:CGRectMake(550, 260, 180, 44)];
            [self.clearButton setFrame:CGRectMake(550, 420, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(986, 729, 15, 14)];
        }
    } else  {
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [self.imageView setFrame:CGRectMake(280, 65, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.tableView setFrame:CGRectMake(0, 152, 280, 872)];
            [_navigationBar setFrame:CGRectMake(0, 20, 768, 44)];
            [self.inviteButton setFrame:CGRectMake(420, 420, 180, 44)];
            [self.clearButton setFrame:CGRectMake(420, 520, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        } else {
            self.view.bounds = CGRectMake(0, 0, 768, 1024);
            [self.imageView setFrame:CGRectMake(280, 45, 488, 988)];
            [self.imageView setImage:[UIImage imageNamed:@"11111.png"]];
            [self.tableView setFrame:CGRectMake(0, 132, 280, 892)];
            [_navigationBar setFrame:CGRectMake(0, 0, 768, 44)];
            [self.inviteButton setFrame:CGRectMake(420, 420, 180, 44)];
            [self.clearButton setFrame:CGRectMake(420, 520, 180, 44)];
            [self.aboutButton setFrame:CGRectMake(735, 985, 15, 14)];
        }
    }
    
    NSString *myAccountMessage = [NSString stringWithFormat:
                                  @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                  "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                  "<env:Body>"
                                  "<ns1:MyAccountRequest>"
                                  "</ns1:MyAccountRequest>"
                                  "</env:Body>"
                                  "</env:Envelope>"];
    [self myAccount:myAccountMessage];
    
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
    
    NSString *searchMyContactsMessage = [NSString stringWithFormat:
                                         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                         "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                         "<env:Body>"
                                         "<ns1:SearchMyContactsRequest>"
                                         "<ns1:Filter/>"
                                         "</ns1:SearchMyContactsRequest>"
                                         "</env:Body>"
                                         "</env:Envelope>"];
    
    [self searchMyContacts:searchMyContactsMessage];
    
    
    NSString *searchOnlineMemberMessage = [NSString stringWithFormat:
                                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                           "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                           "<env:Body>"
                                           "<ns1:SearchRequest>"
                                           "<ns1:Filter>"
                                           "<ns1:EntityType>Legacy</ns1:EntityType>"
                                           "</ns1:Filter>"
                                           "</ns1:SearchRequest>"
                                           "</env:Body>"
                                           "</env:Envelope>"];
    [self searchLegacy:searchOnlineMemberMessage];
    
    
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.inviteButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.tableView];
}


- (void)dismissPopClickNoti:(NSNotification*)notify{
    [self.FPPopViewController dismissPopoverAnimated:YES];
}

- (void)searchMyContacts:(NSString *)soapMessage
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
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:SearchMyContactsResponse" namespaces:mapping error:&error];
    if (error) {
        return;
    } else {
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            _mArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (GDataXMLElement *name in names) {
                _workingContacts = [[Members alloc] init];
                GDataXMLElement *nameElement = [[name elementsForName:@"ns1:displayName"] objectAtIndex:0];
                NSString *nameString = [nameElement stringValue];
                
                GDataXMLElement *statusElement = [[name elementsForName:@"ns1:MemberStatus"] objectAtIndex:0];
                NSString *statusString = [statusElement stringValue];
                
                GDataXMLElement *extensionElement = [[name elementsForName:@"ns1:extension"] objectAtIndex:0];
                NSString *extensionString = [extensionElement stringValue];
                
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];
                
                NSArray *roomMode = [name elementsForName:@"ns1:RoomMode"];
                
                for (GDataXMLElement *room in roomMode) {
                    GDataXMLElement *isLockedElement = [[room elementsForName:@"ns1:isLocked"] objectAtIndex:0];
                    NSString *isLockedString = [isLockedElement stringValue];
                    
                    GDataXMLElement *hasPinElement = [[room elementsForName:@"ns1:hasPin"] objectAtIndex:0];
                    NSString *hasPinString = [hasPinElement stringValue];
                    
                    GDataXMLElement *roomPinElement = [[room elementsForName:@"ns1:roomPIN"] objectAtIndex:0];
                    NSString *roomPINString = [roomPinElement stringValue];
                    
                    self.workingContacts.isLocked = isLockedString;
                    self.workingContacts.hasPin = hasPinString;
                    self.workingContacts.roomPin = roomPINString;
                }
                self.workingContacts.entityID = entityIDString;
                self.workingContacts.displayName = nameString;
                self.workingContacts.status = statusString;
                self.workingContacts.extension = extensionString;
                
                NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
                [format setNumberStyle:NSNumberFormatterNoStyle];
                _workingContacts.localID = [format numberFromString:entityIDString];
                
                [self.myContactsDic setObject:_workingContacts forKey:_workingContacts.localID];
                [self.searchCoreMember AddContact:_workingContacts.localID name:_workingContacts.displayName phone:nil];
                
                [parserContacts addObject:_workingContacts];
                
            }
        }
    }
}


- (void)searchLegacy:(NSString *)soapMessage
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
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            
            for (GDataXMLElement *name in names) {
                Members *onlineContact = [[Members alloc] init];
                _mObject = [[Members alloc] init];
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
                
                NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
                [format setNumberStyle:NSNumberFormatterNoStyle];
                onlineContact.localID = [format numberFromString:entityIDString];
                
                onlineContact.status = statusString;
                onlineContact.displayName = nameString;
                onlineContact.extension = extensionString;
                onlineContact.entityID = entityIDString;
                onlineContact.entityType = entityTypeString;
                
                [self.parserObj addObject:onlineContact];
                [self.LegacyDic setObject:onlineContact forKey:onlineContact.localID];
//                [self.searchCoreMember AddContact:onlineContact.localID name:onlineContact.displayName phone:nil];
                
            }
        }
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
            
            
            for (GDataXMLElement *name in names) {
                Members *onlineContact = [[Members alloc] init];
                _mObject = [[Members alloc] init];
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
                
                
                NSArray *roomMode = [name elementsForName:@"ns1:RoomMode"];
                
                 if (![self.myCountID isEqualToString:entityIDString]) {
                
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
                
                NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
                [format setNumberStyle:NSNumberFormatterNoStyle];
                onlineContact.localID = [format numberFromString:entityIDString];
                
                onlineContact.status = statusString;
                onlineContact.displayName = nameString;
                onlineContact.extension = extensionString;
                onlineContact.entityID = entityIDString;
                onlineContact.entityType = entityTypeString;
                
                [self.contactDic setObject:onlineContact forKey:onlineContact.localID];
                [self.searchCore AddContact:onlineContact.localID name:onlineContact.displayName phone:nil];
                
                 }
            }
        }
    }
}


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
    theRequest.shouldWaitToInflateCompressedResponses = NO;
    [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
    theRequest.allowCompressedResponse = YES;
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:MyAccountResponse" namespaces:mapping error:&error];
    
    if (error) {
        return;
    } else {
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            
            for (GDataXMLElement *name in names) {
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];
                self.myCountID = entityIDString;
            }
        }
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

- (void)loadTable
{
    _reloads++;
    [_tableView reloadData];
    [_pullToRefreshManager tableViewReloadFinished];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_pullToRefreshManager tableViewReleased];
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}

- (void)navBackBt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setttingBt
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


- (IBAction)inviteClick:(id)sender
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
    [_HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
    
    
    [self.searchBar resignFirstResponder];
    for (int i = 0; i < [_inviteArray count]; i++) {
        NSString *soapInviteMessage = [NSString stringWithFormat:
                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                       "<env:Body>"
                                       "<ns1:InviteToConferenceRequest>"
                                       "<ns1:conferenceID>%@</ns1:conferenceID>"
                                       "<ns1:entityID>%@</ns1:entityID>"
                                       "</ns1:InviteToConferenceRequest>"
                                       "</env:Body>"
                                       "</env:Envelope>",self.myCountID,[_inviteArray objectAtIndex:i]];
        [self inviteConfenceByEntityID:soapInviteMessage];
    }
    
    if ([_inviteArray count] > 0) {
        [_inviteArray removeAllObjects];
    }
    
    NSString *joinConferenceMessage = [NSString stringWithFormat:
                                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                       "<env:Body>"
                                       "<ns1:JoinConferenceRequest>"
                                       "<ns1:conferenceID>%@</ns1:conferenceID>"
                                       "</ns1:JoinConferenceRequest>"
                                       "</env:Body>"
                                       "</env:Envelope>",self.myCountID];
    [self joinConference:joinConferenceMessage];
    [self doneLoadingTableViewData];
}

- (void)myMixedTask
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = kInviteConferenceLoading;
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.05f;
        _HUD.progress = progress;
        usleep(100000);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    [self.FPPopViewController dismissPopoverAnimated:YES];
}


-(void)popover:(id)sender
{
    DemoViewController *controller = [[DemoViewController alloc] init];
    self.FPPopViewController = [[FPPopoverController alloc] initWithViewController:controller];
    
    self.FPPopViewController.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.FPPopViewController.contentSize = CGSizeMake(300, 500);
    }
    self.FPPopViewController.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [self.FPPopViewController presentPopoverFromView:sender];
}

- (IBAction)AboutClicked:(id)sender {
    AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    about.modalPresentationStyle = UIModalPresentationFormSheet;
    about.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:about animated:YES];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        about.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 1.6, self.view.superview.frame.size.width / 1.5);
        about.view.superview.center = CGPointMake(about.view.superview.frame.size.width - 100, about.view.superview.frame.size.height - 150);
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        about.view.superview.frame = CGRectMake(0, 0, self.view.superview.frame.size.height / 1.6, self.view.superview.frame.size.width / 1.5);
        about.view.superview.center = CGPointMake(about.view.superview.frame.size.width - 240, about.view.superview.frame.size.height);
    }
}

- (IBAction)AllClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"All" object:nil];
}

- (IBAction)cleanMyConfence:(id)sender
{
    [self popover:sender];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        for (int i = 0; i < [_sArray count]; i++) {
            NSString *soapLeaveOtherMessage = [NSString stringWithFormat:
                                               @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                               "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                               "<env:Body>"
                                               "<ns1:LeaveConferenceRequest>"
                                               "<ns1:conferenceID>%@</ns1:conferenceID>"
                                               "<ns1:participantID>%@</ns1:participantID>"
                                               "</ns1:LeaveConferenceRequest>"
                                               "</env:Body>"
                                               "</env:Envelope>",self.myCountID,[_sArray objectAtIndex:i]];
            [self leaveConfenceByEntityID:soapLeaveOtherMessage];
        }
    }
}

- (void)leaveConfenceByEntityID:(NSString *)soapMessage
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
    //    [theRequest addValue: auth forHTTPHeaderField:@"Authorization"];
    
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
        //        NSString *responseString = [theRequest responseString];
    }
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        [self.searchCore Search:searchText searchArray:nil nameMatch:_searchByOnlineName phoneMatch:nil];
    } else if (self.searchBar.selectedScopeButtonIndex == 1){
        [self.searchCoreMember Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    }
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{

    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData
{
    if ([CheckNetwork isExistenceNetwork]) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [parserContacts removeAllObjects];
        [self.contactDic removeAllObjects];
        [_parserObj removeAllObjects];
        
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
        
        NSString *searchMyContactsMessage = [NSString stringWithFormat:
                                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                             "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                             "<env:Body>"
                                             "<ns1:SearchMyContactsRequest>"
                                             "<ns1:Filter/>"
                                             "</ns1:SearchMyContactsRequest>"
                                             "</env:Body>"
                                             "</env:Envelope>"];
        
        [self searchMyContacts:searchMyContactsMessage];
        
        
        NSString *searchLegacyMessage = [NSString stringWithFormat:
                                         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                         "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                         "<env:Body>"
                                         "<ns1:SearchRequest>"
                                         "<ns1:Filter>"
                                         "<ns1:EntityType>Legacy</ns1:EntityType>"
                                         "</ns1:Filter>"
                                         "</ns1:SearchRequest>"
                                         "</env:Body>"
                                         "</env:Envelope>"];
        [self searchLegacy:searchLegacyMessage];
        
        [self.tableView reloadData];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logOut" object:nil];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource1{
	if (refreshDelegate != nil) {
		currentPage = currentPage + 1;
		[refreshDelegate reloadRefreshDataSource:currentPage];
	}
	_reloading = YES;
}

- (void)reloadTableViewDataSource
{
    currentPage = 0;
    if (refreshDelegate!=nil) {
		[refreshDelegate reloadRefreshDataSource:currentPage];
	}
	_reloading = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [_pullToRefreshManager relocatePullToRefreshView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    //    [self reloadTableViewDataSource];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        return [NSString stringWithFormat:kResultsTitle,[self.contactDic count] + [self.LegacyDic count]];
    } else if (self.searchBar.selectedScopeButtonIndex == 1) {
        return [NSString stringWithFormat:kResultsTitle,[self.myContactsDic count]];
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        
        if ([self.searchBar.text length] <= 0) {
            return [self.contactDic count] + [self.LegacyDic count];
        } else {
            return [self.searchByOnlineName count];
        }
        
    } else if (self.searchBar.selectedScopeButtonIndex == 1) {
        
        if ([self.searchBar.text length] <= 0) {
            return [self.myContactsDic count];
        } else {
            return [self.searchByName count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nameString = [defaults objectForKey:@"username"];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:15];
    }
    
        if ([self.searchBar.text length] <= 0) {
            if (self.searchBar.selectedScopeButtonIndex == 0) {
                NSArray *sortkeys = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
                NSMutableArray *sortValues = [NSMutableArray array];
                for (NSString *key in sortkeys) {
                    [sortValues addObject:[self.contactDic objectForKey:key]];
                }
                
                NSMutableArray *memberAddLegacy = [NSMutableArray array];
                
                for (int i = 0; i < [sortValues count]; i++) {
                    Members *roomMember = [sortValues objectAtIndex:i];
                    [memberAddLegacy addObject:roomMember];
                }
                
                for (int i = 0; i < [_parserObj count]; i++) {
                    Members *Legacy = [_parserObj objectAtIndex:i];
                    [memberAddLegacy addObject:Legacy];
                }
                
                Members *contact = [memberAddLegacy objectAtIndex:indexPath.row];
                
                cell.textLabel.text = contact.displayName;
                //            [cell setChecked:contact.isChecked];
                
                if ([contact.displayName isEqualToString:nameString]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([contact.status isEqualToString:@"Offline"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGray@2x.png"];
                } else if ([contact.status isEqualToString:@"Online"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGreen@2x.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"ContactRed@2x.png"];
                }
                
                if ([contact.entityType isEqualToString:@"Legacy"]) {
                    cell.imageView.image = [UIImage imageNamed:@"Legacy.png"];
                }
                
                if ([contact.entityID isEqualToString:self.myEntityID]) {
                    if ([contact.hasPin isEqualToString:@"true"] && [contact.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLockKeypad@2x.png"];
                    } else if ([contact.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactKeypad@2x.png"];
                    } else if ([contact.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLock@2x.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                    }
                }
                return cell;
            } else if (self.searchBar.selectedScopeButtonIndex == 1) {
                NSArray *sortkeys = [[self.myContactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
                NSMutableArray *sortValues = [NSMutableArray array];
                for (NSString *key in sortkeys) {
                    [sortValues addObject:[self.myContactsDic objectForKey:key]];
                }
                
                Members *contact = [sortValues objectAtIndex:indexPath.row];
                cell.textLabel.text = contact.displayName;
                //            [cell setChecked:contact.isChecked];
                
                UIImage *image= [ UIImage imageNamed:@"ios7_share.png" ];
                UIButton *button = [ UIButton buttonWithType:UIButtonTypeCustom ];
                CGRect frame = CGRectMake( 0.0 , 0.0 , image.size.width , image.size.height );
                button. frame = frame;
                [button setBackgroundImage:image forState:UIControlStateNormal ];
                button. backgroundColor = [UIColor clearColor ];
                [button addTarget:self action:@selector(buttonPressedAction)  forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = button;
                
                if ([contact.displayName isEqualToString:nameString]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([contact.status isEqualToString:@"Offline"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGray@2x.png"];
                } else if ([contact.status isEqualToString:@"Online"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGreen@2x.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"ContactRed@2x.png"];
                }
                
                if ([contact.entityType isEqualToString:@"Room"]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([contact.entityID isEqualToString:self.myEntityID]) {
                    if ([contact.hasPin isEqualToString:@"true"] && [contact.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLockKeypad@2x.png"];
                    } else if ([contact.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactKeypad@2x.png"];
                    } else if ([contact.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLock@2x.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                    }
                }
                return cell;
            }
        } else {
            if (self.searchBar.selectedScopeButtonIndex == 0) {
                NSNumber *localID = nil;
                NSString *formatString = nil;
                NSMutableString *matchString = [NSMutableString string];
                NSMutableArray *matchPos = [NSMutableArray array];
                
                if (indexPath.row < [_searchByOnlineName count]) {
                    localID = [self.searchByOnlineName objectAtIndex:indexPath.row];
                    if([self.searchBar.text length]) {
                        [self.searchCore GetPinYin:localID pinYin:matchString matchPos:matchPos];
                        NSNumberFormatter *numberf = [[NSNumberFormatter alloc] init];
                        formatString = [numberf stringFromNumber:localID];
                    }
                }
                
                NSNumberFormatter *numberf = [[NSNumberFormatter alloc] init];
                formatString = [numberf stringFromNumber:localID];
                
                
                Members *mems = [self.contactDic objectForKey:localID];
                
                
//                if (mems == nil) {
//                    mems = [self.LegacyDic objectForKey:localID1];
//                }
                cell.textLabel.text = mems.displayName;
                //            [cell setChecked:mems.isChecked];
                
                if ([mems.displayName isEqualToString:nameString]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([mems.status isEqualToString:@"Offline"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGray@2x.png"];
                } else if ([mems.status isEqualToString:@"Online"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGreen@2x.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"ContactRed@2x.png"];
                }
                
                if ([mems.entityType isEqualToString:@"Room"]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([mems.entityID isEqualToString:self.myEntityID]) {
                    if ([mems.hasPin isEqualToString:@"true"] && [mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLockKeypad@2x.png"];
                    } else if ([mems.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactKeypad@2x.png"];
                    } else if ([mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLock@2x.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                    }
                }
                return cell;
                
            } else if (self.searchBar.selectedScopeButtonIndex == 1) {
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
                
                NSNumberFormatter *numberf = [[NSNumberFormatter alloc] init];
                formatString = [numberf stringFromNumber:localID];
                
                
                Members *mems = [self.myContactsDic objectForKey:localID];
                
                
                cell.textLabel.text = mems.displayName;
                //            [cell setChecked:mems.isChecked];
                
                if ([mems.displayName isEqualToString:nameString]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([mems.status isEqualToString:@"Offline"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGray@2x.png"];
                } else if ([mems.status isEqualToString:@"Online"]) {
                    cell.imageView.image = [UIImage imageNamed:@"ContactGreen@2x.png"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"ContactRed@2x.png"];
                }
                
                if ([mems.entityType isEqualToString:@"Room"]) {
                    cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                }
                
                if ([mems.entityID isEqualToString:self.myEntityID]) {
                    if ([mems.hasPin isEqualToString:@"true"] && [mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLockKeypad@2x.png"];
                    } else if ([mems.hasPin isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactKeypad@2x.png"];
                    } else if ([mems.isLocked isEqualToString:@"true"]) {
                        cell.imageView.image = [UIImage imageNamed:@"RoomContactLock@2x.png"];
                    } else {
                        cell.imageView.image = [UIImage imageNamed:@"Room@2x.png"];
                    }
                }
                return cell;
            }
        }

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchBar.text length] <= 0)
    {
        if (self.searchBar.selectedScopeButtonIndex == 0)
        {
            NSArray *sortkeys = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.contactDic objectForKey:key]];
            }
            
            NSMutableArray *memberAddLegacy = [NSMutableArray array];
            
            for (int i = 0; i < [sortValues count]; i++) {
                Members *roomMember = [sortValues objectAtIndex:i];
                [memberAddLegacy addObject:roomMember];
            }
            
            for (int i = 0; i < [_parserObj count]; i++) {
                Members *Legacy = [_parserObj objectAtIndex:i];
                [memberAddLegacy addObject:Legacy];
            }
            
            Members *ofllinemem = [memberAddLegacy objectAtIndex:indexPath.row];
            
            self.entityID = ofllinemem.entityID;
            self.roomPinTextField.text = @"";
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                ofllinemem.isChecked = !ofllinemem.isChecked;
                [cell setSelected:ofllinemem.isChecked];
                if (ofllinemem.isChecked) {
                    [_inviteArray addObject:ofllinemem.entityID];
                } else {
                    [_inviteArray removeObject:ofllinemem.entityID];
                } }
            
            self.pinPassword = ofllinemem.roomPin;
            
            _displayNameLabel.text = ofllinemem.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,ofllinemem.extension];
            if ([ofllinemem.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([ofllinemem.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
            
        } else if (self.searchBar.selectedScopeButtonIndex == 1)
        {
            NSArray *sortkeys = [[self.myContactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.myContactsDic objectForKey:key]];
            }
            
            Members *mem = [sortValues objectAtIndex:indexPath.row];
            
            self.entityID = mem.entityID;
            
            self.roomPinTextField.text = @"";
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                mem.isChecked = !mem.isChecked;
                [cell setSelected:mem.isChecked];
                if (mem.isChecked) {
                    [_inviteArray addObject:mem.entityID];
                } else {
                    [_inviteArray removeObject:mem.entityID];
                }
            }
            
            
            self.pinPassword = mem.roomPin;
            
            _displayNameLabel.text = mem.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,mem.extension];
            if ([mem.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([mem.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
        }
    } else {
        if (self.searchBar.selectedScopeButtonIndex == 0)
        {
            Members *searchMember = [self.contactDic objectForKey:[_searchByOnlineName objectAtIndex:indexPath.row]];
            
            self.pinPassword = searchMember.roomPin;
            self.entityID = searchMember.entityID;
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                searchMember.isChecked = !searchMember.isChecked;
                [cell setSelected:searchMember.isChecked];
                if (searchMember.isChecked) {
                    [_inviteArray addObject:searchMember.entityID];
                } else {
                    [_inviteArray removeObject:searchMember.entityID];
                }
            }
            
            _displayNameLabel.text = searchMember.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,searchMember.extension];
            if ([searchMember.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([searchMember.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
        }
        else if (self.searchBar.selectedScopeButtonIndex == 1)
        {
            Members *searchMemberContact = [self.myContactsDic objectForKey:[_searchByName objectAtIndex:indexPath.row]];
            
            self.pinPassword = searchMemberContact.roomPin;
            self.entityID = searchMemberContact.entityID;
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                searchMemberContact.isChecked = !searchMemberContact.isChecked;
                [cell setSelected:searchMemberContact.isChecked];
                if (searchMemberContact.isChecked) {
                    [_inviteArray addObject:searchMemberContact.entityID];
                } else {
                    [_inviteArray removeObject:searchMemberContact.entityID];
                }
            }
            
            _displayNameLabel.text = searchMemberContact.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,searchMemberContact.extension];
            if ([searchMemberContact.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([searchMemberContact.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchBar.text length] <= 0)
    {
        if (self.searchBar.selectedScopeButtonIndex == 0)
        {
            NSArray *sortkeys = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.contactDic objectForKey:key]];
            }
            
            NSMutableArray *memberAddLegacy = [NSMutableArray array];
            
            for (int i = 0; i < [sortValues count]; i++) {
                Members *roomMember = [sortValues objectAtIndex:i];
                [memberAddLegacy addObject:roomMember];
            }
            
            for (int i = 0; i < [_parserObj count]; i++) {
                Members *Legacy = [_parserObj objectAtIndex:i];
                [memberAddLegacy addObject:Legacy];
            }
            
            Members *ofllinemem = [memberAddLegacy objectAtIndex:indexPath.row];
            
            self.entityID = ofllinemem.entityID;
            self.roomPinTextField.text = @"";
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                ofllinemem.isChecked = !ofllinemem.isChecked;
                [cell setSelected:ofllinemem.isChecked];
                if (ofllinemem.isChecked) {
                    [_inviteArray addObject:ofllinemem.entityID];
                } else {
                    [_inviteArray removeObject:ofllinemem.entityID];
                } }
            
            self.pinPassword = ofllinemem.roomPin;
            
            _displayNameLabel.text = ofllinemem.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,ofllinemem.extension];
            if ([ofllinemem.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([ofllinemem.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
            
        } else if (self.searchBar.selectedScopeButtonIndex == 1)
        {
            NSArray *sortkeys = [[self.myContactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *sortValues = [NSMutableArray array];
            for (NSString *key in sortkeys) {
                [sortValues addObject:[self.myContactsDic objectForKey:key]];
            }
            
            Members *mem = [sortValues objectAtIndex:indexPath.row];
            
            self.entityID = mem.entityID;
            
            self.roomPinTextField.text = @"";
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                mem.isChecked = !mem.isChecked;
                [cell setSelected:mem.isChecked];
                if (mem.isChecked) {
                    [_inviteArray addObject:mem.entityID];
                } else {
                    [_inviteArray removeObject:mem.entityID];
                }
            }
            
            
            self.pinPassword = mem.roomPin;
            
            _displayNameLabel.text = mem.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,mem.extension];
            if ([mem.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([mem.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
        }
    } else {
        if (self.searchBar.selectedScopeButtonIndex == 0)
        {
            Members *searchMember = [self.contactDic objectForKey:[_searchByOnlineName objectAtIndex:indexPath.row]];
            
            self.pinPassword = searchMember.roomPin;
            self.entityID = searchMember.entityID;
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                searchMember.isChecked = !searchMember.isChecked;
                [cell setSelected:searchMember.isChecked];
                if (searchMember.isChecked) {
                    [_inviteArray addObject:searchMember.entityID];
                } else {
                    [_inviteArray removeObject:searchMember.entityID];
                }
            }
            
            _displayNameLabel.text = searchMember.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,searchMember.extension];
            if ([searchMember.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([searchMember.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
        }
        else if (self.searchBar.selectedScopeButtonIndex == 1)
        {
            Members *searchMemberContact = [self.myContactsDic objectForKey:[_searchByName objectAtIndex:indexPath.row]];
            
            self.pinPassword = searchMemberContact.roomPin;
            self.entityID = searchMemberContact.entityID;
            
            if (self.tableView.editing)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                searchMemberContact.isChecked = !searchMemberContact.isChecked;
                [cell setSelected:searchMemberContact.isChecked];
                if (searchMemberContact.isChecked) {
                    [_inviteArray addObject:searchMemberContact.entityID];
                } else {
                    [_inviteArray removeObject:searchMemberContact.entityID];
                }
            }
            
            _displayNameLabel.text = searchMemberContact.displayName;
            _extensionLabel.text = [NSString stringWithFormat:kExtensionLabel,searchMemberContact.extension];
            if ([searchMemberContact.status isEqualToString:@"Offline"]) {
                _statusImage.image = [UIImage imageNamed:@"ContactGray114.png"];
            } else if ([searchMemberContact.status isEqualToString:@"Online"]) {
                _statusImage.image= [UIImage imageNamed:@"ContactGreen114.png"];
            } else {
                _statusImage.image = [UIImage imageNamed:@"ContactRed114.png"];
            }
            
        }
    }
}


#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isLockLabel.text = @"";
    self.pinJoinRoomButton.hidden = NO;
}

#pragma mark - Example Code


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
    
    NSString *responseString = [theRequest responseString];
    if (!error) {
    }
}


#pragma mark - Memory Management


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setStatusImage:nil];
    [self setDisplayNameLabel:nil];
    [self setExtensionLabel:nil];
    [self setDirectCallButton:nil];
    [self setJoinConferenceButton:nil];
    [self setIsLockLabel:nil];
    [self setRoomPinTextField:nil];
    [self setPinJoinRoomButton:nil];
    [self setContactsButton:nil];
    [self setRemoveContactsButton:nil];
    [self setSearchBar:nil];
    [self setImageView:nil];
    [self setDisplayNameLabel:nil];
    [super viewDidUnload];
}
@end

