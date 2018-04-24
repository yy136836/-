//
//  WQHomeNearbyTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeNearbyTableViewCell.h"
#import "WQHomeNearbyTagModel.h"

@interface WQHomeNearbyTableViewCell()

/**
 头像
 */
@property (strong, nonatomic) UIImageView *user_pic;

/**
 红包
 */
@property (strong, nonatomic) UIImageView *hongbao;

/**
 用户名
 */
@property (strong, nonatomic) UILabel *user_name;

/**
 标题
 */
@property (strong, nonatomic) UILabel *subject;

/**
 时间
 */
@property (strong, nonatomic) UILabel *finished_date;

/**
 内容
 */
@property (strong, nonatomic) UILabel *content;

/**
 佣金
 */
@property (strong, nonatomic) UILabel *money;

/**
 第一个标签
 */
@property (strong, nonatomic) UILabel *tagLabel;

/**
 第二个标签
 */
@property (strong, nonatomic) UILabel *twoTag;

@property (nonatomic, strong) UIButton *comBtn;

@end

@implementation WQHomeNearbyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 头像
    self.user_pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.layer.cornerRadius = 25;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headBtnClike:)];
    [self.user_pic addGestureRecognizer:tap];
    [self.contentView addSubview:self.user_pic];
    [self.user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
    }];
    
    // 姓名
    self.user_name = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x0e0e0e] andFontSize:16];
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@19.5);
        make.top.equalTo(self.user_pic.mas_top).offset(8);
        make.left.equalTo(self.user_pic.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 信用分的背景view
    [self.contentView addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.user_name.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.user_name.mas_right).offset(ghStatusCellMargin);
    }];
    // 几度好友
    [self.contentView addSubview:self.aFewDegreesBackgroundLabel];
    [_aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
        make.height.offset(14);
    }];
    // 信用分图标
    [_creditBackgroundView addSubview:self.creditImageView];
    [_creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
    }];
    // 信用分数
    [_creditBackgroundView addSubview:self.creditLabel];
    [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditImageView.mas_right).offset(1);
    }];
    
    // 佣金
    self.money = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:24];
    [self.contentView addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.aFewDegreesBackgroundLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 红包
    self.hongbao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyehongbao"]];
    self.hongbao.hidden = YES;
    [self.contentView addSubview:self.hongbao];
    [self.hongbao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(21, 28));
        make.top.equalTo(self.contentView.mas_top).offset(ghSpacingOfshiwu);
    }];
    
    // 第一个标签的label
    self.tagLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.tagLabel];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.user_name.mas_bottom).offset(5);
    }];
    
    // 第二个标签的Label
    self.twoTag = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.twoTag];
    [_twoTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tagLabel.mas_centerY);
        make.left.equalTo(_tagLabel.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 到期时间的图片
    [self addSubview:self.daoqishijian];
    [self.daoqishijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.left.equalTo(_tagLabel.mas_left);
        make.top.equalTo(_tagLabel.mas_bottom).offset(10);
    }];
    
    // 到期时间
    self.finished_date = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    [self.contentView addSubview:self.finished_date];
    [self.finished_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.daoqishijian.mas_centerY);
        make.left.equalTo(self.daoqishijian.mas_right).offset(1);
    }];
    
    // 地理位置
    self.addr = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    [self.contentView addSubview:self.addr];
    [self.addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.finished_date.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 距离图片
    [self.contentView addSubview:self.locationImageView];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 12));
        make.centerY.equalTo(self.addr.mas_centerY);
        make.right.equalTo(self.addr.mas_left);
    }];
    
    // 标题
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.subject.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self.contentView addSubview:self.subject];
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.finished_date.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
        make.height.offset(20);
    }];
    
    // 内容
    self.content = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    self.content.font = [UIFont fontWithName:@".PingFangSC-Regular" size:14];
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.subject.mas_bottom).offset(ghStatusCellMargin);
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 底部分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghStatusCellMargin);
        make.bottom.right.left.equalTo(self.contentView);
    }];
    
    UIButton *comBtn = [[UIButton alloc] init];
    self.comBtn = comBtn;
    comBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [comBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [comBtn setImage:[UIImage imageNamed:@"需求xinpinglun"] forState:UIControlStateNormal];
    [self.contentView addSubview:comBtn];
    [comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.finished_date.mas_centerY);
        make.left.equalTo(self.finished_date.mas_right).offset(25);
    }];
}

