//
//  WQNewMembersViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewMembersViewController.h"
#import "WQNewMembersTableViewCell.h"
#import "WQWaitingForAuditModel.h"
#import "WQPendingUserController.h"

static NSString *identifier = @"identifier";

@interface WQNewMembersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;

@end

@implementation WQNewMembersViewController {
    UITableView *ghTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"新成员";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewdetailOrderData = [[NSMutableArray alloc] init];
    
    [self setupTableView];
    [self loadList];
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    ghTableView = [[UITableView alloc] init];
    // 取消分割线
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [ghTableView registerClass:[WQNewMembersTableViewCell class] forCellReuseIdentifier:identifier];
    // 设置代理对象
    ghTableView.dataSource = self;
    ghTableView.delegate = self;
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 群主获取群组新加入（待审批）成员的列表
- (void)loadList {
    NSString *urlString = @"api/group/groupnewmemberlist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.groupId;
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
            self.tableViewdetailOrderData = [NSArray yy_modelArrayWithClass:[WQWaitingForAuditModel class] json:response[@"fresh_members"]].mutableCopy;
            [ghTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQNewMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.tableViewdetailOrderData[indexPath.row];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    // 点击同意入群
    [cell setAgreedToBtnClikeBlock:^{
        [weakSelf agreeWithUserId:weakCell.model.user_id];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQWaitingForAuditModel * model = _tableViewdetailOrderData[indexPath.row];
    
    WQPendingUserController * vc = [[WQPendingUserController alloc] init];
    vc.uid = model.user_id;
    vc.gid = self.groupId;
    vc.requestInfo = model.message;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    
    UITableViewRowAction* action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull indexPath) {
        WQNewMembersTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *urlString = @"api/group/removenewgroupmember";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"gid"] = self.groupId;
        NSArray *uidArray = @[cell.model.user_id];
        NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
        params[@"uid"] = idcardStr;
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            
            NSLog(@"%@",response);
            if (![response[@"success"] boolValue]) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }else {
                // 操作成功删除
                [self.tableViewdetailOrderData removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
                [tableView reloadData];
                if (self.operationIsSuccessfulBlock) {
                    self.operationIsSuccessfulBlock();
                }
            }
        }];
        
    }];
    
    action2.backgroundColor = [UIColor redColor];
    
    return @[action2];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WQWaitingForAuditModel * model = _tableViewdetailOrderData[indexPath.row];
//    
//    if (model) {
//        WQPendingUserController * vc = [[WQPendingUserController alloc] init];
//        vc.uid = model.user_id;
//        vc.gid = self.groupId;
////        vc.
//    }
//    
//}


#pragma mark - 同意入群
- (void)agreeWithUserId:(NSString *)userid {
    NSString *urlString = @"api/group/agreenewgroupmember";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.groupId;
    NSArray *uidArray = @[userid];
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"uid"] = idcardStr;
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
            [self loadList];
            if (self.operationIsSuccessfulBlock) {
                self.operationIsSuccessfulBlock();
            }
        }
    }];
}

@end
