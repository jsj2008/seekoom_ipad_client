//
//  joinConferenceViewController.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-7-4.
//
//

#import <UIKit/UIKit.h>
#import "Members.h"
#import "VCLoginViewController.h"
#import "Users.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequestDelegate.h"
#import "GradientButton.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "ILBarButtonItem.h"
#import "SearchCoreManager.h"

@interface joinConferenceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate,ASIHTTPRequestDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIButton                    *_linkButton;
    UIButton                    *_joinButton;
    UIButton                    *_aboutButton;
    UIButton                    *_pinJoinButton;
    UILabel                     *_isLockLabel;
    UITextField                 *_pinTextField;
    UISearchBar                 *_searchBar;
    UIImageView                 *_imageView;
    UINavigationBar             *_navigationBar;
    
    NSMutableArray              *_entity;
    Members                     *_workingMember;
    Members                     *_workingContacts;
    Members                     *_mObject;
    
    NSMutableArray              *_mArray;
    NSMutableArray              *_sArray;
    
    NSMutableDictionary         *dic;
    
    NSMutableArray              *parserObj;
    NSMutableArray              *parserContacts;
    NSMutableArray              *_searchByName;
    NSMutableArray              *_onlinesearchByName;
    NSMutableArray              *_searchByPhone;
    NSMutableArray              *parserSearch;
    NSMutableDictionary         *_contactDic;
    NSMutableDictionary         *_offlineContactDic;
    NSMutableDictionary         *_roomDic;
    
    
    NSString                    *_entityID;
    NSString                    *_pinPassword;
    NSString                    *_myEntityID;
    Users                       *_users;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    BOOL                        _reloading;
    BOOL                        _onlineStatus;
    UIView                      *_searchBarSuperview;
    NSUInteger                  _searchBarSuperIndex;
    MBProgressHUD               *HUD;
    NSString                    *_entityIDString;
    NSString                    *_roomURLString;
    UITableView                 *_tableView;
    
    MBProgressHUD               *_HUD;
}
@property (nonatomic, strong) NSString *myAccoutString;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) ILBarButtonItem *settingsBtn;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic, retain) NSMutableDictionary *roomDic;
@property (nonatomic, retain) UIButton *linkButton;
@property (nonatomic, retain) UIButton *joinButton;
@property (nonatomic, retain) UIButton *aboutButton;
@property (nonatomic, retain) UIButton *pinJoinButton;
@property (nonatomic, retain) UILabel *isLockLabel;
@property (nonatomic, retain) UITextField *pinTextField;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) SearchCoreManager *searchCoreMember;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, copy) NSString *entityIDString;
@property (nonatomic, copy) NSString *roomURLString;
@property (strong, nonatomic) UIButton *mycopyButton;
@property (nonatomic, retain) NSMutableArray *entity;
@property (nonatomic, retain) Members *workingMember;
@property (nonatomic, retain) Members *workingContacts;
@property (nonatomic, copy) NSString *pinPassword;
@property (nonatomic, copy) NSString *entityID;
@property (nonatomic, copy) NSString *myEntityID;
@property (retain, nonatomic) UILabel *displayNameLabel;
@property (retain, nonatomic) UILabel *extensionLabel;
@property (nonatomic, retain) NSMutableArray *searchByName;
@property (nonatomic, retain) NSMutableArray *onlinesearchByName;
@property (nonatomic, retain) NSMutableArray *searchByPhone;
@property (nonatomic, retain) NSMutableArray *parserSearch;
@property (nonatomic, retain) NSMutableDictionary *contactDic;
@property (nonatomic, retain) NSMutableDictionary *offlineContactDic;
@property (nonatomic, retain) Users *users;
@property (nonatomic, retain) Members *mObject;
@property (nonatomic, retain) NSString *string;

@end
