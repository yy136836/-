//
//  WQmyDynamicPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmyDynamicPopupWindowView.h"

@implementation WQmyDynamicPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:.3];
        UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapClick)];
        [self addGestureRecognizer:selfTap];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 背景框
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamicbeijingkuang"]];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(128), kScaleX(96)));
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kScaleY(ghStatusCellMargin));
    }];
    
    // 我的动态
    UIButton *dynamicBtn = [[UIButton alloc] init];
    dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dynamicBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [dynamicBtn setImage:[UIImage imageNamed:@"haoyouquanwodedongtai"] forState:UIControlStateNormal];
    [dynamicBtn setTitle:@" 我的动态" forState:UIControlStateNormal];
    [dynamicBtn addTarget:self action:@selector(dynamicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:dynamicBtn];
    [dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.right.left.equalTo(imageView);
        make.top.equalTo(imageView).offset(ghStatusCellMargin);
    }];
    
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [imageView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicBtn.mas_bottom);
        make.left.right.equalTo(imageView);
        make.height.offset(0.5);
    }];
    
    // 我参与的动态
    UIButton *participateBtn = [[UIButton alloc] init];
    participateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [participateBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [participateBtn setImage:[UIImage imageNamed:@"haoyouquanwocanyude"] forState:UIControlStateNormal];
    [participateBtn setTitle:@" 我参与的" forState:UIControlStateNormal];
    [participateBtn addTarget:self action:@selector(participateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:participateBtn];
    [participateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.right.left.bottom.equalTo(imageView);
    }];
}

#pragma mark -- 我的动态响应事件
- (void)dynamicBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDynamicBtnClick:)]) {
        [self.delegate wqDynamicBtnClick:self];
    }
}

#pragma mark -- 我参与的
- (void)participateBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqParticipateBtnClick:)]) {
        [self.delegate wqParticipateBtnClick:self];
    }
}

#pragma mark -- 蒙板的响应事件
- (void)selfTapClick {
    self.hidden = !self.hidden;
}

@end
