//
//  WQdynamicUserInformationView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicUserInformationView.h"

@interface WQdynamicUserInformationView ()

@property (strong, nonatomic) MASConstraint *bottomCon;

@end

@implementation WQdynamicUserInformationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 头像
    UIImageView *user_picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.user_picImageView = user_picImageView;
    user_picImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(user_picImageViewClick)];
    [user_picImageView addGestureRecognizer:imageTap];
    user_picImageView.layer.cornerRadius = 25;
    user_picImageView.layer.masksToBounds = YES;
    user_picImageView.userInteractionEnabled = YES;
    [self addSubview:user_picImageView];
    [user_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.left.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    
    // 姓名
    UILabel *nameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(user_picImageView.mas_right).offset(ghStatusCellMargin);
        make.top.equalTo(self.mas_top).offset(ghDistanceershi);
    }];

    // 信用分的背景view
    UIView *creditBackgroundView = [[UIView alloc] init];
    self.creditBackgroundView = creditBackgroundView;
    creditBackgroundView.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
    creditBackgroundView.layer.cornerRadius = 2;
    creditBackgroundView.layer.masksToBounds = YES;
    [self addSubview:creditBackgroundView];
    [creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(42, 14));
        make.left.equalTo(nameLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];

    // 几度好友的背景颜色
    UILabel *aFewDegreesBackgroundLabel = [UILabel labelWithText:@"2度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:9];
    self.aFewDegreesBackgroundLabel = aFewDegreesBackgroundLabel;
    aFewDegreesBackgroundLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    aFewDegreesBackgroundLabel.layer.cornerRadius = 2;
    aFewDegreesBackgroundLabel.layer.masksToBounds = YES;
    [self addSubview:aFewDegreesBackgroundLabel];
    [aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(creditBackgroundView.mas_centerY);
        make.left.equalTo(creditBackgroundView.mas_right).offset(kScaleY(6));
        make.height.offset(14);
    }];

    // 信用分图标
    UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    self.creditImageView = creditImageView;
    [creditBackgroundView addSubview:creditImageView];
    [creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(creditBackgroundView.mas_centerY);
        make.left.equalTo(creditBackgroundView.mas_left).offset(kScaleY(5));
    }];

    // 信用分数
    UILabel *creditLabel = [UILabel labelWithText:@"29分" andTextColor:[UIColor colorWithHex:0x9872ca] andFontSize:9];
    self.creditLabel = creditLabel;
    [creditBackgroundView addSubview:creditLabel];
    [creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(creditBackgroundView.mas_centerY);
        make.left.equalTo(creditImageView.mas_right).offset(kScaleY(1));
    }];

    // 用户标签
    UILabel *user_tagLabel = [UILabel labelWithText:@"东方集团  清华大学" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.user_tagLabel = user_tagLabel;
    user_tagLabel.numberOfLines = 1;
    [self addSubview:user_tagLabel];
    [user_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(12);
        make.left.equalTo(nameLabel.mas_left);
        make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(user_tagLabel.mas_bottom);
    }];
    
    // 关注按钮
    UIButton *guanzhuBtn = [[UIButton alloc] init];
    self.guanzhuBtn = guanzhuBtn;
    guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    guanzhuBtn.backgroundColor = [UIColor whiteColor];
    guanzhuBtn.layer.borderWidth = 1.0f;
    guanzhuBtn.layer.borderColor = [UIColor colorWithHex:0x9767d0].CGColor;
    guanzhuBtn.layer.cornerRadius = 5;
    guanzhuBtn.layer.masksToBounds = YES;
    [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [guanzhuBtn addTarget:self action:@selector(guanzhuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:guanzhuBtn];
    [guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghDistanceershi);
        make.right.equalTo(self).offset(kScaleY(-ghDistanceershi));
        make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
    }];
    
    // 精选图标
    UIImageView *essenceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jingxuan"]];
    self.essenceImageView = essenceImageView;
    [self addSubview:essenceImageView];
    [essenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
}

- (void)setTagArray:(NSArray *)tagArray {
    _tagArray = tagArray;
    [self.nameLabel sizeToFit];
    CGFloat w = kScreenWidth - self.nameLabel.size.width - self.user_picImageView.size.width - ghSpacingOfshiwu - ghStatusCellMargin;
    if (w > 180) {
        // 信用分的背景view
        [self.creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 14));
            make.left.equalTo(self.nameLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
        }];
        
        // 几度好友的背景颜色
        [self.aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_right).offset(kScaleY(6));
            make.height.offset(14);
        }];
        
        // 信用分图标
        [self.creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_left).offset(kScaleY(5));
        }];
        
        // 信用分数
        [self.creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditImageView.mas_right).offset(kScaleY(1));
        }];
        
        // 用户标签
        [self.user_tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
        }];
        // 关注按钮
        [self.guanzhuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ghDistanceershi);
            make.right.equalTo(self).offset(kScaleY(-ghDistanceershi));
            make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
        }];
    }else {
        // 信用分的背景view
        [self.creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 14));
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        }];
        
        // 几度好友的背景颜色
        [self.aFewDegreesBackgroundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_right).offset(kScaleY(6));
            make.height.offset(14);
        }];
        
        // 信用分图标
        [self.creditImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_left).offset(kScaleY(5));
        }];
        
        // 信用分数
        [self.creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditImageView.mas_right).offset(kScaleY(1));
        }];
        
        // 用户标签
        [self.user_tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.creditBackgroundView.mas_bottom).offset(6);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
        }];
        // 关注按钮
        [self.guanzhuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditLabel.mas_centerY);
            make.right.equalTo(self).offset(kScaleY(-ghDistanceershi));
            make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
        }];
    }
    
    if (!tagArray.count) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.user_picImageView.mas_bottom);
        }];
    }else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.user_tagLabel.mas_bottom);
        }];
    }
}

#pragma mark -- 关注按钮的响应事件
- (void)guanzhuBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqGuanzhuBtnClick:)]) {
        [self.delegate wqGuanzhuBtnClick:self];
    }
}

#pragma mark -- 头像的响应事件
- (void)user_picImageViewClick {
    if ([self.delegate respondsToSelector:@selector(wqUser_picImageViewClick:)]) {
        [self.delegate wqUser_picImageViewClick:self];
    }
}

@end
