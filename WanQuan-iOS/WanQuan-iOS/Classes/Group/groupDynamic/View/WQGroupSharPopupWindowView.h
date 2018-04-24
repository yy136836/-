//
//  WQGroupSharPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupSharPopupWindowView;

@protocol WQGroupSharPopupWindowViewDelegate <NSObject>
// 转发至万圈好友
- (void)friendsBtnClike:(WQGroupSharPopupWindowView *)groupSharPopupWindowView;
// 转发万圈
- (void)groupBtnClike:(WQGroupSharPopupWindowView *)groupSharPopupWindowView;
// 分享第三方
- (void)sharBtnClike:(WQGroupSharPopupWindowView *)groupSharPopupWindowView;
// 点击屏幕隐藏分享菜单
- (void)WQSharMenuViewHidden:(WQGroupSharPopupWindowView *)groupSharPopupWindowView;
@end

@interface WQGroupSharPopupWindowView : UIView
@property (nonatomic, weak) id <WQGroupSharPopupWindowViewDelegate> delegate;


/**
 是否从WQGroupDynamicViewController过来的,是:yes  不是no
 */
@property (nonatomic, assign) BOOL isWQGroupDynamicVC;

@end
