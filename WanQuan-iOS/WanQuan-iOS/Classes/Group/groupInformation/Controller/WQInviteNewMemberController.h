//
//  WQInviteNewMemberController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareOnclick)();

@interface WQInviteNewMemberController : UIViewController

@property (nonatomic, copy) ShareOnclick shareToEMFriend;
@property (nonatomic, copy) ShareOnclick shareToMiriade;
@property (nonatomic, copy) ShareOnclick shereToThird;
@end
