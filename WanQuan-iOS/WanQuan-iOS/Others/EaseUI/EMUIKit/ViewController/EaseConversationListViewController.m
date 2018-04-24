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

#import "EaseConversationListViewController.h"

#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseMessageViewController.h"
#import "NSDate+Category.h"
#import "EaseLocalDefine.h"
#import "ChatHelper.h"
#import "WQPeopleListModel.h"

#import "WQConversationListHeader.h"
#import "WQMessageNoLoginView.h"
#import "WQFriendsViewController.h"


#import "WQSystemMessageController.h"
#import "WQCircleNewsController.h"
#import "WQLogInController.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"

@interface EaseConversationListViewController () <WQLoginPopupWindowDelegate>
@property (nonatomic, retain) WQMessageNoLoginView * noLoginView;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@end

@implementation EaseConversationListViewController

- (instancetype)initWithNid:(NSString *)nid
                needOwnerId:(NSString *)needOwnerId
                 isFromTemp:(BOOL)isFromTemp
                bidUserList:(NSSet *)bidUserList
{
    self = [super init];
    
    if(self){
        self.nid = nid;
        self.needOwnerId = needOwnerId;
        self.isFromTemp = isFromTemp;
    }
    
    return self;
}


- (void)viewDidAppear:(BOOL)animated {
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
    NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_password"];;
    if (![EMClient sharedClient].isLoggedIn) {
        [[EMClient sharedClient] loginWithUsername:userName password:passWord completion:^(NSString *aUsername, EMError *aError) {
            
        }];
    }
    
    [super viewDidAppear:animated];
    
    
    self.navigationItem.title = @"未接单者询问";
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerNotifications];
    for (UITableView * table in self.view.subviews) {
        if ([table isKindOfClass:[UITableView class]]) {
            [table reloadData];
        }
    }
    
    
    if (self.nid.length) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    _bidUserList = [[NSMutableSet alloc]init];
    
    
    
    if (self.isRoot) {
        
        [[WQNetworkTools sharedTools] fetchRedDot];
        
        WQConversationListHeader * header = [[NSBundle mainBundle] loadNibNamed:@"WQConversationListHeader" owner:self options:nil].lastObject;
        
        header.frame = CGRectMake(0, 0, kScreenWidth, 160);
        
        
        self.tableView.tableHeaderView = header;
        header.systemMessageOnClick = ^{
            WQSystemMessageController * vc = [[WQSystemMessageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        header.circleMessageOnClick = ^{
            WQCircleNewsController * vc = [[WQCircleNewsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        
        
        NSString * strURL = @"api/message/reddot";
        
        NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
        NSDictionary * param;
        if (secreteKey.length) {
            param = @{@"secretkey":secreteKey};
        } else {
            return;
        }
        
        
        WQNetworkTools *tools = [WQNetworkTools sharedTools];
        [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
            if (error) {
                return ;
            }
            
            
            //        ecode = 0;
            //        好友申请
            //        "friendapply_count" = 0;
            //        消息
            //        message = 0;
            //        入群申请
            //        "message_applyjoingroup" = 0;
            //        评论
            //        "message_comment" = 0;
            //        赞
            //        "message_like" = 0;
            //        系统消息
            //        "message_sys" = 0;
            //        "my_bidded_need_bidded_doing_count" = 0;
            //        "my_bidded_need_bidded_finished_count" = 1;
            //        "my_bidded_need_bidding_count" = 0;
            //        "my_bidded_need_total_count" = 1;
            //        "my_count" = 1;
            //        "my_created_need_bidded_count" = 0;
            //        "my_created_need_bidding_count" = 0;
            //        "my_created_need_finished_count" = 0;
            //        "my_created_need_total_count" = 0;
            //        success = 1;
            
            ROOT(root);
            
            if (root) {
                if ([response[@"my_bidded_need_bidded_doing_count"] boolValue]||
                    [response[@"my_bidded_need_bidding_count"] boolValue]||
                    [response[@"my_created_need_bidded_count"] boolValue]||
                    [response[@"my_created_need_bidding_count"] boolValue]) {
                    root.haveBidInfoToDealWith = YES;
                } else {
                    root.haveBidInfoToDealWith = NO;
                }
                
                root.haveFriendapply = [response[@"friendapply_count"] boolValue];
                
                root.haveSystemInfoToDealWith = [response[@"message_sys"] boolValue];
                
                root.haveGroupApply  = [response[@"message_applyjoingroup"] boolValue];
                
                root.haveCommentInfoToDealWith = [response[@"message_comment"] boolValue];
                
                root.haveMessageInfoToDealWith = [response[@"message"] boolValue];
                
                root.haveLikeTodealWith = [response[@"message_like"] boolValue];
                
                root.haveCircleEvent = [response[@"message_applyjoingroup"]boolValue];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:nil];
                
                header.systemDot.hidden = !root.haveSystemInfoToDealWith;
                header.circleDot.hidden = !root.haveCircleEvent;
                
            }
        }];
        
        
        
        
        
        //        NSString *urlString = @"api/message/querymessagelastest";
        //        NSMutableDictionary * dic = @{}.mutableCopy;
        //
        //        dic[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        //
        //        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:dic completion:^(id response, NSError *error) {
        //            if (error) {
        //                NSLog(@"%@",error);
        //                return ;
        //            }
        //            if ([response isKindOfClass:[NSData class]]) {
        //                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        //            }
        //            NSLog(@"%@",response);
        //
        //
        //            NSString * latestSysMessage = response[@"system_message_title"];
        //            NSString * latestCirMessage = response[@"system_message_subject"];
        //            //            NSArray * messages = response[@"messages"];
        //            //            if (messages.count) {
        //            //                NSDictionary * msg = messages[0];
        //            //
        //            header.lastSystemMessageLabel.text = latestSysMessage.length?latestSysMessage:@"";
        //            header.lastCircleMessageLabel.text = latestCirMessage.length?latestCirMessage:@"";
        //            //            }
        //        }];
    }
    
    [self getAllBider];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    _noLoginView.hidden = ![role_id isEqualToString:@"200"];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self unregisterNotifications];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    
    
    [self tableViewDidTriggerHeaderRefresh];
    
    
    [ChatHelper shareHelper].conversationListVC = self;
    _noLoginView = [[NSBundle mainBundle] loadNibNamed:@"WQMessageNoLoginView" owner:self options:nil].lastObject;
    _noLoginView.frame = self.view.frame;
    [self.view addSubview:_noLoginView];
    _noLoginView.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tongxunlu_circle"] style:UIBarButtonItemStylePlain target:self action:@selector(showContacter)];
    
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.navigationController.viewControllers[0] == self) {
        self.isRoot = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)getAllBider {
    
    
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params = @{}.mutableCopy;
    
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"nid"] = self.nid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            //dispatch_group_enter(group);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        [SVProgressHUD dismiss];
        NSLog(@"%@",response);
        NSArray * modelArray = [NSArray yy_modelArrayWithClass: NSClassFromString(@"WQPeopleListModel") json:response[@"bids"]].mutableCopy;
        for(WQPeopleListModel *people in modelArray){
            [self.bidUserList addObject:people.user_id];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *ext = model.conversation.ext;
    NSString *userName = @"";
    NSString *userPic = nil;
    if(ext){
        if(self.nid == nil){
            self.nid = @"";
        }
        userName = [ext objectForKey:[NSString stringWithFormat:@"%@_%d_%@", self.nid, self.isFromTemp, @"to_name"]];
        userPic = [ext objectForKey:[NSString stringWithFormat:@"%@_%d_%@", self.nid, self.isFromTemp, @"to_pic"]];
    }
    
    
    
    
    [model setTitle:userName];
    if(userPic){
        [model setAvatarURLPath:[imageUrlString stringByAppendingString:userPic]];
    }
    //    只做了赋值头像和未读消息数量
    cell.model = model;
    

    NSInteger unreadMessageCount = 0;
    
    NSArray * arrMessages = [model.conversation loadMoreMessagesFromId:nil limit:MAXFLOAT direction:EMMessageSearchDirectionUp];
    
    if (!self.nid.length) {
        
        for (EMMessage * message  in arrMessages) {
            if (![message.ext[@"nid"] length] && !message.isRead) {
                unreadMessageCount ++;
            }
        }
    } else {
        for (EMMessage * message  in arrMessages) {
            if ([message.ext[@"nid"] isEqualToString:self.nid] && !message.isRead) {
                unreadMessageCount ++;
            }
        }
    }
    
    
    if (unreadMessageCount == 0) {
        
        cell.avatarView.showBadge = NO;
    } else {
        
        cell.avatarView.showBadge = YES;
        cell.avatarView.badge = unreadMessageCount;
    }
    

    

    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    } else {
        NSString *lastTitle = nil;
        if(cell.detailLabel.attributedText != nil){
            lastTitle = cell.detailLabel.attributedText.string;
        }
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model lastText:lastTitle]textFont:cell.detailLabel.font];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [_delegate conversationListViewController:self didSelectConversationModel:model];
    } else {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        //NSDictionary *ext = model.conversation.ext;
        NSDictionary *ext = [EaseConversationListViewController getMessageExt:model nid:self.nid];
        NSString *needOwnerId = nil;
        NSString *userName = nil;
        NSString *userPic = nil;
        NSString *toName = nil;
        NSString *toPic = nil;
        BOOL isTrueName, isBidTureName;
        {
            if(self.nid != nil && self.nid.length > 0){
                needOwnerId = [ext objectForKey:@"need_owner_id"];
            }
            if(self.nid == nil){
                self.nid = @"";
            }
            userName = [model.conversation.ext objectForKey:[NSString stringWithFormat:@"%@_%@_%@", self.nid, [NSNumber numberWithBool:self.isFromTemp], @"from_name"]];
            userPic = [model.conversation.ext objectForKey:[NSString stringWithFormat:@"%@_%@_%@", self.nid, [NSNumber numberWithBool:self.isFromTemp], @"from_pic"]];
            toName = [model.conversation.ext objectForKey:[NSString stringWithFormat:@"%@_%@_%@", self.nid, [NSNumber numberWithBool:self.isFromTemp], @"to_name"]];
            toPic = [model.conversation.ext objectForKey:[NSString stringWithFormat:@"%@_%@_%@", self.nid, [NSNumber numberWithBool:self.isFromTemp], @"to_pic"]];
            
            
            isTrueName = [[ext objectForKey:@"istruename"] boolValue];
            
            
            isBidTureName = [[ext objectForKey:@"isBidTureName"] boolValue];
            
        }
        EaseMessageViewController *viewController = [[EaseMessageViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type needId:self.nid needOwnerId:needOwnerId fromName:userName fromPic:userPic toName:toName toPic:toPic isFromTemp:self.isFromTemp isTrueName:isTrueName isBidTureName:isBidTureName];
        
        for (NSString * id in _bidUserList) {
            if ([id isEqualToString:model.conversation.conversationId]) {
                viewController.tempChatBiding = YES;
                break;
            }
        }
        
        viewController.bidFinished = self.finished;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:NO completion:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

-(void)refresh
{
    //[self refreshAndSortView];
    [self refreshDataSource];
}

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
            
            //            for(EaseConversationModel *conversation in self.dataArray){
            //                for(EMMessage msg in conversation.conversation loada)
            //            }
            
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }
    [self.tableView reloadData];
}