- (void)setHomeNearbyTagModel:(WQHomeNearbyTagModel *)homeNearbyTagModel {
    _homeNearbyTagModel = homeNearbyTagModel;
    NSString * headerData = homeNearbyTagModel.content;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@"  "];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];
    self.content.text = headerData;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        // 如果是游客登录不显示信分和几度好友
        self.creditBackgroundView.hidden = YES;
        self.aFewDegreesBackgroundLabel.hidden = YES;
    }
    
    if ([[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"]) {
        // 快速注册的用户
        if ([homeNearbyTagModel.user_idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
            self.creditBackgroundView.hidden = YES;
            self.aFewDegreesBackgroundLabel.hidden = YES;
        }else {
            self.aFewDegreesBackgroundLabel.hidden = YES;
            self.creditBackgroundView.hidden = NO;
            self.creditLabel.text = [[NSString stringWithFormat:@"%@",homeNearbyTagModel.user_creditscore] stringByAppendingString:@"分"];
        }
    }
    
    if (![role_id isEqualToString:@"200"] && ![[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"] && ![homeNearbyTagModel.user_idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        
        self.creditBackgroundView.hidden = NO;
        self.aFewDegreesBackgroundLabel.hidden = NO;
        NSString *user_degree;
        if ([homeNearbyTagModel.user_degree integerValue] == 0) {
            user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
        }else if ([homeNearbyTagModel.user_degree integerValue] <= 2) {
            user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
        }else if ([homeNearbyTagModel.user_degree integerValue] == 3) {
            user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
        }else {
            user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
        }
        self.aFewDegreesBackgroundLabel.text = user_degree;
        self.creditLabel.text = [[NSString stringWithFormat:@"%@",homeNearbyTagModel.user_creditscore] stringByAppendingString:@"分"];
    }
    
    if ([homeNearbyTagModel.user_idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        self.creditBackgroundView.hidden = YES;
        self.aFewDegreesBackgroundLabel.hidden = YES;
    }
    
    // 用户名大于六个字的话只显示前六个
    if (homeNearbyTagModel.user_name.length > 6) {
        NSString *nameString = [homeNearbyTagModel.user_name substringToIndex:5];
        self.user_name.text = [nameString stringByAppendingString:@"…"];
    }else {
        self.user_name.text = homeNearbyTagModel.user_name;
    }
    
    self.subject.text =  homeNearbyTagModel.subject;
    self.finished_date.text = homeNearbyTagModel.finished_date;
    
    NSInteger distance = [[NSString stringWithFormat:@"%.0f",homeNearbyTagModel.distance] integerValue];
    if (distance > 10000) {
        NSInteger kmPosition = distance / 1000;
        self.addr.text = [[NSString stringWithFormat:@"%zd",kmPosition] stringByAppendingString:@"千米"];
    }else {
        self.addr.text = [[NSString stringWithFormat:@"%zd",distance] stringByAppendingString:@"米"];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",homeNearbyTagModel.money]
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
    
    self.money.attributedText = str;
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(homeNearbyTagModel.user_pic)] placeholder:[UIImage imageWithColor:[UIColor lightGrayColor]]];
    if ([homeNearbyTagModel.status isEqualToString:@"STATUS_FNISHED"]) {
        self.money.textColor = [UIColor colorWithHex:0Xdcdcdc];
    }
    if ([homeNearbyTagModel.status isEqualToString:@"STATUS_BIDDING"]) {
        self.money.textColor = [UIColor colorWithHex:0x5288d8];
    }
    
    [self.daoqishijian mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.user_name.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 是否匿名
    if (homeNearbyTagModel.truename == YES) {
        switch (homeNearbyTagModel.user_tag.count) {
                case 1:{
                    self.tagLabel.hidden = NO;
                    self.tagLabel.text = homeNearbyTagModel.user_tag.firstObject;
                    self.twoTag.hidden = YES;
                    
                    [self.daoqishijian mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(_tagLabel.mas_left);
                        make.top.equalTo(_tagLabel.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                break;
                case 2:{
                    self.tagLabel.hidden = NO;
                    self.twoTag.hidden = NO;
                    self.tagLabel.text = homeNearbyTagModel.user_tag.firstObject;
                    self.twoTag.text = homeNearbyTagModel.user_tag.lastObject;
                    
                    [self.daoqishijian mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(_tagLabel.mas_left);
                        make.top.equalTo(_tagLabel.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                break;
                case 0:{
                    self.tagLabel.hidden = YES;
                    self.twoTag.hidden = YES;
                    
                    // 非匿名没标签,把到期时间网上挪
                    [self.daoqishijian mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(self.user_name.mas_left);
                        make.top.equalTo(self.user_name.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                break;
            default:
                break;
        }
        
    }else{
        self.tagLabel.hidden = YES;
        self.twoTag.hidden = YES;
        
        // 匿名不显示标签,把到期时间网上挪
        [self.daoqishijian mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(11, 11));
            make.left.equalTo(self.user_name.mas_left);
            make.top.equalTo(self.user_name.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
    
    // 如果为bbs的话不显示佣金 显示红包   红包默认是隐藏的
    if ([homeNearbyTagModel.category_level_1 isEqualToString:@"BBS"]) {
        self.money.hidden = YES;
        self.hongbao.hidden = NO;
    }else {
        self.money.hidden = NO;
        self.hongbao.hidden = YES;
    }
    
    NSInteger time = homeNearbyTagModel.left_secends.integerValue;
    if (time < 0) {
        self.finished_date.text = [NSString stringWithFormat:@"已完成"];
    }else if (time < 3600) {
        self.finished_date.text = [NSString stringWithFormat:@"%zd分钟到期",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.finished_date.text = [NSString stringWithFormat:@"%zd天到期",time / (60 * 60 * 24)];
    }else{
        self.finished_date.text = [NSString stringWithFormat:@"%zd小时到期",time / 3600];
    }
    // 打开以下代码解决bug
    NSInteger i = [homeNearbyTagModel.comment_count integerValue];
    if (i >= 1) {
        NSString *str = [NSString stringWithFormat:@"  新评论%@",homeNearbyTagModel.comment_count];
        [self.comBtn setTitle:str forState:UIControlStateNormal];
        self.comBtn.hidden = NO;
    }else {
        [self.comBtn setTitle:@"" forState:UIControlStateNormal];
        self.comBtn.hidden = YES;
    }
}

// 头像的点击事件
- (void)headBtnClike:(UITapGestureRecognizer *)sender {
    
    UIGestureRecognizerState state = sender.state;
    if (state == UIGestureRecognizerStateEnded) {
        if (self.headBtnClikeBlock) {
            sender.view.userInteractionEnabled = NO;
            self.headBtnClikeBlock();
            sender.view.userInteractionEnabled = YES;
        }
    }
}

#pragma mark -- 懒加载
// 信用分的背景view
- (UIView *)creditBackgroundView {
    if (!_creditBackgroundView) {
        _creditBackgroundView = [[UIView alloc] init];
        _creditBackgroundView.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        _creditBackgroundView.layer.cornerRadius = 2;
        _creditBackgroundView.layer.masksToBounds = YES;
    }
    return _creditBackgroundView;
}

// 几度好友的背景颜色
- (UILabel *)aFewDegreesBackgroundLabel {
    if (!_aFewDegreesBackgroundLabel) {
        _aFewDegreesBackgroundLabel = [UILabel labelWithText:@"2度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:9];
        _aFewDegreesBackgroundLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _aFewDegreesBackgroundLabel.layer.cornerRadius = 2;
        _aFewDegreesBackgroundLabel.layer.masksToBounds = YES;
    }
    return _aFewDegreesBackgroundLabel;
}

// 信用分图标
- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    }
    return _creditImageView;
}

// 信用分数
- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [UILabel labelWithText:@"29分" andTextColor:[UIColor colorWithHex:0x9872ca] andFontSize:9];
    }
    return _creditLabel;
}

// 到期时间
- (UIImageView *)daoqishijian {
    if (!_daoqishijian) {
        _daoqishijian = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyeshijian"]];
    }
    return _daoqishijian;
}

// 地理位置的图标
- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyejuli"]];
    }
    return _locationImageView;
}
@end
