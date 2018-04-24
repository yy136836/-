//
//  WQparticularsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQoriginalStatusView,WQretweetStatus,WQStatusToolBar,WQcommentsDetailsTableview,WQStatusPictureView,WQparticularsModel,WQparticularsTableViewCell,WQlikeListView,WQreward_ListView;

@protocol statusToolBarBtnClikedelegate <NSObject>
//点赞的代理方法
- (void)likBtnClike:(WQparticularsTableViewCell *)statusToolBarlikBtn mid:(NSString *)mid;
//点踩的代理方法
- (void)TreadBtnClike:(WQparticularsTableViewCell *)statusToolBarTreadBtn mid:(NSString *)mid;
//点击评论代理方法
- (void)commentsBtnClike:(WQparticularsTableViewCell *)statusToolBarcommentsBtn mid:(NSString *)mid;
//点击转发代理方法
- (void)shareBtnClike:(WQparticularsTableViewCell *)shareBtnClike mid:(NSString *)mid;
//点击打赏的代理方法
- (void)wqsetPlayTourBtnDelegate:(WQparticularsTableViewCell *)wqsetPlayTourBtnClike;
//万圈删除的点击事件
- (void)wqDeleteBtnClikeDelegate:(WQparticularsTableViewCell *)wqDeleteBtn;
/**
 转发外链的响应事件
 
 @param miriadeTableViewCell self
 @param linkURLString 外链url
 */
- (void)wqForwardingLinksContentViewClick:(WQparticularsTableViewCell *)cell linkURLString:(NSString *)linkURLString;
@end

@interface WQparticularsTableViewCell : UITableViewCell
@property (nonatomic, weak) id <statusToolBarBtnClikedelegate> delegate;

@property (nonatomic, strong) WQoriginalStatusView *originalStatusView;
@property (nonatomic, strong) WQretweetStatus *retweetStatusView;
@property (nonatomic, strong) WQStatusToolBar *statusToolBarView;
@property (nonatomic, strong) WQlikeListView *likeListView;
@property (nonatomic, strong) WQreward_ListView *reward_ListView;
//@property (nonatomic, strong) WQcommentsDetailsTableview *commentsDetailsTableview;
@property (nonatomic, strong) WQparticularsModel *model;
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) NSArray *reward_list;
// 点击头像
@property (nonatomic, copy) void (^headPortraitBlock)();
@end