//根据需求id判断临时会话处是否需要显示红点
+(BOOL)shouldShowRedDotInTemp:(NSString *)nid
{
    return [ChatHelper hasUnreadMessage:nid withChatter:nil];
    
    /*BOOL hasRed = NO;
     NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
     for(EMConversation *conversation in conversations){
     NSDictionary *ext = conversation.ext;
     if(ext){
     for(NSString *key in ext){
     if([ext[key] isKindOfClass:[NSDictionary class]]){
     NSDictionary *nidExt = (NSDictionary *)ext[key];
     NSString *needOwnerId = [nidExt objectForKey:@"need_owner_id"];
     NSString *hasTemp = [nidExt objectForKey:@"has_temp"];
     if(hasTemp != nil){
     hasRed = YES;
     break;
     }
     }
     }
     }
     }
     return hasRed;*/
}

//根据需求id判断我发的需求列表或者我接的需求列表里的item是否需要显示红点
+(BOOL)shouldShowRedDotForNid:(NSString *)nid
{
    return [ChatHelper hasUnreadMessage:nid withChatter:nil];
    /*BOOL hasRed = NO;
     NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
     for(EMConversation *conversation in conversations){
     NSDictionary *ext = conversation.ext;
     if(ext){
     if([ext objectForKey:nid] != nil){
     hasRed = YES;
     }
     }
     }
     return hasRed;*/
}


