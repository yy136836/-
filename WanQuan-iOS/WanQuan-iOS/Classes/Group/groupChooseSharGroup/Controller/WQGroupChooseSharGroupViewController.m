//
//  WQGroupChooseSharGroupViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupChooseSharGroupViewController.h"
#import "WQGroupChooseSharGroupTableViewCell.h"
#import "WQGroupModel.h"
#import "WQShowGroupInputView.h"

static NSString *identifier = @"identifier";

@interface WQGroupChooseSharGroupViewController () <UITableViewDelegate, UITableViewDataSource,WQShowGroupInputViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) WQShowGroupInputView *showGroupInputView;

@end

@implementation WQGroupChooseSharGroupViewController {
    NSMutableArray *tableViewdetailOrderData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    tableViewdetailOrderData = [NSMutableArray array];
    self.index = 2000;
    [self loadList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *submitBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBarBtnClike)];
    self.navigationItem.rightBarButtonItem = submitBarItem;
    [submitBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    self.navigationItem.title = @"选择圈子";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector()];
//    self.navigationItem.leftBarButtonItem = leftBarbtn;
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
//    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 完成的响应事件
- (void)submitBarBtnClike {
    self.showGroupInputView.hidden = NO;
    [self.showGroupInputView.textView becomeFirstResponder];
//    CGRect popupWindowView = self.showGroupInputView.frame;
//    popupWindowView.origin.y = self.view.bounds.origin.y - 50;
//    popupWindowView.size.height = kScreenHeight + ghNavigationBarHeight;
//    popupWindowView.size.width = kScreenWidth;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.showGroupInputView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
//        self.showGroupInputView.frame = popupWindowView;
//    }];
}

#pragma mark -- 初始化Tabelview
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"WQGroupChooseSharGroupTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    tableView.estimatedRowHeight = 80;
    tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark -- 获取数据
- (void)loadList {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/group/mygrouplist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
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
            [self setupTableView];
            [SVProgressHUD dismissWithDelay:1];
            tableViewdetailOrderData = [NSMutableArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]].mutableCopy;
            
            
            
            
            
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
            });
        }];
        return;
    }
    if ([[showGroupInputView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请勿为空" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    
    
    self.showGroupInputView.hidden = YES;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在转发中,请稍候..."];
    

//    TODO
    NSString *urlString;
    if (self.shareType == ShareTypeNeed) {
        urlString = @"api/need/fwneedtogroup";
        self.params[@"nid"] = self.nid;
    } else {
//         TODOHanyang
        urlString = @"";
        self.params[@""] = self.nid;
    }
    
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"content"] = showGroupInputView.textView.text;
    WQGroupModel *model;
    
    if (self.index<tableViewdetailOrderData.count) {
        model = tableViewdetailOrderData[self.index];
        self.params[@"gid"] = model.gid;
    }
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:self.params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"转发不成功，请重试"];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD dismissWithDelay:0];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转发成功" preferredStyle:UIAlertControllerStyleAlert];
    
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"转发不成功，请重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQGroupChooseSharGroupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.index != indexPath.row) {
        cell.hookImageView.hidden = NO;
        //self.params[@"gid"] = cell.model.gid;
        // 记录点击的index在刷新数据源,如果index==当前.row的话显示对勾
        self.index = indexPath.row;
        [tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupChooseSharGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = tableViewdetailOrderData[indexPath.row];
    if (self.index == indexPath.row) {
        cell.hookImageView.hidden = NO;
    }else {
        cell.hookImageView.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark -- 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (WQShowGroupInputView *)showGroupInputView {
    if (!_showGroupInputView) {
        _showGroupInputView = [[WQShowGroupInputView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
        
        _showGroupInputView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
        _showGroupInputView.delegate = self;
        [kAppWindow addSubview:_showGroupInputView];
    }
    return _showGroupInputView;
}

@end
