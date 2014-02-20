//
//  UINavigationController+SupportIOS6.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-5-22.
//
//

#import "UINavigationController+SupportIOS6.h"

@implementation UINavigationController (SupportIOS6)

- (BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
