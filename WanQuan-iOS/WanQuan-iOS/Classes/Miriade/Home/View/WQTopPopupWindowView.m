//
//  WQTopPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopPopupWindowView.h"

@interface WQTopPopupWindowView ()

@property (nonatomic, strong) UIImageView *imageView;;

@end

@implementation WQTopPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPopupWindow];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark - 初始化PopupWindow
- (void)setupPopupWindow {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenxiangdikuang"]];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-ghStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(127, 98));
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

// 我的动态
- (void)dynamicBtnClick {
    if ([self.delegate respondsToSelector:@selector(dynamicBtnClickTopPopupWindowView:)]) {
        [self.delegate dynamicBtnClickTopPopupWindowView:self];
    }
}

// 我参与的动态
- (void)participateBtnClick {
    if ([self.delegate respondsToSelector:@selector(participateBtnClickTopPopupWindowView:)]) {
        [self.delegate participateBtnClickTopPopupWindowView:self];
    }
}

@end
