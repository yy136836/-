//
//  OriginalEaseConversationListViewController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "EaseRefreshTableViewController.h"

#import "EaseRefreshTableViewController.h"

#import "EaseConversationModel.h"
#import "EaseConversationCell.h"
#import <HyphenateLite_CN/EMSDK.h>

//#if ENABLE_LITE == 1
//#import <HyphenateLite/HyphenateLite.h>
//#else
//#import <Hyphenate/Hyphenate.h>
//#endif

//typedef NS_ENUM(int, DXDeleteConvesationType) {
//    DXDeleteConvesationOnly,
//    DXDeleteConvesationWithMessages,
//};

@class OriginalEaseConversationListViewController;

@protocol OriginalEaseConversationListViewControllerDelegate <NSObject>

/*!
 @method
 @brief 获取点击会话列表的回调
 @discussion 获取点击会话列表的回调后,点击会话列表用户可以根据conversationModel自定义处理逻辑
 @param conversationListViewController 当前会话列表视图
 @param IConversationModel 会话模型
 @result
 */
- (void)conversationListViewController:(OriginalEaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel;

@optional

@end

@protocol OriginalEaseConversationListViewControllerDataSource <NSObject>

/*!
 @method
 @brief 构建实现协议IConversationModel的model
 @discussion 用户可以创建实现协议IConversationModel的自定义conversationModel对象，按照业务需要设置属性值
 @param conversationListViewController 当前会话列表视图
 @param conversation 会话对象
 @result 返回实现协议IConversationModel的model对象
 */
- (id<IConversationModel>)conversationListViewController:(OriginalEaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation;

@optional

/*!
 @method
 @brief 获取最后一条消息显示的内容
 @discussion 用户根据conversationModel实现,实现自定义会话中最后一条消息文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @param IConversationModel 会话模型
 @result 返回用户最后一条消息显示的内容
 */
- (NSAttributedString *)conversationListViewController:(OriginalEaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel;

/*!
 @method
 @brief 获取最后一条消息显示的时间
 @discussion 用户可以根据conversationModel,自定义实现会话列表中时间文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @param IConversationModel 会话模型
 @result 返回用户最后一条消息时间的显示文案
 */
- (NSString *)conversationListViewController:(OriginalEaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel;

@end


@interface OriginalEaseConversationListViewController : EaseRefreshTableViewController <EMChatManagerDelegate,EMGroupManagerDelegate>

@property (weak, nonatomic) id<OriginalEaseConversationListViewControllerDelegate> delegate;
@property (weak, nonatomic) id<OriginalEaseConversationListViewControllerDataSource> dataSource;

/*!
 @method
 @brief 下拉加载更多
 @discussion
 @result
 */
- (void)tableViewDidTriggerHeaderRefresh;

/*!
 @method
 @brief 内存中刷新页面
 @discussion
 @result
 */
- (void)refreshAndSortView;

@end
