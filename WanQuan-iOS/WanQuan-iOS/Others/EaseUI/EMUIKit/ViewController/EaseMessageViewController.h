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

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EaseRefreshTableViewController.h"

#import "IMessageModel.h"
#import "EaseMessageModel.h"
#import "EaseBaseMessageCell.h"
#import "EaseMessageTimeCell.h"
#import "EaseChatToolbar.h"
#import "EaseLocationViewController.h"
#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HUD.h"
#import "EaseSDKHelper.h"





//@interface ChattersModel : NSObject
//@property (nonatomic, copy, readonly) NSString * fromName;
//@property (nonatomic, copy, readonly) NSString * fromPic;
//@property (nonatomic, copy, readonly) NSString * toName;
//@property (nonatomic, copy, readonly) NSString * toPic;
//
//+(instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;
//- initWithFromName:(NSString *)fromName
//           fromPic:(NSString *)fromPic
//            toName:(NSString *)toName
//             toPic:(NSString *)toPic NS_DESIGNATED_INITIALIZER;
//
//@end
//
//
//@implementation ChattersModel
//
//- (id)initWithFromName:(NSString *)fromName
//               fromPic:(NSString *)fromPic
//                toName:(NSString *)toName
//                 toPic:(NSString *)toPic {
//    if (self = [super init]) {
//        _fromName = fromName;
//        _fromPic = fromPic;
//        _toName = toName;
//        _toPic = toPic;
//    }
//    return self;
//}
//
//@end







@interface EaseAtTarget : NSObject
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *nickname;

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname;
@end

typedef void(^EaseSelectAtTargetCallback)(EaseAtTarget*);

@class EaseMessageViewController;

@protocol EaseMessageViewControllerDelegate <NSObject>

@optional

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel;

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

- (void)messageViewController:(EaseMessageViewController *)viewController
          didSendMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
   didFailSendingMessageModel:(id<IMessageModel>)messageModel
                        error:(EMError *)error;

- (void)messageViewController:(EaseMessageViewController *)viewController
 didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

- (void)messageViewController:(EaseMessageViewController *)viewController
              didSelectRecordView:(UIView *)recordView
                withEvenType:(EaseRecordViewType)type;

/*!
 @method
 @brief 获取要@的对象
 @discussion 用户输入了@，选择要@的对象
 @param selectedCallback 用于回调要@的对象的block
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback;

@end


@protocol EaseMessageViewControllerDataSource <NSObject>

@optional

- (id)messageViewController:(EaseMessageViewController *)viewController
                  progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;

- (void)messageViewController:(EaseMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<IMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;

- (NSString *)messageViewController:(EaseMessageViewController *)viewController
                      stringForDate:(NSDate *)date;

- (NSArray *)messageViewController:(EaseMessageViewController *)viewController
          loadMessageFromTimestamp:(long long)timestamp
                             count:(NSInteger)count;

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read;

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel;

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                   messageModel:(id<IMessageModel>)messageModel;

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController;

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion;

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController;

@end

@interface EaseMessageViewController : EaseRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, EMChatManagerDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, EaseChatBarMoreViewDelegate, EMLocationViewDelegate,EMChatroomManagerDelegate, EaseMessageCellDelegate>

@property (weak, nonatomic) id<EaseMessageViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EaseMessageViewControllerDataSource> dataSource;

@property (strong, nonatomic) EMConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

@property (nonatomic) BOOL isViewDidAppear;

@property (nonatomic) NSInteger messageCountOfPage; //default 50

@property (nonatomic) CGFloat timeCellHeight;

@property (strong, nonatomic) NSMutableArray *messsagesSource;

@property (strong, nonatomic) EaseChatToolbar *chatToolbar;

@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;

@property(strong, nonatomic) EaseFaceView *faceView;

@property(strong, nonatomic) EaseRecordView *recordView;

@property (strong, nonatomic) UIMenuController *menuController;

@property (strong, nonatomic) NSIndexPath *menuIndexPath;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic) BOOL isJoinedChatroom;

@property (strong, nonatomic) NSString *nid;
@property (strong, nonatomic) NSString *needOwnerId;//发单者ID
@property (strong, nonatomic) NSString *fromName;//发送消息的显示名称
@property (strong, nonatomic) NSString *fromPic; //发送消息的显示头像ID
@property (strong, nonatomic) NSString *toName;//接收消息的显示名称
@property (strong, nonatomic) NSString *toPic; //接收消息的显示头像ID
@property (nonatomic, assign) BOOL isTrueName; //是否匿名发单
@property (nonatomic, assign) BOOL isBidTureName; //是否匿名接单
@property (nonatomic, assign) BOOL isFromTemp;//是否为临时会话

/**
 订单是否已完成
 */
@property (nonatomic, assign) BOOL bidFinished;

/**
 我询问的订单处的订单被选为完成的备选
 */
@property (nonatomic, assign) BOOL tempChatBiding;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType
                                     needId:(NSString *)nid
                                needOwnerId:(NSString *)needOwnerId
                                   fromName:(NSString *) userName
                                    fromPic:(NSString *) userPic
                                     toName:(NSString *) toName
                                      toPic:(NSString *) toPic
                                 isFromTemp:(BOOL) isFromTemp
                                 isTrueName:(BOOL) isTrueName
                              isBidTureName:(BOOL) isBidTureName ;
//__attribute__((deprecated("use- (instancetype)initWithConverSationChatter:(NSString *)conversationChatter chattersModel:(ChattersModel *)chattersModel needId:(NSString *)needId isTemporaryChat:(BOOL)temporaryChat isTrueNameNeedChat:(BOOL)trueNameNeedChat; insdead")));



///**
// 用来取代上面的方法
//
// @param conversationChatter 必传参数 聊天对方的 id
// @param chattersModel 包含对话双方的 id 以及注册名等信息,以上字段皆可不传,但每一方的名字和头像要同时不传,不传当做匿名
// @param needId 如果是订单信息则必传,好友消息不传或者传空字符串
// @param temporaryChat 如果来自订单的临时询问则为 yes 否则为 no
// @param trueNameNeedChat 实名的订单会话, 如果我是实名传 yes 否则传 no
// @return  该绘会话的所有聊天的列表的控制器
// */
//- (instancetype)initWithConverSationChatter:(NSString *)conversationChatter
//                              chattersModel:(ChattersModel *)chattersModel
//                                     needId:(NSString *)needId
//                         isTrueNameNeedChat:(BOOL)trueNameNeed
//                            isTemporaryChat:(BOOL)temporaryChat;


- (void)tableViewDidTriggerHeaderRefresh;

- (void)sendTextMessage:(NSString *)text;

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

- (void)sendImageMessage:(UIImage *)image;

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;

- (void)sendVideoMessageWithURL:(NSURL *)url;

-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress;

-(void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;

-(BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                 read:(BOOL)read;

- (void)_sendMessage:(EMMessage *)message;





///**
// 该函数仅在好友聊天时调用
//
// @param conversationChatter  chatter
// @param conversationType  会话类型一般为 EMConversationTypeChat
// @return instancetype
// */
//- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
//                           conversationType:(EMConversationType)conversationType;

@end
