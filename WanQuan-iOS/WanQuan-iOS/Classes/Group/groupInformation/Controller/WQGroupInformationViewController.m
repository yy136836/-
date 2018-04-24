//
//  WQGroupInformationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupInformationViewController.h"
#import "WQGroupInformationTableViewCell.h"
#import "WQGroupInformationHeader.h"
#import "WQGetgroupInfoModel.h"
#import "WQInviteNewMemberController.h"
#import "WQShareFriendListController.h"
#import "WQaddFriendsController.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
#import "WQShowGroupInputView.h"
#import "WQRelationsCircleHomeViewController.h"
#import "WQGroupDynamicViewController.h"
#import "WQUserProfileController.h"
static NSString *identifier = @"identifier";

@interface WQGroupInformationViewController () <UITableViewDelegate, UITableViewDataSource,WQShowGroupInputViewDelegate,UIGestureRecognizerDelegate,WQMainNameDelegate>

@property (nonatomic, strong) WQGroupInformationHeader *headerView;
@property (nonatomic, strong) WQShowGroupInputView *showGroupInputView;
@property (nonatomic, strong) WQGetgroupInfoModel *model;
//@property (nonatomic, retain) UIWindow * bgWindow;
// 底部按钮
@property (nonatomic, strong) UIButton *bottomBtn;
// 上传图片成功后的id
@property (nonatomic, copy) NSString *imageId;
@property (nonatomic, strong) id response;

/**
 是否是私密圈
 */
@property (nonatomic, assign) BOOL isPrivacy;
@end

@implementation WQGroupInformationViewController {
    NSString *contentText;
    // 当前群成员总数量
    NSString *member_count;
    UITableView *ghTableView;
    // 底部按钮
    //UIButton *bottomBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 0.5)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQSetgroupadminSuccessful object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    contentText = [[NSString alloc] init];
    
    ghTableView = [[UITableView alloc] init];
    // 设置头部试图
    WQGroupInformationHeader *headerView = [[WQGroupInformationHeader alloc] initWithFrame:CGRectMake(0, 0, 0, kScreenWidth)];
    headerView.delegte = self;
    [headerView setIsGroupHeadClikeBlock:^{
        [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
            
            if (image == nil) {
                return ;
            }
            [self modifyHeadPortrait:image];
        }];
    }];
    
    if (@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.headerView = headerView;
    ghTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    ghTableView.tableHeaderView = headerView;
    // 设置自动行高和预估行高
    ghTableView.rowHeight = UITableViewAutomaticDimension;
    ghTableView.estimatedRowHeight = 70;
    // 取消分割线&滚动条
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghTableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [ghTableView registerClass:[WQGroupInformationTableViewCell class] forCellReuseIdentifier:identifier];
    // 设置代理对象
    ghTableView.dataSource = self;
    ghTableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-75);
    }];

    // 底部按钮
    UIButton *bottomBtn = [[UIButton alloc] init];
    self.bottomBtn = bottomBtn;
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bottomBtn setTitle:@"邀请新成员" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    [bottomBtn addTarget:self action:@selector(invitationClike) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghCellHeight);
        make.left.equalTo(self.view).offset(16);
        make.right.bottom.equalTo(self.view).offset(-16);
    }];
}

- (void)clickedMainName
{
  
    // 不是群主不能更换头像
    if (![self.response[@"isOwner"] boolValue] && ![self.response[@"isAdmin"] boolValue]) {
        self.headerView.groupHeadImageView.userInteractionEnabled = NO;
    }
    
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:self.response[@"owner_id"]];
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 更改群头像
- (void)modifyHeadPortrait:(UIImage *)image {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    NSString *urlString = @"file/upload";
    
    [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImageJPEGRepresentation(image, 0.7);
        [formData appendPartWithFileData:data name:@"file" fileName:@"wanquantupian" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        NSLog(@"success : %@", responseObject);
        self.imageId = responseObject[@"fileID"];
        [self upData:self.imageId];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
        [SVProgressHUD dismissWithDelay:1];
    }];
}

- (void)upData:(NSString *)imageId {
    NSString *urlString = @"api/group/updategroup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.gid;
    params[@"pic"] = imageId;
    
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
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.1];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈头像更换成功" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
}

