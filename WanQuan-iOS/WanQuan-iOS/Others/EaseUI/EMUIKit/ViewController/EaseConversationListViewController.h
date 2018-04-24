/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseRefreshTableViewController.h"

#import "EaseConversationModel.h"
#import "EaseConversationCell.h"

#import "EMSDK.h"

typedef NS_ENUM(int, DXDeleteConvesationType) {
    DXDeleteConvesationOnly,
    DXDeleteConvesationWithMessages,
};

@class EaseConversationListViewController;

@protocol EaseConversationListViewControllerDelegate <NSObject>

/*!
 @method
 @brief 获取点击会话列表的回调
 @discussion 获取点击会话列表的回调后,点击会话列表用户可以根据conversationModel自定义处理逻辑
 @param conversationListViewController 当前会话列表视图
 @param conversationModel 会话模型
 */
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel;

@optional

@end

@protocol EaseConversationListViewControllerDataSource <NSObject>

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                        modelForConversation:(EMConversation *)conversation;

@optional

/*!
 @method
 @brief 获取最后一条消息显示的内容
 @discussion 用户根据conversationModel实现,实现自定义会话中最后一条消息文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @param conversationModel 会话模型
 @result 返回用户最后一条消息显示的内容
 */
- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel;

/*!
 @method
 @brief 获取最后一条消息显示的时间
 @discussion 用户可以根据conversationModel,自定义实现会话列表中时间文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @param conversationModel 会话模型
 @result 返回用户最后一条消息时间的显示文案
 */
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel;

@end


@interface EaseConversationListViewController : EaseRefreshTableViewController <EMChatManagerDelegate,EMGroupManagerDelegate>

@property (weak, nonatomic) id<EaseConversationListViewControllerDelegate> delegate;
@property (weak, nonatomic) id<EaseConversationListViewControllerDataSource> dataSource;
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *needOwnerId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPic;
@property (nonatomic, assign) BOOL isFromTemp;
@property (nonatomic, strong) NSMutableSet *bidUserList;

@property (nonatomic, assign) BOOL finished;

@property (nonatomic, assign) BOOL isRoot;
- (instancetype)initWithNid:(NSString *)nid
                needOwnerId:(NSString *)needOwnerId
                 isFromTemp:(BOOL)isFromTemp
                bidUserList:(NSSet *)bidUserList;

+(NSString *)titleFromMessage:(EMMessage *)lastMessage;
+(void)setLatestMessageTitle:(EMMessage *)message nid:(NSString *)nid conversation:(EMConversation *)conversation;
+(void)updateConversationExt:(EMMessage *)message conversation:(EMConversation *)_conversation;
/*!
 @method
 @brief 下拉加载更多
 */
- (void)tableViewDidTriggerHeaderRefresh;

/*!
 @method
 @brief 内存中刷新页面
 */
- (void)refreshAndSortView;

-(void)refresh;

-(void)refreshDataSource;


//根据需求id判断临时会话处是否需要显示红点   //我发的订单联系处
+(BOOL)shouldShowRedDotInTemp:(NSString *)nid;
//根据需求id和接单人id判断与接单人联系或者与发单人联系处是否需要显示红点   临时会话
+(BOOL)shouldShowRedDot:(NSString *)nid withBidUser:(NSString *)bidUserId;
//是否需要在我接的订单或者我发的订单处显示红点。isMineReceived: true表示我接的订单，fase表示我发的订单   tabBar
+(BOOL)shouldShowRedDotInMine:(BOOL)isMineReceived;
//根据需求id判断我发的需求列表或者我接的需求列表里的item是否需要显示红点   //接发的订单里的红点
+(BOOL)shouldShowRedDotForNid:(NSString *)nid;

@end
