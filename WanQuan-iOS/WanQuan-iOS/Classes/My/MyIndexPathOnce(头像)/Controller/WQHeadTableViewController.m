//
//  WQHeadTableViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHeadTableViewController.h"
#import "WQHeadTableTableViewCell.h"//横线的cell
#import "WQmeansTableViewCell.h"//资料的cell

static NSString *horizontalcellID = @"horizontalcellid";
static NSString *cellID = @"cellid";
static NSString *meansCellID = @"WQmeansTableViewCellid";

@interface WQHeadTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WQHeadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -- 初始化UI
- (void)setupUI
{
    self.navigationItem.title = @"我的资料";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UITableView *tableview = [[UITableView alloc]init];
    [tableview registerNib:[UINib nibWithNibName:@"WQHeadTableTableViewCell" bundle:nil] forCellReuseIdentifier:horizontalcellID];
    [tableview registerNib:[UINib nibWithNibName:@"WQmeansTableViewCell" bundle:nil] forCellReuseIdentifier:meansCellID];
    //取消分割线
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark -- tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row== 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12 || indexPath.row == 14 || indexPath.row == 16) {
        return 21;
    }else{
    return 97;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row== 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12 || indexPath.row == 14 || indexPath.row == 16) {
        WQHeadTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:horizontalcellID forIndexPath:indexPath];
        return cell;
    }else{
    WQmeansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:meansCellID forIndexPath:indexPath];
    return cell;
    } 
}

@end
