//
//  WQRealNameRegistrationCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRealNameRegistrationCollectionViewCell.h"
#import "WQlogonnRootViewController.h"

@implementation WQRealNameRegistrationCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setupCell];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)setupCell {
    UITableView *tableview = [[UITableView alloc] init];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self.contentView addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    WQlogonnRootViewController *vc = [WQlogonnRootViewController new];
    [self.viewController addChildViewController:vc];
    [vc didMoveToParentViewController:self.viewController];
    [cell addSubview:vc.view];
    return cell;
}

@end
