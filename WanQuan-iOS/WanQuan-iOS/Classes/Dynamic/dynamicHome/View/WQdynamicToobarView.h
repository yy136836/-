//
//  WQdynamicToobarView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQdynamicToobarView;

@protocol WQdynamicToobarViewDelegate <NSObject>

/**
 赞的响应事件

 @param toobarView self
 */
- (void)wqPraiseBtnClick:(WQdynamicToobarView *)toobarView;

/**
 评论的响应事件

 @param toobarView self
 */
- (void)wqCommentsBtnClick:(WQdynamicToobarView *)toobarView;

/**
 分享的响应事件

 @param toobarView self
 */
- (void)wqSharBtnClick:(WQdynamicToobarView *)toobarView;

/**
 踩的按钮的响应事件

 @param toobarView self
 */
- (void)wqCaiBtnClick:(WQdynamicToobarView *)toobarView;

/**
 举报按钮的响应事件

 @param toobarView self
 */
- (void)wqReportBtnClick:(WQdynamicToobarView *)toobarView;

/**
 鼓励的响应事件

 @param toobarView self
 */
- (void)wqEencourageBtnClick:(WQdynamicToobarView *)toobarView;

/**
 三个点的响应事件

 @param toobarView self
 */
- (void)wqBtnsClick:(WQdynamicToobarView *)toobarView;

@end

@interface WQdynamicToobarView : UIView

@property (nonatomic, weak) id <WQdynamicToobarViewDelegate> delegate;

/**
 状态
 */
@property (nonatomic, copy) NSString *type;

/**
 赞的按钮
 */
@property (nonatomic, strong) UIButton *praiseBtn;

/**
 评论
 */
@property (nonatomic, strong) UIButton *commentsBtn;

/**
 分享
 */
@property (nonatomic, strong) UIButton *sharBtn;;

/**
 三个点的响应事件
 */
@property (nonatomic, strong) UIButton *btns;

/**
 弹框背景
 */
@property (nonatomic, strong) UIImageView *backImageView;

/**
 蒙层
 */
@property (nonatomic, strong) UIView *backView;

/**
 鼓励的按钮
 */
@property (nonatomic, strong) UIButton *encourageBtn;

/**
 踩的按钮
 */
@property (nonatomic, strong) UIButton *caiBtn;

/**
 举报
 */
@property (nonatomic, strong) UIButton *reportBtn;

/**
 * 三个点点对应的按钮
 */
@property (nonatomic,retain)NSArray *nameArray;

@end
