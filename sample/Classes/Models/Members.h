//
//  Members.h
//  VidyoClientSample_iOS
//
//  Created by lee on 13-3-25.
//
//

#import <Foundation/Foundation.h>

@interface Members : NSObject
{
    NSString            *_displayName;
    NSString            *_status;
    NSString            *_extension;
    NSString            *_entityID;
    NSString            *_isLocked;
    NSString            *_hasPin;
    NSString            *_roomPin;
    NSString            *_entityType;
    NSNumber            *_localID;
    NSString            *_roomStatus;
    NSString            *_participantID;
    BOOL                _isChecked;
}
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, copy) NSString *entityID;
@property (nonatomic, copy) NSString *isLocked;
@property (nonatomic, copy) NSString *hasPin;
@property (nonatomic, copy) NSString *roomPin;
@property (nonatomic, copy) NSString *entityType;
@property (nonatomic, copy) NSString *roomStatus;
@property (nonatomic,retain) NSNumber *localID;
@property (assign, nonatomic) BOOL isChecked;
@property (nonatomic, copy) NSString *participantID;

@end
