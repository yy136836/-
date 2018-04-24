//
//  WQTransferGroupManagerViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTransferGroupManagerViewController.h"
#import "WQTransferGroupManagerTableViewCell.h"
#import "WQGroupMemberModel.h"
#import "WQUserProfileController.h"
#import "WQPrefixHeader.pch"

static NSString *identifier = @"identifier";

@interface WQTransferGroupManagerViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImage * selectedImage;
@property (nonatomic, retain) UIImage * normalImage;
@property (nonatomic, retain) NSMutableArray * filterData;
@end

@implementation WQTransferGroupManagerViewController {
    UITableView *ghTableView;
    NSArray *tableViewdetailOrderData;
    NSString *uid;
    UISearchBar * search;
    
    // 设置管理员的数据源modelArray
    NSMutableArray *modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadList];
    self.index = 200000;
    uid = [[NSString alloc] init];
    _selectedImage = [UIImage imageNamed:@"member_selected"];
    _normalImage = [UIImage imageNamed:@"member_normal"];
    self.view.backgroundColor = [UIColor whiteColor];
    _filterData = @[].mutableCopy;
    modelArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    if (self.type == wqAdministrator) {
        self.navigationItem.title = @"选择圈成员";
    }else {
        self.navigationItem.title = @"圈成员";
    }
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClick)];
    [submitBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = submitBtn;
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

- (void)submitBtnClick {
    // 设置管理员
    if (self.type == wqAdministrator) {
        NSString *urlString = @"api/group/setgroupadmin";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"gid"] = self.gid;
        NSArray *uidArray = @[uid];
        params[@"uid"] = [self arrayToString:uidArray];
        params[@"admin"] = @"true";
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
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        if (self.addSuccessBlock) {
                            self.addSuccessBlock();
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:WQSetgroupadminSuccessful object:self];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }else {
        NSString *urlString = @"api/group/changegroupowner";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"gid"] = self.gid;
        params[@"uid"] = uid;
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
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转让成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    
    ghTableView = [[UITableView alloc] init];
    // 设置自动行高和预估行高
    ghTableView.rowHeight = 75;
    ghTableView.estimatedRowHeight = 75;
    // 取消分割线
    // ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [ghTableView registerNib:[UINib nibWithNibName:@"WQTransferGroupManagerTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    // 设置代理对象
    ghTableView.dataSource = self;
    ghTableView.delegate = self;
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT));
        make.bottom.left.right.equalTo(self.view);
//        make.edges.equalTo(self.view);
    }];
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    ghTableView.tableHeaderView = search;
    ghTableView.tableFooterView = [UIView new];
    ghTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    search.placeholder = @"搜索"; // placeholder
    search.delegate = self;
    ghTableView.showsVerticalScrollIndicator = NO;

}

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
            tableViewdetailOrderData = [NSArray yy_modelArrayWithClass:[WQGroupMemberModel class] json:response[@"members"]];
            
            if (self.type == wqAdministrator) {
                [modelArray removeAllObjects];
                for (WQGroupMemberModel *model in tableViewdetailOrderData) {
                    // 是群主或者是管理员
                    if ([model.isOwner boolValue] || [model.isAdmin boolValue]) {
                        continue;
                    }else {
                        [modelArray addObject:model];
                    }
                }
            }
            
            [self setupTableView];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.type == wqAdministrator) {
        return search.isFirstResponder && search.text.length ? _filterData.count: modelArray.count;
    }else {
        return search.isFirstResponder && search.text.length ? _filterData.count: tableViewdetailOrderData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTransferGroupManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.type == wqAdministrator) {
        cell.model = search.isFirstResponder&& search.text.length ? _filterData[indexPath.row] : modelArray[indexPath.row];
    }else {
        cell.model = search.isFirstResponder&& search.text.length ? _filterData[indexPath.row] : tableViewdetailOrderData[indexPath.row];
    }
    
    if (uid == cell.model.user_id) {
        cell.selectedImage.image = _selectedImage;
    }else {
        cell.selectedImage.image = _normalImage;
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTransferGroupManagerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (self.index != indexPath.row) {
        cell.selectedImage.image = _selectedImage;
        // 记录点击的index在刷新数据源,如果index==当前.row的话显示对勾
        self.index = indexPath.row;
        uid = cell.model.user_id;
        [tableView reloadData];
//    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    uid = @"";
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    uid = @"";
    [_filterData removeAllObjects];
   
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_filterData removeAllObjects];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [searchBar resignFirstResponder];
        [ghTableView reloadData];
        return;
    }
    NSString *filterString = searchText;
    
    for (WQGroupMemberModel * model in tableViewdetailOrderData) {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    
        if  ([predicate evaluateWithObject: model.user_name ]) {
            [_filterData addObject:model];
        }
    }
    
    [ghTableView reloadData];
}


@end
