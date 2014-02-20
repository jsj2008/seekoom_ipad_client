//
//  CategoryViewController.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-7-1.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CategoryViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD           *HUD;
    UIImageView             *_imageView;
    UIButton                *_inviteButton;
    UIButton                *_joinButton;
    UIButton                *_exitButton;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIButton *exitButton;

@end
