//
//  WQShareFriendListController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQShareFriendListController.h"
#import "WQfriendsModel.h"
#import "WQGroupMemberModel.h"
#import "WQAddGroupMemberCell.h"
#import "EaseMessageViewController.h"
#import "EaseSDKHelper.h"
#import "WQShareToFriendCell.h"

@interface WQShareFriendListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSMutableArray * modelArray;
@property (nonatomic, retain) NSMutableArray * selectedIds;
@property (nonatomic, retain) NSMutableArray * selectedModels;

@property (nonatomic, copy) NSString * des;
@end

@implementation WQShareFriendListController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self setupUI];
    _selectedIds = @[].mutableCopy;
    _selectedModels = @[].mutableCopy;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor ],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    [self fetchGroupInfo];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"好友";
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(handleSubmit)];
    self.navigationItem.rightBarButtonItem = item;
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
//                        forState:UIControlStateNormal];
//
//    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = left;
//
//    [left setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [self requestData];
    
}

- (void)fetchGroupInfo {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/group/getgroupinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"gid"] = self.gid;
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        self.groupModel = [WQGroupModel yy_modelWithJSON:response];
        
        self.des = response[@"description"];
        [SVProgressHUD dismissWithDelay:1];
    }];
    
}

#pragma mark - 初始化UI
- (void)setupUI {
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationItem.title = @"好友";

    
    
    
    UITableView *tableView = [[UITableView alloc]init];
    
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"WQShareToFriendCell" bundle:nil] forCellReuseIdentifier:@"WQShareToFriendCell"];
    [self.view addSubview:tableView];
    
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(@64);
    }];
    
    tableView.tableFooterView = [UIView new];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    
//    tableView.editing = YES;
    tableView.allowsMultipleSelection = YES;

    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.separatorColor = WQ_SEPARATOR_COLOR;
    //tableView.sectionIndexBackgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
}




#pragma mark - tableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    WQfriendsModel *model = self.modelArray[section];
    return model.friend_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQShareToFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQShareToFriendCell"];
    
    
    
    WQfriendsModel *model = self.modelArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.model = model.friend_list[indexPath.row];
    
    
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * titles = @[].mutableCopy;
    for (WQfriendsModel * model in self.modelArray) {
        [titles addObject:model.first_spell];
    }
    return titles;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    
    WQfriendsModel *model = self.modelArray[section];
    return model.first_spell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQAddGroupMemberCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    WQfriend_listModel * model = cell.model;
    [_selectedIds addObject:model.user_id];
    [_selectedModels addObject:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"%@",_selectedIds);
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQAddGroupMemberCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    WQfriend_listModel * model = cell.model;
    [_selectedIds removeObject:model.user_id];
    [_selectedModels removeObject:model];
    NSLog(@"%@",_selectedIds);
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)requestData {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    dict[@"degree"] = @(1).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.modelArray = [NSMutableArray yy_modelArrayWithClass:[WQfriendsModel class] json:response[@"friends"]].mutableCopy;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void)handleSubmit {
    
    
    
    //    {
    //        "from_name" = "李娜";
    //        "from_pic" = beaf7a1860144272850639db934f1ac8;
    //        group = "{\"name\":\"Belight\",\"gid\":\"fedd9d2e57b243ed87272b58cf6690d3\",\"description\":\"测试群\",\"pic\":\"72d9017edd6b478a9db4a6bb4a89943e\",\"member_count\":\"6\"}";
    //        isBidTureName = 1;
    //        "is_bidding" = 0;
    //        istruename = 1;
    //        "to_name" = "韩扬";
    //        "to_pic" = 6698d58f23144f069ec9d7bea1927721;
    //    }
    
    
    //    {\"name\":\"Belight\",\"gid\":\"fedd9d2e57b243ed87272b58cf6690d3\",\"member_count\":\"6\",\"description\":\"测试群\"}
    
    dispatch_group_t group = dispatch_group_create();
    for (WQfriendsModel * model in self.selectedModels) {
        EMMessageBody * body = [[EMTextMessageBody alloc] initWithText:@"群邀请"];
        
        NSDictionary * extGroupInfo = @{@"name":self.groupModel.name,
                                        @"gid":self.gid,
                                        @"member_count":[NSString stringWithFormat:@"%@",self.groupModel.member_count],
                                        @"description":self.des.length?self.des:@"",
                                        @"pic":self.groupModel.pic};
        NSData * data = [NSJSONSerialization dataWithJSONObject:extGroupInfo options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString * fromName = [[NSUserDefaults standardUserDefaults] objectForKey:@"true_name"];
        NSString * fromPic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pic_truename"];
        
        
//        
//        isBidTureName = 1;
//        "is_bidding" = 1;
//        istruename = 1;
        
        NSDictionary * ext = @{@"group" : str,
                               @"from_name":fromName,
                               @"from_pic":fromPic,
                               @"to_name":model.true_name,
                               @"to_pic":model.pic_truename,
                               @"istruename":@(YES),
                               @"is_bidding":@(YES),
                               @"isBidTureName":@(YES)};
        
        EMMessage * message = [[EMMessage alloc] initWithConversationID:model.user_id from:[[EMClient sharedClient] currentUsername]  to:model.user_id body:body ext:ext];
        
        
        
        message =  [EaseSDKHelper sendTextMessage:@"群名片" to:model.user_id
                                      messageType:EMChatTypeChat
                                       messageExt:ext];
        

        
    
        
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:message.conversationId type:EMConversationTypeChat createIfNotExist:YES];
        [EaseConversationListViewController updateConversationExt:message conversation:conversation];
        
        dispatch_group_enter(group);
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            
        } completion:^(EMMessage *message, EMError *error) {
            dispatch_group_leave(group);
            
        }];
        
    }
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [WQAlert showAlertWithTitle:nil message:@"已发送" duration:1.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           [self.navigationController popViewControllerAnimated:YES];
                       });
    });
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
