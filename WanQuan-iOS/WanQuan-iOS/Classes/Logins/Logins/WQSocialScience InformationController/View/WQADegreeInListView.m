//
//  WQADegreeInListView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQADegreeInListView.h"
#import "WQLoginClassListTableViewCell.h"

static NSString *identifier = @"identifier";

@interface WQADegreeInListView () <UITableViewDataSource,UITableViewDelegate>

/**
 顶部view
 */
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation WQADegreeInListView {
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
    UILabel *tagLabel = [UILabel labelWithText:@"选择学位" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
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
    
    if ([self.delegate respondsToSelector:@selector(wqADegreeInListViewdidSelectRowAtClick:titleString:)]) {
        [self.delegate wqADegreeInListViewdidSelectRowAtClick:self titleString:cell.tagLabel.text];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ADegreeInDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQLoginClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tagLabel.text = _ADegreeInDataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)setADegreeInDataArray:(NSArray *)ADegreeInDataArray {
    _ADegreeInDataArray = ADegreeInDataArray;
    
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ADegreeInDataArray.count * 50);
    }];
    
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableView.mas_top);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [tableView reloadData];
    });
}

@end
