//
//  Users.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-4-7.
//
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
{
    NSString            *_potalString;
    NSString            *_userNameString;
    NSString            *_passwordString;
}

@property (nonatomic, copy) NSString *potalString;
@property (nonatomic, copy) NSString *userNameString;
@property (nonatomic, copy) NSString *passwordString;

@end