//根据需求id和接单人id判断与接单人联系或者与发单人联系处是否需要显示红点
+(BOOL)shouldShowRedDot:(NSString *)nid withBidUser:(NSString *)bidUserId
{
    return [ChatHelper hasUnreadMessage:nid withChatter:bidUserId];
    /*BOOL hasRed = NO;
     EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:bidUserId type:EMConversationTypeChat createIfNotExist:NO];
     if(conversation == nil){
     return NO;
     }
     if(conversation.unreadMessagesCount == 0) return NO;
     NSDictionary *ext = conversation.ext;
     if(ext){
     NSDictionary *nidExt = [ext objectForKey:nid];
     if(nidExt){
     return YES;
     }
     }
     return NO;*/
}

//是否需要在我接的订单或者我发的订单处显示红点。isMineReceived: true表示我接的订单，fase表示我发的订单
+(BOOL)shouldShowRedDotInMine:(BOOL)isMineReceived {
    //
    BOOL hasRed = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *nidChatDict = [[defaults objectForKey:@"need_chat"] mutableCopy];
    if(nidChatDict == nil){
        return NO;
    }
    
    for(NSString *nid in nidChatDict){
        if(nid == nil || nid.length == 0) continue;
        NSString *needOwnerId = nidChatDict[nid];
        if(needOwnerId == nil || needOwnerId.length == 0) continue;
        if([needOwnerId isEqualToString:[EMClient sharedClient].currentUsername]){
            //我发的订单需要红点
            if(!isMineReceived){
                hasRed = YES;
                return hasRed;
            }
        }else{
            if (nid.length == 64) {
                return hasRed;
            }
            //我接的订单需要红点
            if(isMineReceived){
                hasRed = YES;
                return hasRed;
            }
        }
    }
    
    return hasRed;
    
    /*BOOL hasRed = NO;
     NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
     for(EMConversation *conversation in conversations){
     if(conversation.unreadMessagesCount == 0) continue;
     NSDictionary *ext = conversation.ext;
     if(ext){
     for(NSString *key in ext){
     if([ext[key] isKindOfClass:[NSDictionary class]]){
     NSDictionary *nidExt = (NSDictionary *)ext[key];
     NSString *needOwnerId = [nidExt objectForKey:@"need_owner_id"];
     NSString *hasTemp = [nidExt objectForKey:@"has_temp"];
     if(needOwnerId && [needOwnerId isEqualToString:[EMClient sharedClient].currentUsername]){//是我发的订单
     //我发的订单需要红点
     if(!isMineReceived){
     hasRed = YES;
     break;
     }
     }else{//我接的订单
     //我接的订单需要红点
     if(isMineReceived){
     hasRed = YES;
     break;
     }
     }
     }
     }
     }
     }
     
     return hasRed;*/
}



