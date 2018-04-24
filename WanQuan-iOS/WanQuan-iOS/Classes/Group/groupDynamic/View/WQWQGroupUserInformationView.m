//
//  WQWQGroupUserInformationView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQWQGroupUserInformationView.h"

@interface WQWQGroupUserInformationView ()

@property (strong, nonatomic) MASConstraint *bottomCon;

@property (nonatomic, strong) UIButton *actlvltyBtn;

@end

@implementation WQWQGroupUserInformationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setType:(NSString *)type {
    _type = type;
    [self.userLabel sizeToFit];
    // 主题
    if ([type isEqualToString:@"主题"]) {
        CGFloat w = kScreenWidth - self.HeadPortraitImageView.width - ghSpacingOfshiwu - self.userLabel.width - ghSpacingOfshiwu;
        NSLog(@"%f",w);
        if (w > 140) {
            // 用户的头像
            [self addSubview:self.HeadPortraitImageView];
            [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.top.equalTo(self.mas_top).offset(ghSpacingOfshiwu);
                make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
                make.bottom.equalTo(self);
            }];
            // 用户的名称
            [self addSubview:self.userLabel];
            [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(ghDistanceershi);
                make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghSpacingOfshiwu);
            }];
            // 信用分的背景view
            [self addSubview:self.creditBackgroundView];
            [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(42, 14));
                make.left.equalTo(_userLabel.mas_right).offset(ghStatusCellMargin);
            }];
            // 几度好友
            [self addSubview:self.aFewDegreesBackgroundLabel];
            [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
                make.height.offset(14);
            }];
            // 信用分图标
            [_creditBackgroundView addSubview:self.creditImageView];
            [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
            }];
            // 信用分数
            [_creditBackgroundView addSubview:self.creditLabel];
            [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditImageView.mas_right).offset(1);
            }];
            // 发布时间
            [self addSubview:self.timeLbale];
            [_timeLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userLabel.mas_left);
                make.bottom.equalTo(_HeadPortraitImageView.mas_bottom).offset(-5);
            }];
            // 回复的按钮
            [self addSubview:self.replyBtn];
            [_replyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(20);
                make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.HeadPortraitImageView.mas_bottom);
            }];
        }else {
            // 用户的头像
            [self addSubview:self.HeadPortraitImageView];
            [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.top.equalTo(self.mas_top).offset(ghSpacingOfshiwu);
                make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
            }];
            // 用户的名称
            [self addSubview:self.userLabel];
            [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(ghDistanceershi);
                make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghSpacingOfshiwu);
            }];
            // 信用分的背景view
            [self addSubview:self.creditBackgroundView];
            [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(42, 14));
                make.top.equalTo(_userLabel.mas_bottom).offset(6);
                make.left.equalTo(_userLabel.mas_left);
            }];
            // 几度好友
            [self addSubview:self.aFewDegreesBackgroundLabel];
            [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
                make.height.offset(14);
            }];
            // 信用分图标
            [_creditBackgroundView addSubview:self.creditImageView];
            [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
            }];
            // 信用分数
            [_creditBackgroundView addSubview:self.creditLabel];
            [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditImageView.mas_right).offset(1);
            }];
            // 发布时间
            [self addSubview:self.timeLbale];
            [_timeLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userLabel.mas_left);
                make.top.equalTo(_creditBackgroundView.mas_bottom).offset(6);
                make.bottom.equalTo(self);
            }];
            // 回复的按钮
            [self addSubview:self.replyBtn];
            [_replyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(20);
                make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(_timeLbale.mas_bottom);
            }];
        }
    }else if([type isEqualToString:@"需求"]) {
        // 需求
        [self.userLabel sizeToFit];
        CGFloat w = kScreenWidth - self.HeadPortraitImageView.width - ghSpacingOfshiwu - self.userLabel.width - ghSpacingOfshiwu;
        NSLog(@"%f",w);
        if (w > 200) {
            // 用户的头像
            [self addSubview:self.HeadPortraitImageView];
            [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
                make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
            }];
            // 用户的名称
            [self addSubview:self.userLabel];
            [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(ghDistanceershi);
                make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghStatusCellMargin);
            }];
            // 信用分的背景view
            [self addSubview:self.creditBackgroundView];
            [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(38, 14));
                make.left.equalTo(_userLabel.mas_right).offset(ghStatusCellMargin);
            }];
            // 几度好友
            [self addSubview:self.aFewDegreesBackgroundLabel];
            [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
                make.height.offset(14);
            }];
            // 信用分图标
            [_creditBackgroundView addSubview:self.creditImageView];
            [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
            }];
            // 信用分数
            [_creditBackgroundView addSubview:self.creditLabel];
            [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditImageView.mas_right).offset(1);
            }];
            // 标签
            [self addSubview:self.tagOncLabel];
            [_tagOncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userLabel.mas_left);
                make.top.equalTo(_userLabel.mas_bottom).offset(3);
            }];
            [self addSubview:self.tagTwoLabel];
            [_tagTwoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_tagOncLabel.mas_centerY);
                make.left.equalTo(_tagOncLabel.mas_right).offset(6);
            }];
            // 截止时间
            [self addSubview:self.stopTimeImageView];
            [_stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_tagOncLabel.mas_left);
                make.top.equalTo(_tagOncLabel.mas_bottom).offset(5);
                make.bottom.equalTo(self);
            }];
            [self addSubview:self.stopTimeLabel];
            [_stopTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stopTimeImageView.mas_right).offset(6);
                make.centerY.equalTo(_stopTimeImageView.mas_centerY);
            }];
            // 紫色的条
            [self addSubview:self.articlePurpleView];
            [_articlePurpleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 8));
                make.right.top.equalTo(self);
            }];
            // 金额
            [self addSubview:self.moneyLabel];
            [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_articlePurpleView.mas_bottom).offset(8);
                make.centerX.equalTo(_articlePurpleView.mas_centerX).offset(-6);
            }];
            [self addSubview:self.hongbaoImageView];
            [_hongbaoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(_HeadPortraitImageView.mas_centerY);
            }];
            // 距离
            [self addSubview:self.distanceLabel];
            [_distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_stopTimeLabel.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
            }];
            [self addSubview:self.distanceImageView];
            [_distanceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_distanceLabel.mas_centerY);
                make.right.equalTo(_distanceLabel.mas_left).offset(-4);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(_stopTimeImageView.mas_bottom).offset(ghStatusCellMargin);
            }];
        }else {
            // 用户的头像
            [self addSubview:self.HeadPortraitImageView];
            [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
                make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
            }];
            // 用户的名称
            [self addSubview:self.userLabel];
            [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(ghDistanceershi);
                make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghStatusCellMargin);
            }];
            // 信用分的背景view
            [self addSubview:self.creditBackgroundView];
            [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userLabel.mas_bottom).offset(6);
                make.size.mas_equalTo(CGSizeMake(40, 14));
                make.left.equalTo(_userLabel);
            }];
            // 几度好友
            [self addSubview:self.aFewDegreesBackgroundLabel];
            [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
                make.height.offset(14);
            }];
            // 信用分图标
            [_creditBackgroundView addSubview:self.creditImageView];
            [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
            }];
            // 信用分数
            [_creditBackgroundView addSubview:self.creditLabel];
            [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_creditBackgroundView.mas_centerY);
                make.left.equalTo(_creditImageView.mas_right).offset(1);
            }];
            // 标签
            [self addSubview:self.tagOncLabel];
            [_tagOncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userLabel.mas_left);
                make.top.equalTo(_creditBackgroundView.mas_bottom).offset(3);
            }];
            [self addSubview:self.tagTwoLabel];
            [_tagTwoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_tagOncLabel.mas_centerY);
                make.left.equalTo(_tagOncLabel.mas_right).offset(6);
            }];
            // 截止时间
            [self addSubview:self.stopTimeImageView];
            [_stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_tagOncLabel.mas_left);
                make.top.equalTo(_tagOncLabel.mas_bottom).offset(5);
                make.bottom.equalTo(self);
            }];
            [self addSubview:self.stopTimeLabel];
            [_stopTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stopTimeImageView.mas_right).offset(6);
                make.centerY.equalTo(_stopTimeImageView.mas_centerY);
            }];
            // 紫色的条
            [self addSubview:self.articlePurpleView];
            [_articlePurpleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 8));
                make.right.top.equalTo(self);
            }];
            // 金额
            [self addSubview:self.moneyLabel];
            [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_articlePurpleView.mas_bottom).offset(8);
                make.centerX.equalTo(_articlePurpleView.mas_centerX).offset(-6);
            }];
            [self addSubview:self.hongbaoImageView];
            [_hongbaoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(_HeadPortraitImageView.mas_centerY);
            }];
            // 距离
            [self addSubview:self.distanceLabel];
            [_distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_stopTimeLabel.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
            }];
            [self addSubview:self.distanceImageView];
            [_distanceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_distanceLabel.mas_centerY);
                make.right.equalTo(_distanceLabel.mas_left).offset(-4);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(_stopTimeImageView.mas_bottom).offset(ghStatusCellMargin);
            }];
        }
    } else if ([self.type isEqualToString:@"转发需求"]) {
        // 用户的头像
        [self addSubview:self.HeadPortraitImageView];
        [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
            make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        }];
        // 用户的名称
        [self addSubview:self.userLabel];
        [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(ghDistanceershi);
            make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghStatusCellMargin);
        }];
        // 信用分的背景view
        [self addSubview:self.creditBackgroundView];
        [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(38, 14));
            make.left.equalTo(_userLabel.mas_right).offset(ghStatusCellMargin);
        }];
        // 几度好友
        [self addSubview:self.aFewDegreesBackgroundLabel];
        [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
            make.height.offset(14);
        }];
        // 信用分图标
        [_creditBackgroundView addSubview:self.creditImageView];
        [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
        }];
        // 信用分数
        [_creditBackgroundView addSubview:self.creditLabel];
        [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditImageView.mas_right).offset(1);
        }];

        [self addSubview:self.timeLbale];
        [self.timeLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userLabel.mas_left);
            make.top.equalTo(_userLabel.mas_bottom).offset(3);
        }];
