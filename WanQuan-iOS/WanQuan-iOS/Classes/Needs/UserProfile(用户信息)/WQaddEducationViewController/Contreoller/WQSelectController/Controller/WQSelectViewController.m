//
//  WQSelectViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSelectViewController.h"
#import "WQSelectTableViewCell.h"

static NSString *cellid = @"cellid";

@interface WQSelectViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *arrAy;
@property (nonatomic, strong) NSIndexPath *index;
@end

@implementation WQSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrAy = @[@"中学及以下",@"大专",@"本科",@"硕士",@"博士"];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title = @"选择学位";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClike)];
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarbtnClick)];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma make - 监听事件
- (void)submitBtnClike
{
    if ([self.delegate respondsToSelector:@selector(wqSelectViewControllerWithvc:index:)]) {
        [self.delegate wqSelectViewControllerWithvc:self index:self.index];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma make - 初始化UI
- (void)setUpUI
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"WQSelectTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.badgeBgColor = WQ_BG_LIGHT_GRAY;
}

#pragma make - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:self.index];
    cell.checkImage.hidden = YES;
    WQSelectTableViewCell *celltwo = [tableView cellForRowAtIndexPath:indexPath];
    celltwo.checkImage.hidden = NO;
    
    self.index = indexPath;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrAy.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.arrAy[indexPath.row];
    return cell;
}

@end
