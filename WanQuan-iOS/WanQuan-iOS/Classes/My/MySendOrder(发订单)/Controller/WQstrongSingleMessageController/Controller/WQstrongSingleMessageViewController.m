//
//  WQstrongSingleMessageViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQstrongSingleMessageViewController.h"

@interface WQstrongSingleMessageViewController () <EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>

@end

@implementation WQstrongSingleMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    EaseConversationListViewController *chatListVC = [[EaseConversationListViewController alloc] init];
    //chatListVC.dataSource = self;
    chatListVC.delegate = self;
    [chatListVC tableViewDidTriggerHeaderRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"临时会话";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
}

/*@method
@brief 获取点击会话列表的回调
@discussion 获取点击会话列表的回调后,点击会话列表用户可以根据conversationModel自定义处理逻辑
@param conversationListViewController 当前会话列表视图
@param IConversationModel 会话模型
@result
*/
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    
}

@end
