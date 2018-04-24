//
//  WQFriendsNoticeView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQFriendsNoticeView : UIView
@property (nonatomic, strong) NSMutableArray *aUsernameMessageArray;
@property (nonatomic, copy) void(^headerViewHigthBlock)(NSInteger);
@end
