//
//  SettingViewController.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-3-18.
//
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UISwitch            *_cameraSwitch;
    UISwitch            *_microphoneSwitch;
    UISwitch            *_backgroundSwitch;
    UISwitch            *_networkSwitch;
    UISwitch            *_autoSwitch;
    NSInteger           _cameraSwitchIsOnOff;
    NSInteger           _microphoneSwitchIsOnOff;
    NSInteger           _autoSwitchIsOnOff;
    NSInteger           _backgroundSwitchIsOnOff;
    NSInteger           _networkSwitchIsOnOff;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISwitch *cameraSwitch;
@property (nonatomic, strong) UISwitch *microphoneSwitch;
@property (nonatomic, strong) UISwitch *backgroundSwitch;
@property (nonatomic, strong) UISwitch *networkSwitch;
@property (nonatomic, strong) UISwitch *autoSwitch;

@end