+(void)updateConversationExt:(EMMessage *)message conversation:(EMConversation *)_conversation
{
    if(_conversation == nil){
        _conversation = [[EMClient sharedClient].chatManager getConversation:message.conversationId type:EMConversationTypeChat createIfNotExist:YES];
    }
    NSDictionary *msgExt = message.ext;
    NSMutableDictionary *ext = [[_conversation ext] mutableCopy];
    NSString *nid, *needOwnerId, *userName, *userPic, *toName, *toPic;
    NSNumber *isBidding = [NSNumber numberWithBool:NO];
    if(ext == nil){
        ext = [[NSMutableDictionary alloc] init];
    }
    if(msgExt == nil){
        [ext setObject:@"true" forKey:@"isfriend"];
    }else{
        nid = [msgExt objectForKey:@"nid"];
        if(nid == nil){
            nid = @"";
        }
        needOwnerId = [msgExt objectForKey:@"need_owner_id"];
        isBidding = [msgExt objectForKey:@"is_bidding"];
        if([message.from isEqualToString:[EMClient sharedClient].currentUsername]){
            userName = [msgExt objectForKey:@"from_name"];
            userPic = [msgExt objectForKey:@"from_pic"];
            toName = [msgExt objectForKey:@"to_name"];
            toPic = [msgExt objectForKey:@"to_pic"];
        }else{
            userName = [msgExt objectForKey:@"to_name"];
            userPic = [msgExt objectForKey:@"to_pic"];
            toName = [msgExt objectForKey:@"from_name"];
            toPic = [msgExt objectForKey:@"from_pic"];
        }
    }
    //    订单消息
    if(nid != nil && nid.length > 0){
        
        NSMutableDictionary *nidExt = [ext objectForKey:nid];
        if(nidExt == nil){
            nidExt = [[NSMutableDictionary alloc] init];
        }
        [nidExt setObject:needOwnerId forKey:@"need_owner_id"];
        
        //        如果订单还未还是交易则该会话属于订单的临时询问
        if(![isBidding boolValue]){
            [nidExt setObject:@"true" forKey:@"has_temp"];//会话里包含临时消息
        }
        [ext setObject:nidExt forKey:nid];
        //[ext setObject:@{@"need_owner_id":needOwnerId, @"is_bidding":[NSNumber numberWithBool:isBidding]} forKey:nid];
    }else{
        //        好友消息
        
        
        
        [ext setObject:@"true" forKey:@"isfriend"];
    }
    if(userName){
        [ext setObject:userName forKey:[NSString stringWithFormat:@"%@_%d_%@", nid, ![isBidding boolValue], @"from_name"]];
    }
    if(userPic){
        [ext setObject:userPic forKey:[NSString stringWithFormat:@"%@_%d_%@", nid, ![isBidding boolValue], @"from_pic"]];
    }
    if(toName){
        [ext setObject:toName forKey:[NSString stringWithFormat:@"%@_%d_%@", nid, ![isBidding boolValue], @"to_name"]];
    }
    if(toPic){
        [ext setObject:toPic forKey:[NSString stringWithFormat:@"%@_%d_%@", nid, ![isBidding boolValue], @"to_pic"]];
    }
    _conversation.ext = ext;
}

