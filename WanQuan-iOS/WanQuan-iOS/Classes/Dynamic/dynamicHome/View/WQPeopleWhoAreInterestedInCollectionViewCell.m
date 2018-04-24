//
//  WQPeopleWhoAreInterestedInCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPeopleWhoAreInterestedInCollectionViewCell.h"
#import "WQPeopleWhoAreInterestedInModel.h"

@interface WQPeopleWhoAreInterestedInCollectionViewCell ()

/**
 头像
 */
@property (nonatomic, strong) UIImageView *user_picImageView;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic,strong)  UIView *creditBackgroundView;
@property (nonatomic, strong) UIImageView *creditImageView;

/**
 信用分数
 */
@property (nonatomic, strong) UILabel *creditLabel;

/**
 用户标签
 */
@property (nonatomic, strong) UILabel *user_learningTagLabel;

/**
 用户工作标签
 */
@property (nonatomic, strong) UILabel *user_workTagLabel;

/**
 几度好友的背景颜色
 */
@property (nonatomic, strong) UILabel *aFewDegreesBackgroundLabel;

@end

@implementation WQPeopleWhoAreInterestedInCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mingpianbeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    // 头像
    UIImageView *user_picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.user_picImageView = user_picImageView;
    user_picImageView.contentMode = UIViewContentModeScaleAspectFill;
    user_picImageView.layer.cornerRadius = 25;
    user_picImageView.layer.masksToBounds = YES;
    user_picImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:user_picImageView];
    [user_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(backgroundImageView).offset(kScaleX(ghSpacingOfshiwu));
        make.left.equalTo(backgroundImageView).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    
    // 姓名
    UILabel *userNameLabel = [UILabel labelWithText:@"王潇潇" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_picImageView);
        make.left.equalTo(user_picImageView.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];
    
    
    
    // 信用分的背景view
    UIView *creditBackgroundView = [[UIView alloc] init];
    creditBackgroundView.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
    creditBackgroundView.layer.cornerRadius = 2;
    creditBackgroundView.layer.masksToBounds = YES;
    self.creditBackgroundView = creditBackgroundView;
    [self addSubview:creditBackgroundView];
    [creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(userNameLabel.mas_right).offset(kScaleY(5));
    }];
    

    
    // 信用分图标
    UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    [creditBackgroundView addSubview:creditImageView];
    self.creditImageView = creditImageView;
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
    

    
    // 用户工作标签
    UILabel *user_workTagLabel = [UILabel labelWithText:@"清华大学" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.user_workTagLabel = user_workTagLabel;
    user_workTagLabel.numberOfLines = 1;
    [self addSubview:user_workTagLabel];
    [user_workTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel.mas_left);
        make.top.equalTo(userNameLabel.mas_bottom).offset(kScaleX(5));
    }];
    

    
    
    // 用户学习标签
    UILabel *user_learningTagLabel = [UILabel labelWithText:@"东方集团  清华大学" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.user_learningTagLabel = user_learningTagLabel;
    [self addSubview:user_learningTagLabel];
    [user_learningTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel.mas_left);
        make.top.equalTo(user_workTagLabel.mas_bottom).offset(kScaleX(5));
        make.right.mas_equalTo(self).offset(-10);
    }];
    

    
    
    
    
    
    // 关注按钮
    UIButton *guanzhuBtn = [[UIButton alloc] init];
    self.guanzhuBtn = guanzhuBtn;
    guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    guanzhuBtn.backgroundColor = [UIColor whiteColor];
    guanzhuBtn.userInteractionEnabled = YES;
    guanzhuBtn.layer.borderWidth = 1.0f;
    guanzhuBtn.layer.borderColor = [UIColor colorWithHex:0x9767d0].CGColor;
    guanzhuBtn.layer.cornerRadius = 5;
    guanzhuBtn.layer.masksToBounds = YES;
    [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [guanzhuBtn addTarget:self action:@selector(guanzhuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:guanzhuBtn];
    [guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
        make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
    }];
    
    UIButton *alpBtn = [[UIButton alloc] init];
    [alpBtn addTarget:self action:@selector(guanzhuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alpBtn];
    [alpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScaleY(80), 60));
    }];
}

#pragma mark -- 关注的响应事件
- (void)guanzhuBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqGuanzhuBtnClick:)]) {
        [self.delegate wqGuanzhuBtnClick:self];
    }
}

- (void)setModel:(WQPeopleWhoAreInterestedInModel *)model {
    _model = model;
    
    // 头像
    [self.user_picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(model.pic_truename)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 姓名
    self.userNameLabel.text = model.true_name;
    // 信用分
    self.creditLabel.text = [model.creditscore stringByAppendingString:@"分"];
    // 几度好友
    self.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.degree integerValue]];
    
    //    make.size.mas_equalTo(CGSizeMake(38, 14));
    
    //    layOut.itemSize = CGSizeMake(kScaleY(270), kScaleX(120));
    
    [self.userNameLabel sizeToFit];
    CGFloat w = kScaleY(270) - self.userNameLabel.size.width - 50 - 2*kScaleY(ghSpacingOfshiwu)-10;
    NSLog(@"----%@---%f",self.userNameLabel.text,w);
    if (w>60) {
        
        [self.creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userNameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 14));
            make.left.equalTo(self.userNameLabel.mas_right).offset(kScaleY(5));
        }];

        [self.aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_right).offset(kScaleY(6));
            make.height.offset(14);
        }];

        // 信用分图标
        [self.creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_left).offset(kScaleY(5));
        }];
        
        // 信用分数
        [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditImageView.mas_right).offset(kScaleY(1));
        }];
        
    }else{
        [self.creditBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(6);
            make.size.mas_equalTo(CGSizeMake(42, 14));
            make.left.equalTo(self.userNameLabel.mas_left);
        }];
        
        [self.aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_right).offset(kScaleY(6));
            make.height.offset(14);
        }];
        
        // 信用分图标
        [self.creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditBackgroundView.mas_left).offset(kScaleY(5));
        }];
        
        // 信用分数
        [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.creditBackgroundView.mas_centerY);
            make.left.equalTo(self.creditImageView.mas_right).offset(kScaleY(1));
        }];
        
    }
    
    // 标签
    if (model.tag.count == 0) {
        self.user_learningTagLabel.hidden = YES;
        self.user_workTagLabel.hidden = YES;
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.user_picImageView.mas_centerY);
            make.left.equalTo(self.user_picImageView.mas_right).offset(kScaleY(ghStatusCellMargin));
        }];
    }else if (model.tag.count == 1) {
        self.user_learningTagLabel.hidden = YES;
        self.user_workTagLabel.hidden = NO;
        self.user_workTagLabel.text = model.tag.firstObject;
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.user_picImageView).offset(6);
            make.left.equalTo(self.user_picImageView.mas_right).offset(kScaleY(ghStatusCellMargin));
        }];
    }else {
        self.user_learningTagLabel.hidden = NO;
        self.user_workTagLabel.hidden = NO;
        self.user_learningTagLabel.text = model.tag.firstObject;
        self.user_workTagLabel.text = model.tag.lastObject;
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.user_picImageView);
            make.left.equalTo(self.user_picImageView.mas_right).offset(kScaleY(ghStatusCellMargin));
        }];
    }
    
    // 是否已关注
    if (model.followed) {
        self.guanzhuBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        [self.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else {
        self.guanzhuBtn.backgroundColor = [UIColor whiteColor];
        [self.guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
        [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    
    
}

@end
