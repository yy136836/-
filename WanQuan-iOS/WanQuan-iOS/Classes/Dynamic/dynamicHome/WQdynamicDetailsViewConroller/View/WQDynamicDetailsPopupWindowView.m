//
//  WQDynamicDetailsPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/2.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQDynamicDetailsPopupWindowView.h"

@interface WQDynamicDetailsPopupWindowView ()

/**
 弹框背景
 */
@property (nonatomic, strong) UIImageView *backImageView;

/**
 举报的按钮
 */
@property (nonatomic, strong) UIButton *reportBtn;

/**
 删除的按钮
 */
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation WQDynamicDetailsPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0x000000
                                                 alpha:.3];
        UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapClick)];
        [self addGestureRecognizer:selfTap];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 弹框背景
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    self.backImageView = backImageView;
    [self addSubview:backImageView];
    
    // 收藏的按钮
    UIButton *scBtn = [[UIButton alloc] init];
    self.scBtn = scBtn;
    
    
    //    [_favorButton setBackgroundImage:[UIImage imageNamed:@"shoucang_hei"] forState:UIControlStateNormal];
    //    [_favorButton setBackgroundImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateSelected];
    
    scBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [scBtn addTarget:self action:@selector(scBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scBtn setImage:[UIImage imageNamed:@"dynamicshoucang"] forState:UIControlStateNormal];
    [scBtn setImage:[UIImage imageNamed:@"quxiaoshoucang"] forState:UIControlStateSelected];
    
    
    [scBtn setTitle:@"  收藏" forState:UIControlStateNormal];
    [scBtn setTitle:@"  取消收藏" forState:UIControlStateSelected];
    
    [scBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [scBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
    [backImageView addSubview:scBtn];
    
    // 举报的按钮
    UIButton *reportBtn = [[UIButton alloc] init];
    self.reportBtn = reportBtn;
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [reportBtn setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
    [reportBtn setTitle:@"  举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [backImageView addSubview:reportBtn];
    
    // 删除的按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    self.deleteBtn = deleteBtn;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"dynamicshanchu"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"  删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [backImageView addSubview:deleteBtn];
}


- (void)setIsDeleteBtn:(BOOL)isDeleteBtn {
    _isDeleteBtn = isDeleteBtn;
    
    // 是否显示删除
    if (self.isDeleteBtn) {
        // 弹窗背景
        self.backImageView.image = [UIImage imageNamed:@"tanchuangbeijing"];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            //make.size.mas_equalTo(CGSizeMake(kScaleY(95), kScaleX(140)));
            make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
        }];
        [self.scBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.left.equalTo(self.backImageView).offset(kScaleY(18));
            make.top.equalTo(self.backImageView.mas_top).offset(kScaleX(ghStatusCellMargin));
        }];
        [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.left.equalTo(self.backImageView.mas_left).offset(kScaleY(18));
            make.top.equalTo(self.scBtn.mas_bottom).offset(kScaleX(-3));
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.left.equalTo(self.backImageView.mas_left).offset(kScaleY(18));
            make.top.equalTo(self.reportBtn.mas_bottom);
        }];
    }else {
        // 弹窗背景
        self.backImageView.image = [UIImage imageNamed:@"dynamicDetailsbeijingkuang"];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
        }];
        [self.scBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.left.equalTo(self.backImageView).offset(kScaleY(18));
            make.top.equalTo(self.backImageView.mas_top).offset(kScaleX(ghStatusCellMargin));
        }];
        [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.left.equalTo(self.backImageView.mas_left).offset(kScaleY(18));
            make.top.equalTo(self.scBtn.mas_bottom).offset(kScaleX(-3));
        }];
    }
}

#pragma mark -- 背景的响应事件
- (void)selfTapClick {
    if ([self.delegate respondsToSelector:@selector(wqDynamicDetailsPopupWindowViewClick:)]) {
        [self.delegate wqDynamicDetailsPopupWindowViewClick:self];
    }
}

#pragma mark -- 收藏的响应事件
- (void)scBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqScBtnClick:)]) {
        [self.delegate wqScBtnClick:self];
    }
}

#pragma mark -- 举报的响应事件
- (void)reportBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqReportBtnClick:)]) {
        [self.delegate wqReportBtnClick:self];
    }
}

#pragma mark -- 删除的响应事件
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDeleteBtnClick:)]) {
        [self.delegate wqDeleteBtnClick:self];
    }
}

@end
