//
//  WQWorkExperiencePopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/5.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQWorkExperiencePopupWindowView.h"

@implementation WQWorkExperiencePopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfClick)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
        [self setupUI];
    }
    return self;
}

- (void)selfClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    self.hidden = !self.hidden;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianjiagongzuojingli"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"还未添加工作经历" andTextColor:[UIColor whiteColor] andFontSize:18];
    [backgroundImageView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView.mas_top).offset(25);
        make.left.equalTo(backgroundImageView.mas_left).offset(ghSpacingOfshiwu);
    }];
    
    UILabel *tagLabel = [UILabel labelWithText:@"添加工作经历可以让他人更了解和信任你,得到帮助的几率会更大哦!" andTextColor:[UIColor whiteColor] andFontSize:15];
    tagLabel.numberOfLines = 2;
    [backgroundImageView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(261); make.top.equalTo(textLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(textLabel.mas_left);
        make.right.equalTo(backgroundImageView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [btn setTitle:@"下次再说" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundImageView.mas_centerX);
        make.bottom.equalTo(backgroundImageView.mas_bottom).offset(-ghDistanceershi);
    }];
    
    UIButton *addWorkBtn = [[UIButton alloc] init];
    addWorkBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addWorkBtn.backgroundColor = [UIColor colorWithHex:0x7fb0f1];
    addWorkBtn.layer.cornerRadius = 5;
    addWorkBtn.layer.masksToBounds = YES;
    [addWorkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addWorkBtn setTitle:@"添加工作经历" forState:UIControlStateNormal];
    [addWorkBtn addTarget:self action:@selector(addWorkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:addWorkBtn];
    [addWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(190, ghCellHeight));
        make.bottom.equalTo(btn.mas_top).offset(-ghSpacingOfshiwu);
    }];
}

#pragma makr -- 下次再说的响应事件
- (void)btnClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    self.hidden = !self.hidden;
}

#pragma makr -- 添加工作经历的响应事件
- (void)addWorkBtnClick {
    if (self.addWorkBlock) {
        self.addWorkBlock();
    }
}

@end
