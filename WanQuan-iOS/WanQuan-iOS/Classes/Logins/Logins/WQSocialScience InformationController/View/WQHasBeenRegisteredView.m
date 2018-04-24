//
//  WQHasBeenRegisteredView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHasBeenRegisteredView.h"
#import "WQHasBeenRegisteredTableViewCell.h"
#import "WQPrefixHeader.pch"

typedef NS_ENUM(NSInteger, isArray) {
    // 以上都不是数组
    isNoneOfTheAboveArray,
    // MBA或者社科学院的数组
    isModelDataArray
};

static NSString *identifier = @"identifier";

@interface WQHasBeenRegisteredView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) isArray array;

@end

@implementation WQHasBeenRegisteredView {
    UITableView *tableView;
    NSArray *dataArray;
    // tableview顶部的view
    UIView *topView;
    // 已有多少人加入万圈的label
    UILabel *numLabel;
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
    // 底部的view
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.offset(kScaleX(50));
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"完成注册,即可查看更多信息" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    [bottomView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 继续填写的按钮
    UIButton *fillinButton = [[UIButton alloc] init];
    fillinButton.titleLabel.font = [UIFont systemFontOfSize:18];
    fillinButton.backgroundColor = [UIColor colorWithHex:0x9767d0];
    [fillinButton addTarget:self action:@selector(fillinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [fillinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fillinButton setTitle:@"继续填写" forState:UIControlStateNormal];
    [bottomView addSubview:fillinButton];
    [fillinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(bottomView);
        make.width.offset(kScaleY(160));
    }];
    
    // 底部view的顶部分割线
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [bottomView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(bottomView);
        make.height.offset(0.5);
    }];
    
    tableView = [[UITableView alloc] init];
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerClass:[WQHasBeenRegisteredTableViewCell class] forCellReuseIdentifier:identifier];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.bottom.equalTo(bottomView.mas_top);
        make.height.offset(kScaleX(480));
    }];
    
    // tableview顶部的view
    topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(50);
        make.bottom.equalTo(tableView.mas_top);
    }];
    
    // 已有多少人加入万圈的label
    numLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x262626] andFontSize:17];
    [topView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // x的按钮
    UIButton *shutDownBtn = [[UIButton alloc] init];
    [shutDownBtn setImage:[UIImage imageNamed:@"denglushanchu"] forState:UIControlStateNormal];
    [shutDownBtn addTarget:self action:@selector(shutDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shutDownBtn];
    [shutDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).offset(kScaleY(-ghDistanceershi));
    }];
}

#pragma mark -- x的响应事件
- (void)shutDownBtnClick {
    self.hidden = !self.hidden;
}

#pragma mark -- 继续填写的响应事件
- (void)fillinButtonClick {
    self.hidden = !self.hidden;
}

#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.array == isModelDataArray) {
        return _modelDataArray.count;
    }else {
        return _noneOfTheAboveArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQHasBeenRegisteredTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WQHasBeenRegisteredTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (self.array == isModelDataArray) {
        cell.model = _modelDataArray[indexPath.row];
    }else {
        cell.noneOfTheAboveModel = _noneOfTheAboveArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)setModelDataArray:(NSArray *)modelDataArray {
    _modelDataArray = modelDataArray;
    
    self.array = isModelDataArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [tableView reloadData];
    });
}

- (void)setNoneOfTheAboveArray:(NSArray *)noneOfTheAboveArray {
    _noneOfTheAboveArray = noneOfTheAboveArray;
    
    self.array = isNoneOfTheAboveArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [tableView reloadData];
    });
}

- (void)setPresonCount:(NSString *)presonCount {
    _presonCount = presonCount;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"已有"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x262626]}]];
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",presonCount]
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x844dc5]}]];
    NSString *titles;
    if (self.type == MBAs) {
        titles = @"名MBA同学加入万圈";
    }else if (self.type == SocialSciences) {
        titles = @"名社科同学加入万圈";
    }else {
        titles = @"名校友加入万圈";
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:titles
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x262626]}]];
    
    numLabel.attributedText = str;
}

@end
