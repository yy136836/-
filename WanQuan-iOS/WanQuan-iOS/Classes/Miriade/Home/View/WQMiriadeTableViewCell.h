//
//  WQMiriadeTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQMiriadeaModel,WQMiriadeTableViewCell,WQOriginalStatusView,WQStatusToolBarView,WQRetweetStatusView,WQStatusPictureView,WQforwardingContentView,WQlittleHelperStatusToolBarView,WQGroupForwardView;

@protocol WQMiriadeTableViewCellDelegate <NSObject>

- (void)wqMiriadeTableViewCellDelegate:(WQMiriadeTableViewCell *)miriadeTableViewCellDelegate;
- (void)wqRetweetBtnDelegate:(WQMiriadeTableViewCell *)retweetBtnClike;
- (void)wqCommentBtnDelegate:(WQMiriadeTableViewCell *)commentBtnClike;
- (void)wqsetPlayTourBtnDelegate:(WQMiriadeTableViewCell *)wqsetPlayTourBtnClike;
// 点击群名片
- (void)wqGroupClike:(WQMiriadeTableViewCell *)miriadeTableViewCell;
// 点击文字
- (void)wqContentLabelClike:(WQMiriadeTableViewCell *)miriadeTableViewCell;

/**
 外链的响应事件

 @param miriadeTableViewCell self
 */
- (void)wqLinksContentViewClick:(WQMiriadeTableViewCell *)miriadeTableViewCell;

/**
 转发外链的响应事件

 @param miriadeTableViewCell self
 @param linkURLString 外链url
 */
- (void)wqForwardingLinksContentViewClick:(WQMiriadeTableViewCell *)miriadeTableViewCell linkURLString:(NSString *)linkURLString;
@end

@interface WQMiriadeTableViewCell : UITableViewCell
@property (nonatomic, weak) id <WQMiriadeTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQMiriadeaModel *miriadeaModel;

@property (nonatomic, copy) void(^midStringBlock)(NSString *);
@property (nonatomic, copy) void(^shardClikeBlock)(UIButton *);
@property (nonatomic, copy) void (^headPortraitBlock)();

@property (nonatomic, strong) WQOriginalStatusView *originalstatus;
@property (nonatomic, strong) WQStatusToolBarView *statusToolBarView;
@property (nonatomic, strong) WQRetweetStatusView *retweetStatusView;
@property (nonatomic, strong) WQStatusPictureView *statusPictureView;
@property (nonatomic, strong) WQforwardingContentView *forwardingContentView;
@property (nonatomic, strong) WQlittleHelperStatusToolBarView *littleHelperStatusToolBarView;
@property (nonatomic, strong) WQGroupForwardView *groupForwardView;

@end
