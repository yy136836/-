//
//  WQsessionCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQsessionCollectionViewCell.h"

static NSString *cellid = @"WQsessionCollectionViewCellid";

@interface WQsessionCollectionViewCell() <UITableViewDataSource,UITableViewDelegate,EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate>

@end

@implementation WQsessionCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setupUI];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    /*EaseConversationListViewController *vc = [EaseConversationListViewController new];
    vc.dataSource = self;
    [self.contentView addSubview:vc.view];*/
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if(conversation.ext){
            if([conversation.ext objectForKey:@"isfriend"]){
                unreadCount += conversation.unreadMessagesCount;
            }
        }
    }
    //self.messageCount = unreadCount;
    //[self.tableView reloadData];
//    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}

@end
