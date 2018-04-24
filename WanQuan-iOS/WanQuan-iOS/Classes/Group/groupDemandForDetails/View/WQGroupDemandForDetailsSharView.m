//
//  WQGroupDemandForDetailsSharView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDemandForDetailsSharView.h"

@interface WQGroupDemandForDetailsSharView ()

@end

@implementation WQGroupDemandForDetailsSharView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quanzixuqiubeijingkuang1"]];
    ImageView.userInteractionEnabled = YES;
    [self addSubview:ImageView];
    [ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghNavigationBarHeight);
        make.right.equalTo(self).offset(kScaleY(-50));
    }];
    
    // 置顶的按钮
    UIButton *atTopBtn = [[UIButton alloc] init];
    self.atTopBtn = atTopBtn;
    atTopBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [atTopBtn addTarget:self action:@selector(atTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [atTopBtn setImage:[UIImage imageNamed:@"quanzizhiding"] forState:UIControlStateNormal];
    [atTopBtn setTitle:@" 置顶" forState:UIControlStateNormal];
    [atTopBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self addSubview:atTopBtn];
    [atTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ImageView);
        make.top.equalTo(ImageView).offset(ghStatusCellMargin);
        make.height.offset(44);
    }];
    
    // 置顶下的分割线
    UIView *atTopLineView = [[UIView alloc] init];
    atTopLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:atTopLineView];
    [atTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(atTopBtn.mas_bottom);
        make.right.left.equalTo(ImageView);
    }];
    
    // 删除按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"quanzishanchu"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(atTopLineView.mas_bottom);
        make.height.offset(44);
        make.right.left.equalTo(ImageView);
    }];
}

#pragma mark -- 点击屏幕
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(wqSharViewClick:)]) {
        [self.delegate wqSharViewClick:self];
    }
}

#pragma mark -- 置顶的响应事件
- (void)atTopBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqAtTopBtnClick:)]) {
        [self.delegate wqAtTopBtnClick:self];
    }
}

#pragma mark -- 删除的响应事件
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDeleteBtnClick:)]) {
        [self.delegate wqDeleteBtnClick:self];
    }
}

@end
