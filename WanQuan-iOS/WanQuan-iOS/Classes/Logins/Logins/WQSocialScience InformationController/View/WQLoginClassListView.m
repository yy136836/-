//
//  WQLoginClassListView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginClassListView.h"
#import "WQLoginClassListTableViewCell.h"
#import "WQClassModel.h"

static NSString *identifier = @"identifier";

@interface WQLoginClassListView () <UITableViewDelegate,UITableViewDataSource>

/**
 顶部view
 */
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation WQLoginClassListView {
    UITableView *tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupView {
    tableView = [[UITableView alloc] init];
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 取消滚动条
    tableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [tableView registerClass:[WQLoginClassListTableViewCell class] forCellReuseIdentifier:identifier];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
    }];
    
    // 顶部view
    UIView *backgroundView = [[UIView alloc] init];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = [UIColor colorWithHex:0xffffff];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.left.right.equalTo(self);
        make.bottom.equalTo(tableView.mas_top);
    }];
    UILabel *tagLabel = [UILabel labelWithText:@"选择班级" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [backgroundView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.centerY.equalTo(backgroundView.mas_centerY);
    }];
    
    UIButton *shutDownBtn = [[UIButton alloc] init];
    [shutDownBtn setImage:[UIImage imageNamed:@"denglushanchu"] forState:UIControlStateNormal];
    [shutDownBtn addTarget:self action:@selector(shutDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:shutDownBtn];
    [shutDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-ghDistanceershi));
    }];
}

#pragma mark -- 组头x的响应事件
- (void)shutDownBtnClick {
    self.hidden = !self.hidden;
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQLoginClassListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(wqTableviewdidSelectRowAtClick:titleString:classIdString:)]) {
        [self.delegate wqTableviewdidSelectRowAtClick:self titleString:cell.tagLabel.text classIdString:cell.model.class_id];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQLoginClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(dataArray.count * ghCellHeight);
    }];
    tableView.tableFooterView = self.footerView;
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableView.mas_top);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [tableView reloadData];
    });
}

@end
