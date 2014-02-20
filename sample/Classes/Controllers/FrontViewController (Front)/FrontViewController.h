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

#import <UIKit/UIKit.h>
#import "Members.h"
#import "VCLoginViewController.h"
#import "Users.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequestDelegate.h"
#import "GradientButton.h"
#import "MNMBottomPullToRefreshManager.h"
#import "MBProgressHUD.h"
#import "SearchCoreManager.h"
#import "FPPopoverController.h"

@protocol UITableViewRefresh
-(void) reloadRefreshDataSource:(int) pageIndex;
@end

@interface FrontViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, EGORefreshTableHeaderDelegate, ASIHTTPRequestDelegate,MNMBottomPullToRefreshManagerClient,UIAlertViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD               *_HUD;
    UITableView                 *_tableView;
    NSMutableArray              *_entity;
    Members                     *_workingMember;
    Members                     *_workingContacts;
    Members                     *_mObject;
    
    NSMutableArray              *_mArray;
    NSMutableArray              *_sArray;
    NSMutableArray              *_fArray;
    
    NSMutableDictionary         *dic;
    
    NSMutableArray              *parserContacts;
    NSMutableArray              *_searchByName;
    NSMutableArray              *_searchByOnlineName;
    NSMutableArray              *_onlinesearchByName;
    NSMutableArray              *_searchByPhone;
    NSMutableArray              *parserSearch;
    NSMutableDictionary         *_contactDic;
    NSMutableDictionary         *_offlineContactDic;
    NSString                    *_participantID;
    NSMutableDictionary         *_LegacyDic;
    NSMutableDictionary         *_myContactsDic;


    NSString                    *_entityID;
    NSString                    *_pinPassword;
    NSString                    *_myEntityID;
    Users                       *_users;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    MNMBottomPullToRefreshManager *_pullToRefreshManager;
    NSUInteger                  _reloads;
    BOOL                        _reloading;
    BOOL                        _onlineStatus;
    BOOL                        _allMember;
    
    __weak id<UITableViewRefresh>      refreshDelegate;
    int                         currentPage;
    CGPoint                     point;
    
    UIView                      *_searchBarSuperview;
    NSUInteger                  _searchBarSuperIndex;
    NSMutableArray              *_inviteArray;
    NSString                    *_myCountID;
    UISearchBar                 *_searchBar;
    UINavigationBar             *_navigationBar;
    
    UIButton                    *_inviteButton;
    UIButton                    *_clearButton;
    UIButton                    *_aboutButton;
    SearchCoreManager           *_searchCore;
    SearchCoreManager           *_searchCoreMember;
    
    FPPopoverController         *_FPPopViewController;
    BOOL _isRun;
}
@property (nonatomic, strong) NSMutableArray *parserObj;
@property (nonatomic, strong) NSMutableDictionary *myContactsDic;
@property (nonatomic, strong) NSMutableDictionary *LegacyDic;
@property (nonatomic, strong) FPPopoverController *FPPopViewController;
@property (nonatomic, strong) SearchCoreManager *searchCoreMember;
@property (nonatomic, strong) SearchCoreManager *searchCore;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, weak) id<UITableViewRefresh> refreshDelegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *entity;
@property (nonatomic, strong) Members *workingMember;
@property (nonatomic, strong) Members *workingContacts;
@property (nonatomic, copy) NSString *pinPassword;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *extensionLabel;
@property (strong, nonatomic) IBOutlet GradientButton *directCallButton;        //直接呼叫
@property (strong, nonatomic) IBOutlet GradientButton *joinConferenceButton;    //进入会议室
@property (strong, nonatomic) IBOutlet UILabel *isLockLabel;              //1：会议室被锁定 2：需要PIN码
@property (strong, nonatomic) IBOutlet UITextField *roomPinTextField;     //PIN码输入框
@property (strong, nonatomic) IBOutlet GradientButton *pinJoinRoomButton;       //PIN吗进入会议室
@property (strong, nonatomic) IBOutlet GradientButton *contactsButton;          //添加联系人按钮
@property (strong, nonatomic) IBOutlet GradientButton *removeContactsButton;    //移除联系人
@property (strong, nonatomic) UISearchBar *searchBar;            
@property (nonatomic, strong) NSString *participantID;
@property (nonatomic, copy) NSString *entityID;
@property (nonatomic, copy) NSString *myEntityID;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) NSMutableArray *searchByName;
@property (nonatomic, strong) NSMutableArray *searchByOnlineName;
@property (nonatomic, strong) NSMutableArray *onlinesearchByName;
@property (nonatomic, strong) NSMutableArray *searchByPhone;
@property (nonatomic, strong) NSMutableArray *parserSearch;

@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic, strong) NSMutableDictionary *offlineContactDic;
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Members *mObject;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableArray *inviteArray;
@property (nonatomic, copy) NSString *myCountID;
@property (nonatomic, readonly) int currentPage;
@property (strong, nonatomic)  UIImageView *imageView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *clearButton;

- (IBAction)inviteClick:(id)sender;
- (IBAction)AboutClicked:(id)sender;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end