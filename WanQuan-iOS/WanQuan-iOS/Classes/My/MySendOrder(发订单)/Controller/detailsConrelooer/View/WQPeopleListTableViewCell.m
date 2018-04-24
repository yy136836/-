//
//  WQPeopleListTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQPeopleListTableViewCell.h"
#import "WQPeopleListModel.h"
#import "WQChaViewController.h"

@interface WQPeopleListTableViewCell()
@property (strong, nonatomic) UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;         //用户名
@property (weak, nonatomic) IBOutlet UIImageView *userpic;  //头像
@property (weak, nonatomic) IBOutlet UILabel *miaosu;       //描述
@property (strong, nonatomic) UIImageView *creditImageView;
@property (nonatomic, strong) UIView *creditBackgroundView;
@end

@implementation WQPeopleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _userpic.layer.cornerRadius = 25;
    _userpic.layer.masksToBounds = YES;
    _userpic.contentMode = UIViewContentModeScaleAspectFill;
    self.redDotView.layer.cornerRadius = 2.5;
    self.userpic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    [self.userpic addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    
    
    // 信用分的背景view
    [self.contentView addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.name.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.name.mas_right).offset(ghStatusCellMargin);
    }];
    // 几度好友
    [self.contentView addSubview:self.severalFriendsLabel];
    [_severalFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.cancelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.lineView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    [self.temporaryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(55));
        make.top.equalTo(self.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    [self.selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(kScaleY(-55));
        make.top.equalTo(self.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    
    [self.temporaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.temporaryImage.mas_centerX);
        make.top.equalTo(self.temporaryImage.mas_top).offset(kScaleX(0));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cancelImage.mas_centerX);
        make.centerY.equalTo(self.temporaryImage.mas_top).offset(kScaleX(0));
    }];
    [self.SelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.selectedImage.mas_centerX);
        make.top.equalTo(self.selectedImage.mas_top).offset(kScaleX(0));
    }];
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.top.left.equalTo(self.temporaryImage);
    }];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if (self.headPortraitBlock) {
        self.headPortraitBlock();
    }
}

- (void)hideOrShowDot:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadMessageForBid:self.midString withChater:self.model.user_id];
        self.redDotView.hidden = !haveRed;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
}
//会话
- (IBAction)huihua:(id)sender {
    if (self.huihuaClikeBlock) {
        self.huihuaClikeBlock();
    }
}

//申请取消交易
- (IBAction)cancelBtnClike:(id)sender {
    if (self.cancelBntClikeBlick) {
        self.cancelBntClikeBlick();
    }
}

//选定
- (IBAction)xuanding:(id)sender {
    if (self.xuandingClikeBlock) {
        self.xuandingClikeBlock();
    }
}
- (IBAction)touxiangBtnClike:(id)sender {
    if (self.touxiangBtnClikeBlock) {
        self.touxiangBtnClikeBlock();
    }
}

- (void)setModel:(WQPeopleListModel *)model {
    _model = model;
    self.timeLabel.text = model.work_status_time;
    if ([model.text isEqualToString:@""]) {
        self.miaosu.text = @"他没有说什么~";
    }else{
        self.miaosu.text = model.text;
    }
    self.name.text = model.user_name;
    NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",model.user_pic]];
    [self.userpic yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
    
    if ([model.user_idcard_stauts isEqualToString:@"STATUS_UNVERIFY"]) {
        // 快速注册用户不显示信用分和几度好友
        self.severalFriendsLabel.hidden = YES;
        self.creditImageView.hidden = YES;
        self.creditLabel.hidden = YES;
    }else {
        self.severalFriendsLabel.hidden = NO;
        self.creditImageView.hidden = NO;
        self.creditLabel.hidden = NO;
        NSString *user_degree;
        if ([model.user_degree integerValue] == 0) {
            user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
        }else if ([model.user_degree integerValue] <= 2) {
            user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
        }else if ([model.user_degree integerValue] == 3) {
            user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
        }else {
            user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
        }
        
        self.severalFriendsLabel.text = [NSString stringWithFormat:@"%@",user_degree];
        self.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
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
- (UILabel *)severalFriendsLabel {
    if (!_severalFriendsLabel) {
        _severalFriendsLabel = [UILabel labelWithText:@"2度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:9];
        _severalFriendsLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _severalFriendsLabel.layer.cornerRadius = 2;
        _severalFriendsLabel.layer.masksToBounds = YES;
    }
    return _severalFriendsLabel;
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

@end