//        // 紫色的条
//        [self addSubview:self.articlePurpleView];
//        [_articlePurpleView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(40, 8));
//            make.right.top.equalTo(self);
//        }];

        // 回复的按钮
        [self addSubview:self.replyBtn];
        [_replyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
            
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.timeLbale.mas_bottom).offset(ghStatusCellMargin);
        }];
    }else if ([self.type isEqualToString:@"活动"]) {
        // 用户的头像
        [self addSubview:self.HeadPortraitImageView];
        [_HeadPortraitImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
            make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        }];
        // 用户的名称
        [self addSubview:self.userLabel];
        [_userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(ghDistanceershi);
            make.left.equalTo(_HeadPortraitImageView.mas_right).offset(ghStatusCellMargin);
        }];
        // 信用分的背景view
        [self addSubview:self.creditBackgroundView];
        [_creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_userLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(41, 14));
//            make.left.equalTo(_userLabel.mas_right).offset(ghStatusCellMargin);
            make.left.equalTo(_userLabel.mas_left);
            make.top.equalTo(_userLabel.mas_bottom).offset(5);
        }];
        // 几度好友
        [self addSubview:self.aFewDegreesBackgroundLabel];
        [_aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
            make.height.offset(14);
        }];
        // 信用分图标
        [_creditBackgroundView addSubview:self.creditImageView];
        [_creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
        }];
        // 信用分数
        [_creditBackgroundView addSubview:self.creditLabel];
        [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditBackgroundView.mas_centerY);
            make.left.equalTo(_creditImageView.mas_right).offset(1);
        }];
        
