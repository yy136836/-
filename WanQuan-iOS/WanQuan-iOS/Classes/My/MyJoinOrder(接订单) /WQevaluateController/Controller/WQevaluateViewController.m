//
//  WQevaluateViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQevaluateViewController.h"
#import "WQevaluateTableViewCell.h"

static NSString *cellID = @"cellid";

@interface WQevaluateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSIndexPath *index;
@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, copy) NSString *needId;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation WQevaluateViewController

- (instancetype)initWithneedId:(NSString *)needId
{
    if (self = [super init]) {
        self.needId = needId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 初始化UI
- (void)setupUI
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"评价";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitClike)];
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    UITableView *tableView = [[UITableView alloc]init];
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"WQevaluateTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - 监听事件
- (void)submitClike
{
    NSString *urlString = @"api/need/feedbackneedbid";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    if (!_index) {
        [WQAlert showAlertWithTitle:nil message:@"请选择评价!" duration:1.3];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{}];
        return;
    }
    if (self.index.row == 0) {
        _params[@"score"] = @"100";
    }
    if (self.index.row == 1) {
        _params[@"score"] = @"60";
    }
    if (self.index.row == 2) {
        _params[@"score"] = @"40";
    }
    _params[@"nbid"] = self.needId;
    _params[@"content"] = @"评价内容";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"评价成功，将会影响对方信用分数"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:^{
                        // 回调
                        if ([self respondsToSelector:@selector(wqEvaluateViewControllerRefresh:)]) {
                            [self.delegate wqEvaluateViewControllerRefresh:self];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }];
        }else
        {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQevaluateTableViewCell *cell = [tableView cellForRowAtIndexPath:self.index];
    cell.checkImage.hidden = YES;
    WQevaluateTableViewCell *celltwo = [tableView cellForRowAtIndexPath:indexPath];
    celltwo.checkImage.hidden = NO;
    
    self.index = indexPath;
    if (indexPath.row == 0) {
        self.integer = 0;
        if (self.didSelectBlock) {
            self.didSelectBlock(self.integer);
        }
    }else if (indexPath.row == 1)
    {
        self.integer = 1;
        if (self.didSelectBlock) {
            self.didSelectBlock(self.integer);
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQevaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.titleArray[indexPath.row];
    return cell;
}

#pragma mark - 懒加载
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"优秀",@"及格",@"不及格"];
    }
    return _titleArray;
}
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
