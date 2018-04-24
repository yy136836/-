//
//  WQreplyViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQreplyViewController.h"
#import "WQreplyTableViewCell.h"
#import "WQreplyModel.h"
#import "WQparticularsViewController.h"

static NSString *cellid = @"tableviewcellid";

@interface WQreplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation WQreplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma make - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc ]init];
    [tableView registerNib:[UINib nibWithNibName:@"WQreplyTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma make - TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQreplyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQparticularsViewController *particularsVC = [[WQparticularsViewController alloc] initWithmId:cell.model.moment_id];
    [self.navigationController pushViewController:particularsVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQreplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    WQreplyModel *model = self.tableViewdetailOrderData[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma make - 懒加载
- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}

@end