+(NSString *)getMessageTitle:(EaseConversationModel *)conversationModel nid:(NSString *)nid{
    NSString *msgTitle;
    NSDictionary *conversationExt = conversationModel.conversation.ext;
    if(nid != nil && nid.length >0 && conversationExt != nil){
        NSDictionary *nidExt = [conversationExt objectForKey:nid];
        
        if(nidExt != nil){
            NSDictionary *titleExt =[nidExt objectForKey:@"latest_message_true"];
            
            if(titleExt == nil){
                msgTitle = [[nidExt objectForKey:@"latest_message_false"] objectForKey:@"title"];
            }else{
                msgTitle = [titleExt objectForKey:@"title"];
            }
        }
    }else if(conversationExt != nil){
        msgTitle = [[conversationExt objectForKey:@"latest_message"] objectForKey:@"title"];
    }
    /*if(msgTitle == nil){
     EMMessage *message = [conversationModel.conversation latestMessage];
     msgTitle = [EaseConversationListViewController titleFromMessage:message];
     [EaseConversationListViewController setLatestMessageTitle:message nid:nid conversation:conversationModel.conversation];
     }*/
    return msgTitle;
}

+(NSDictionary *)getMessageExt:(EaseConversationModel *)conversationModel nid:(NSString *)nid{
    NSDictionary *messageExt;
    NSDictionary *conversationExt = conversationModel.conversation.ext;
    if(nid != nil  && nid.length > 0 && conversationExt != nil){
        NSDictionary *nidExt = [conversationExt objectForKey:nid];
        if(nidExt != nil){
            NSDictionary *titleExt =[nidExt objectForKey:@"latest_message_true"];
            
            if(titleExt == nil){
                messageExt = [[nidExt objectForKey:@"latest_message_false"] objectForKey:@"message"];
            }else{
                messageExt = [titleExt objectForKey:@"message"];
            }
        }
    }else if(conversationExt != nil && [conversationExt objectForKey:@"latest_message"]){
        messageExt = [[conversationExt objectForKey:@"latest_message"] objectForKey:@"message"];
    }
    if(messageExt == nil){
        messageExt = [conversationModel.conversation latestMessage].ext;
    }
    return messageExt;
}

