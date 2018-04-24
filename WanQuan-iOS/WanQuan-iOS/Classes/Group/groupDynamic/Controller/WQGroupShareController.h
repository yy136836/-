//
//  WQGroupShareController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"

@protocol WQGroupShareControllerDelegate<NSObject>

- (void)groupShareControllerShareToFriend;

- (void)groupShareControllerShareToThird;

- (void)groupShareControllerShareInvitationCode;


@end


@interface WQGroupShareController : WQViewController

@property (nonatomic, retain) id<WQGroupShareControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray * shareToTitles;


@end
