//
//  CheckNetwork.m
//  NetWorkDemo
//
//  Created by mino on 11-7-18.
//  Copyright 2011 gdkxjszyxy. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            break;
    }
	if (!isExistenceNetwork) {
		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"网络状态" message:@"当前设备没有网络连接，请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
		[myalert show];
	}
	return isExistenceNetwork;
}
@end