#pragma mark - 退群的btn响应事件
- (void)deleteBtnClike {
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确定删除并退出此群吗?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSLog(@"确定取出此群");
                                                                  [self determineRefundGroupOf];
                                                              }];
//    [destructiveButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
//    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 确定退出此群
- (void)determineRefundGroupOf {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在退出群 :("];
    NSString *urlString = @"api/group/quitgroup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
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
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD dismissWithDelay:0.2];
            [[NSNotificationCenter defaultCenter] postNotificationName:WQdetermineRefundGroupOf object:self];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WQRelationsCircleHomeViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

#pragma mark -- WQShowGroupInputViewDelegate
// 弹窗的取消的点击事件
- (void)wqCancelBtnClike:(WQShowGroupInputView *)showGroupInputView {
    self.showGroupInputView.hidden = YES;
}
// 弹窗的提交的点击事件
- (void)wqSubmitBtnClike:(WQShowGroupInputView *)showGroupInputView {
    if (showGroupInputView.textView.text.length > 50) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请勿输入超50个字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        return;
    }
    self.showGroupInputView.hidden = YES;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在转发至万圈...."];
    NSString *urlString = @"api/moment/status/createstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"content"] = self.showGroupInputView.textView.text;
    NSDictionary *dict = @{@"group_id":self.gid,@"group_pic":self.model.pic,@"group_name":self.model.name,@"group_desc":self.response[@"description"]};
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    params[@"extras"] = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"cate"] = @"CATE_GROUP";
    
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
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            // [SVProgressHUD dismissWithDelay:0.2];
            [SVProgressHUD dismiss];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转发成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

#pragma mark - 邀请新成员的响应事件
- (void)invitationClike {
    
    
//    WQInviteNewMemberController * vc = [[WQInviteNewMemberController alloc] init];
//
//    [self addChildViewController:vc];
//
//    [vc didMoveToParentViewController:self];
//
//    [self.view addSubview:vc.view];
//
//    // 第三方
//    vc.shereToThird = ^{
        //显示分享面板
    __weak typeof(self) weakSelf = self;
    
    [WQSingleton sharedManager].platname = @"WQHY";
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
            if(platformType == UMSocialPlatformType_Sina){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
            }else if(platformType == UMSocialPlatformType_Sms){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
            }else if (platformType == UMSocialPlatformType_QQ){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
            }else if (platformType == UMSocialPlatformType_Qzone){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
            }else if (platformType == UMSocialPlatformType_WechatSession){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
            }else if (platformType == UMSocialPlatformType_WechatTimeLine){
                [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
            }else if (platformType == WQFriend){
                WQShareFriendListController * vc = [[WQShareFriendListController alloc] init];
                vc.gid = self.gid;
                vc.groupModel = self.groupModel;
                vc.gid = self.gid;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(platformType == WQCopyLink){
                NSString *copyLink=  [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/group?gid=%@",self.gid];
                [WQTool copy:self urlStr:copyLink];
            }
        }];
    
//    // 万圈
//    vc.shareToMiriade = ^{
//        self.showGroupInputView.hidden = NO;
//        CGRect popupWindowView = self.showGroupInputView.frame;
//        popupWindowView.origin.y = self.view.bounds.origin.y;
//        popupWindowView.size.height = kScreenHeight;
//        popupWindowView.size.width = kScreenWidth;
//        [UIView animateWithDuration:0.5 animations:^{
//            self.showGroupInputView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
//            self.showGroupInputView.frame = popupWindowView;
//        }];
//    };

    // APP内好友
//    vc.shareToEMFriend = ^{
//        WQShareFriendListController * vc = [[WQShareFriendListController alloc] init];
//        vc.gid = self.gid;
//
////        WQGroupModel * model = [[WQGroupModel alloc] init];
////
////        model.name = self.model.name;
////        model.pic = self.model.pic;
////        model.
////
//        vc.groupModel = self.groupModel;
//
//        vc.gid = self.gid;
//
//
//        [self.navigationController pushViewController:vc animated:YES];
//    };

    NSLog(@"邀请新成员");
}

#pragma mark - 加入群组
- (void)joinGroupClike {
    WQaddFriendsController *vc = [[WQaddFriendsController alloc] init];
    vc.gid = self.gid;
    vc.type = @"加入圈";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 立即加入的响应事件
- (void)immediatelyJoin {
    NSString *urlString = @"api/group/applyjoingroup";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"gid"] = self.gid;
    params[@"message"] = @"";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"已成功加入圈子" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self dismissViewControllerAnimated:self completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:WQjoinSuccess object:self];
                    }];
                });
            }];
            return ;
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
    }];
}