//        [self addSubview:self.timeLbale];
//        [self.timeLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_userLabel.mas_left);
//            make.top.equalTo(_userLabel.mas_bottom).offset(3);
//        }];
        
        [self addSubview:self.actlvltyBtn];
        [self.actlvltyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(38, 22));
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.HeadPortraitImageView.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
        
}

- (void)setIsActlvlty:(BOOL)isActlvlty {
    _isActlvlty = isActlvlty;
    if (isActlvlty) {
        self.actlvltyBtn.hidden = NO;
        self.replyBtn.hidden = YES;
    }else {
        self.actlvltyBtn.hidden = YES;
    }
}

// 回复的按钮的响应事件
- (void)replyBtnCliek {
}

#pragma mark - 响应事件
// 点击群头像
- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqGroupUserInformationViewHeadPortraitCliek:)]) {
        [self.delegate wqGroupUserInformationViewHeadPortraitCliek:self];
    }
}

#pragma mark -- 懒加载
- (UIButton *)actlvltyBtn {
    if (!_actlvltyBtn) {
        _actlvltyBtn = [[UIButton alloc] init];
        _actlvltyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _actlvltyBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        [_actlvltyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actlvltyBtn setTitle:@"活动" forState:UIControlStateNormal];
    }
    return _actlvltyBtn;
}
// 头像
- (UIImageView *)HeadPortraitImageView {
    if (!_HeadPortraitImageView) {
        _HeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gerenjinglitouxiang"]];
        _HeadPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _HeadPortraitImageView.layer.cornerRadius = 22.5;
        _HeadPortraitImageView.layer.masksToBounds = YES;
        _HeadPortraitImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_HeadPortraitImageView addGestureRecognizer:tap];
    }
    return _HeadPortraitImageView;
}
// 用户名
- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    }
    return _userLabel;
}
// 发布时间
- (UILabel *)timeLbale {
    if (!_timeLbale) {
        _timeLbale = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    }
    return _timeLbale;
}
// 回复按钮
- (UIButton *)replyBtn {
    if (!_replyBtn) {
        _replyBtn = [[UIButton alloc] init];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_replyBtn setImage:[UIImage imageNamed:@"quanzixiaoxi"] forState:UIControlStateNormal];
//        [_replyBtn setTitle:@"1" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [_replyBtn addTarget:self action:@selector(replyBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}
// 标签
- (UILabel *)tagOncLabel {
    if (!_tagOncLabel) {
        _tagOncLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    }
    return _tagOncLabel;
}
- (UILabel *)tagTwoLabel {
    if (!_tagTwoLabel) {
        _tagTwoLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    }
    return _tagTwoLabel;
}

// 截止时间
- (UILabel *)stopTimeLabel {
    if (!_stopTimeLabel) {
        _stopTimeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    }
    return _stopTimeLabel;
}

// 紫色的条
- (UIView *)articlePurpleView {
    
    if (!_articlePurpleView) {
        _articlePurpleView = [[UIView alloc] init];
        _articlePurpleView.backgroundColor = [UIColor colorWithHex:0xb667fb];
    }
    return _articlePurpleView;
}

// 金额
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:20];
    }
    return _moneyLabel;
}

// 距离
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    }
    return _distanceLabel;
}

// 截止时间的图片
- (UIImageView *)stopTimeImageView {
    if (!_stopTimeImageView) {
        _stopTimeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyeshijian"]];
    }
    return _stopTimeImageView;
}
// 距离的图片
- (UIImageView *)distanceImageView {
    if (!_distanceImageView) {
        _distanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyejuli"]];
    }
    return _distanceImageView;
}

// 红包
- (UIImageView *)hongbaoImageView {
    if (!_hongbaoImageView) {
        _hongbaoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyehongbao"]];
    }
    return _hongbaoImageView;
}

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

@end
