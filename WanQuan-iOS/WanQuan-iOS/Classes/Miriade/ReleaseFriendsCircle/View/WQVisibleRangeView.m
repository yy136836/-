//
//  WQVisibleRangeView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQVisibleRangeView.h"

@interface WQVisibleRangeTableViewCell : UITableViewCell

/**
 提示文案的Label
 */
@property (nonatomic, strong) UILabel *promptLabel;

/**
 公开,好友,好友可见.....label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 对号
 */
@property (nonatomic, strong) UIImageView *duihaoImageView;

@end

@implementation WQVisibleRangeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 初始化ContentView
- (void)setupContentView {
    // 圆圈
    UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanweixuanzhong"]];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *circleImageViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleImageViewClick)];
    [circleImageView addGestureRecognizer:circleImageViewtap];
    [self.contentView addSubview:circleImageView];
    [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
    }];
    // 对号
    UIImageView *duihaoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanxuanzhong"]];
    self.duihaoImageView = duihaoImageView;
    duihaoImageView.hidden = YES;
    [self.contentView addSubview:duihaoImageView];
    [duihaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.centerX.equalTo(circleImageView);
    }];
    
    // 顶部的分割线
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.top.equalTo(self.contentView);
    }];
    
    // 公开,好友,好友可见.....label
    UILabel *titleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 1;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(duihaoImageView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 提示文案的Label
    UILabel *promptLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
    self.promptLabel = promptLabel;
    promptLabel.numberOfLines = 0;
    [self.contentView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(4);
        make.left.equalTo(titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(kScaleY(-ghStatusCellMargin));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-ghSpacingOfshiwu);
    }];
}

#pragma makr -- 圆圈的响应事件
- (void)circleImageViewClick {
    self.duihaoImageView.hidden = NO;
}

@end

static NSString *identifier = @"identifier";

@interface WQVisibleRangeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation WQVisibleRangeView {
    UITableView *tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    tableView = [[UITableView alloc] init];
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 取消滚动条
    tableView.showsVerticalScrollIndicator = NO;
    // 禁止滚动
    tableView.scrollEnabled = NO;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置自动行高和预估行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 70;
    // 注册cell
    [tableView registerClass:[WQVisibleRangeTableViewCell class] forCellReuseIdentifier:identifier];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.offset(295);
    }];
    
    // 点击黑色背景   隐藏当前view
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(selfHiddenClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(tableView.mas_top);
    }];
}

- (void)selfHiddenClick {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath;
    [tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(wqTableViewdidSelectRow:index:)]) {
        [self.delegate wqTableViewdidSelectRow:self index:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQVisibleRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray *titleArray = @[@"公开",@"好友和二度好友可见",@"好友可见"];
    NSArray *promptAarray = @[@"如果你发布了优质的内容,有机会被万圈选为精选,全平台的用户都会欣赏到",@"仅会被好友、好友的好友看到",@"仅会被好友看到"];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.promptLabel.text = promptAarray[indexPath.row];
    if (indexPath.row == self.index.row) {
        cell.duihaoImageView.hidden = NO;
    }else {
        cell.duihaoImageView.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel labelWithText:@"选择动态可见范围" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:18];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(ghSpacingOfshiwu);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"发布后暂不支持更改哦" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-ghSpacingOfshiwu);
    }];
    
    return view;
}

@end