#pragma mark - 请求数据
- (void)loadData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/group/getgroupinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
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
        
        NSLog(@"%@",response);
        self.response = response;
        if ([response[@"success"] boolValue]) {
            self.isPrivacy = [response[@"privacy"] boolValue];
            member_count = response[@"member_count"];
            WQGetgroupInfoModel *model = [WQGetgroupInfoModel yy_modelWithJSON:response];
            self.model = model;
            NSString *picUrl = [imageUrlString stringByAppendingString:model.pic];
            [self.headerView.groupHeadImageView yy_setImageWithURL:[NSURL URLWithString:picUrl] options:0];
            self.headerView.groupNameLabel.text = model.name;
            self.headerView.GroupmainName.text =  [NSString stringWithFormat:@"圈主:%@",model.owner_name];
            //self.navigationItem.title = self.model.name;
            
            contentText = response[@"description"];
            // 如果不是群主或者是没有加入群的的话添加itme
            if (![response[@"isOwner"] boolValue] && [response[@"isMember"] boolValue]) {
                UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dingdanshanchu"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteBtnClike)];
                self.navigationItem.rightBarButtonItem = deleteBtn;
            }
            
          
            
            [ghTableView reloadData];
            [SVProgressHUD dismissWithDelay:1];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.groupId = self.gid;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.member_count = member_count;
    cell.model = self.model;
    cell.contentLabel.text = contentText;
    
    // 没有加入该群的,底部按钮显示加入群组
    [cell setIsMemberBlock:^{
        [weakSelf.bottomBtn removeTarget:weakSelf action:@selector(invitationClike) forControlEvents:UIControlEventTouchUpInside];
        // 是否是私密圈
        if (self.isPrivacy) {
            [weakSelf.bottomBtn setTitle:@"申请加入" forState:UIControlStateNormal];
            [weakSelf.bottomBtn addTarget:weakSelf action:@selector(joinGroupClike) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [weakSelf.bottomBtn setTitle:@"立即加入" forState:UIControlStateNormal];
            [weakSelf.bottomBtn addTarget:weakSelf action:@selector(immediatelyJoin) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
    
    // 刷新数据
    [cell setIsLoadDataBlockBlock:^{
        // [tableView reloadData];
        [weakSelf loadData];
    }];
    
    return cell;
}

#pragma mark -- 懒加载
- (WQShowGroupInputView *)showGroupInputView {                                          
    if (!_showGroupInputView) {
        _showGroupInputView = [[WQShowGroupInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
        _showGroupInputView.backgroundColor = [UIColor colorWithHex:0Xb2b2b2];
        _showGroupInputView.delegate = self;
        [self.view addSubview:_showGroupInputView];
    }
    return _showGroupInputView;
}

#pragma mark - 第三方分享
//分享不同的内容到平台platformType
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    switch (index) {
        case 0:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            break;
        case 1:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sms];
            break;
        case 2:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;
        case 3:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;
        case 4:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            break;
        case 5:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;
        default:
            break;
    }
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *moneySplicecontent = [NSString stringWithFormat:@"%@",self.response[@"description"]];
    //创建网页内容对象
    NSString *thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
    NSString *str = @"我在圈子「";
    
    NSString *str1 = @"」一起加入吧！";
    NSString *titleString = [str stringByAppendingString:[[NSString stringWithFormat:@"%@",self.response[@"name"]] stringByAppendingString:str1]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:moneySplicecontent thumImage:thumbURL];
    
    //设置网页地址
    NSString *shardString = @"http://wanquan.belightinnovation.com/front/share/group?gid=";
    shareObject.webpageUrl = [shardString stringByAppendingString:[NSString stringWithFormat:@"%@",self.gid]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj {
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}


- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
