//
//  WQSharMenuView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSharMenuView;

@protocol WQSharMenuViewDelegate <NSObject>

// 转发至群组
- (void)wqGroupBtnCliek;
// 分享到第三方
- (void)wqSharBtnCliek;
// 转发到万圈好友
- (void)wqFriendsBtnClike;
// 点击屏幕隐藏分享菜单
- (void)WQSharMenuViewHidden;

@end

@interface WQSharMenuView : UIView

@property (nonatomic, weak) id<WQSharMenuViewDelegate>delegate;

/**
 是否是从群动态首页过来的
 */
@property (nonatomic, assign) BOOL isGroupFriends;

@property (nonatomic, strong) UIButton *groupBtn;

@end