+(void)setLatestMessageTitle:(EMMessage *)message nid:(NSString *)nid conversation:(EMConversation *)conversation {
    
    NSString* latestMessageTitle = [EaseConversationListViewController titleFromMessage:message];
    NSMutableDictionary *conversationExt = [conversation.ext mutableCopy];
    NSMutableDictionary *msgExt = [message.ext mutableCopy];
    if(msgExt == nil) msgExt = [[NSMutableDictionary alloc] init];
    
    if(message.direction == EMMessageDirectionSend){
        
        [msgExt setObject:@"send" forKey:@"direction"];
    }else{
        
        [msgExt setObject:@"receive" forKey:@"direction"];
    }
    if(nid != nil && nid.length > 0 && [msgExt objectForKey:@"nid"] != nil && [nid isEqualToString:[msgExt objectForKey:@"nid"]]){
        
        NSMutableDictionary *nidExt = [[conversationExt objectForKey:nid] mutableCopy];
        if(nidExt == nil){
            nidExt = [[NSMutableDictionary alloc] init];
        }
        if(msgExt != nil){
            
            if([msgExt objectForKey:@"is_bidding"] != nil){
                
                BOOL isBidding = [[msgExt objectForKey:@"is_bidding"] boolValue];
                if(isBidding){
                    
                    [nidExt setObject:@{@"title":latestMessageTitle, @"message":msgExt} forKey:@"latest_message_true"];
                }else{
                    
                    [nidExt setObject:@{@"title":latestMessageTitle, @"message":msgExt} forKey:@"latest_message_false"];
                }
            }
        }
        [conversationExt setObject:nidExt forKey:nid];
        [conversation setExt:conversationExt];
    }else if((nid == nil || nid.length > 0) && [msgExt objectForKey:@"nid"] ==nil){
        [conversationExt setObject:@{@"title":latestMessageTitle, @"message":msgExt} forKey:@"latest_message"];
        [conversation setExt:conversationExt];
    }
}


+(NSString *)titleFromMessage:(EMMessage *)lastMessage
{
    NSString *latestMessageTitle = @"";
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *newConversations = [[NSMutableArray alloc] init];
    for(EMConversation *conversation in conversations){
        if(self.bidUserList != nil && conversation.latestMessage != nil){
            EMMessage *message = conversation.latestMessage;
            BOOL hasBidUser = NO;
            if([message.from isEqualToString:[EMClient sharedClient].currentUsername]){
                hasBidUser = [self.bidUserList containsObject:message.to];
            }else{
                hasBidUser = [self.bidUserList containsObject:message.from];
            }
            if(hasBidUser && self.isFromTemp){
                continue;
            }
        }
        NSDictionary *ext = conversation.ext;
        if(ext){
            if(self.nid != nil && self.nid.length > 0 && [ext objectForKey:self.nid]){
                NSDictionary *conversationExt = [ext objectForKey:self.nid];
                BOOL hasTemp = [conversationExt objectForKey:@"has_temp"]!= nil ? [[conversationExt objectForKey:@"has_temp"] boolValue] : NO;
                if(self.isFromTemp == hasTemp){
                    [newConversations addObject:conversation];
                }
            }else{
                if((self.nid == nil || self.nid.length == 0) &&
                   ([ext objectForKey:@"isfriend"] != nil || [ext allKeys].count == 0)){
                    [newConversations addObject:conversation];
                }
            }
        }else if(self.nid == nil || self.nid.length == 0){
            [newConversations addObject:conversation];
        }
    }
    conversations = newConversations;
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                               modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel lastText:(NSString*) lastText
{
    NSString *latestMessageTitle = [EaseConversationListViewController getMessageTitle:conversationModel nid:self.nid];
    if(latestMessageTitle == nil && lastText != nil){
        latestMessageTitle = lastText;
    }
    if(latestMessageTitle == nil){
        latestMessageTitle = @"";
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}



-(void)showContacter {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //初始化游客登录UI
        [self setupTouristUI];
    }else{
        WQFriendsViewController * vc = [[WQFriendsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupTouristUI {
    self.tabBarController.tabBar.hidden = YES;
    self.loginPopupWindow.hidden = NO;
    [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.loginPopupWindow);
        make.height.offset(280);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.loginPopupWindow layoutIfNeeded];
    }];
    return;
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    vc.isLogin = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

@end
