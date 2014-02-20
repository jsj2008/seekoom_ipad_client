//
//  DemoViewController.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-5-7.
//
//

#import <UIKit/UIKit.h>
#import "Members.h"

@interface DemoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray          *parserObj;
    Members                 *_workingMember;
    UITableView             *_tableView;
    NSString                *_entityID;
    NSString                *_myCountID;
    NSMutableArray          *_inviteArray;
    NSMutableArray          *_sArray;
    NSMutableArray          *_fArray;
    NSString                *_participantID;

}
@property (nonatomic, strong) NSString *participantID;
@property (nonatomic, strong) Members *workingMember;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, copy) NSString *entityID;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (nonatomic, strong) NSMutableArray *inviteArray;
@property (nonatomic, copy) NSString *myCountID;
@property (nonatomic, strong) NSMutableArray *sArray;

- (IBAction)editClick:(id)sender;
- (IBAction)startClick:(id)sender;

@end
