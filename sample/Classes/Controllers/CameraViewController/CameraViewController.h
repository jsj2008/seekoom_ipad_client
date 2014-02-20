//
//  CameraViewController.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-10-21.
//
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
{
    UIImageView          *_testView;
}

@property (nonatomic, strong) UIImageView *testView;
@property (nonatomic,strong) NSString *uriString;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(void) SetRate: (UIInterfaceOrientation) toInterfaceOrientation;

- (IBAction)upButton:(id)sender;
- (IBAction)downButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)rightButton:(id)sender;
- (IBAction)zoomInButton:(id)sender;
- (IBAction)zoomOutButton:(id)sender;



@end
