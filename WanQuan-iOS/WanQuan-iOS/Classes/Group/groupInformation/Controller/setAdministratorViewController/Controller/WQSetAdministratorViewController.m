//
//  WQSetAdministratorViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSetAdministratorViewController.h"
#import "WQGroupMemberModel.h"
#import "WQSetAdministratorTableViewCell.h"
#import "WQAddAdministratorTableViewCell.h"
#import "WQTransferGroupManagerViewController.h"
#import "WQUserProfileController.h"

static NSString *identifier = @"identifier";
static NSString *identifieradd = @"WQAddAdministratorTableViewCell";

@interface WQSetAdministratorViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation WQSetAdministratorViewController {
    UITableView *ghTableView;
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    [self setupView];
    [self loadList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    self.navigationItem.title = @"设置圈管理员";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarbtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarbtn;
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
}

#pragma mark -- 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 请求数据
- (void)loadList {
    // 获取已加入群成员的头像
    NSString *urlString = @"api/group/groupmemberlist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.gid;
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
            
            NSArray *list = [NSArray yy_modelArrayWithClass:[WQGroupMemberModel class] json:response[@"members"]];
            
            [dataArray removeAllObjects];
            for (WQGroupMemberModel *model in list) {
                // 不是群主  并且是管理员
                if (![model.isOwner boolValue] && [model.isAdmin boolValue]) {
                    [dataArray addObject:model];
                }
            }
            
            [ghTableView reloadData];
        }
    }];
}

#pragma mark -- 初始化UI
- (void)setupView {
    ghTableView = [[UITableView alloc] init];
    ghTableView.dataSource = self;
    ghTableView.delegate = self;
    // 注册cell
    [ghTableView registerClass:[WQAddAdministratorTableViewCell class] forCellReuseIdentifier:identifieradd];
    [ghTableView registerClass:[WQSetAdministratorTableViewCell class] forCellReuseIdentifier:identifier];
    // 取消分割线
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置tableview的边距
    if (@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
}

#pragma mark -- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kScaleX(55);
    }else {
        return kScaleX(74);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 30;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @" ";
    }else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    backgroundView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    // 数量
    UILabel *countLabel = [UILabel labelWithText:[NSString stringWithFormat:@"(%zd / 2)",dataArray.count] andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [backgroundView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    return backgroundView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WQAddAdministratorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifieradd forIndexPath:indexPath];
        
        return cell;
    }else {
        WQSetAdministratorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.model = dataArray[indexPath.row];
        
        __weak typeof(cell) weakCell = cell;
        [cell setHeadPortraitViewClickBlock:^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
            // 是自己
            if ([weakCell.model.user_id isEqualToString:im_namelogin]) {
                WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:weakCell.model.user_id];
                
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                // 不是自己
                WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:weakCell.model.user_id];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQTransferGroupManagerViewController *vc = [[WQTransferGroupManagerViewController alloc] init];
        [vc setAddSuccessBlock:^{
            [self loadList];
        }];
        vc.type = wqAdministrator;
        vc.gid = self.gid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//把NSArray转为一个json字符串
- (NSString *)arrayToString:(NSArray *)array {
    
    NSString *str = @"['";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            str = [str stringByAppendingString:@"','"];
        }
        str = [str stringByAppendingString:array[i]];
    }
    str = [str stringByAppendingString:@"']"];
    
    return str;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 1) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消管理员" handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull indexPath) {
            NSString *urlString = @"api/group/setgroupadmin";
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
            params[@"gid"] = self.gid;
            WQGroupMemberModel *model = dataArray[indexPath.row];
            NSArray *uidArray = @[model.user_id];
            params[@"uid"] = [self arrayToString:uidArray];
            params[@"admin"] = @"false";
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
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"取消成功" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                            [self loadList];
                        });
                    }];
                }
            }];
        }];
        action.backgroundColor = [UIColor colorWithHex:0x9767D0];
    
        return @[action];
    }else {
        return [NSArray new];
        
    }
}
             
@end
