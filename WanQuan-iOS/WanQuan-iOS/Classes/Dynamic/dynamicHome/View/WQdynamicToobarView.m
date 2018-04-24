//
//  WQdynamicToobarView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicToobarView.h"

@interface WQdynamicToobarView ()

@end

@implementation WQdynamicToobarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 赞
    UIButton *praiseBtn = [[UIButton alloc] init];
    self.praiseBtn = praiseBtn;
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(ghDistanceershi);
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 评论
    UIButton *commentsBtn = [[UIButton alloc] init];
    self.commentsBtn = commentsBtn;
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentsBtn addTarget:self action:@selector(commentsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commentsBtn setImage:[UIImage imageNamed:@"dynamicpinglun"] forState:UIControlStateNormal];
    [commentsBtn setTitle:@" 评论" forState:UIControlStateNormal];
    [commentsBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self addSubview:commentsBtn];
    [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(praiseBtn.mas_centerY);
        make.top.bottom.equalTo(self);
        make.left.equalTo(praiseBtn.mas_right).offset(kScaleY(28));
    }];
    
    // 分享
    UIButton *sharBtn = [[UIButton alloc] init];
    self.sharBtn = sharBtn;
    sharBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sharBtn addTarget:self action:@selector(sharBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sharBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [sharBtn setTitle:@" 分享" forState:UIControlStateNormal];
    [sharBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self addSubview:sharBtn];
    [sharBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(praiseBtn.mas_centerY);
        make.top.bottom.equalTo(self);
        make.left.equalTo(commentsBtn.mas_right).offset(kScaleY(28));
    }];
    
    // 右边的三个点
    UIButton *btns = [[UIButton alloc] init];
    self.btns = btns;
    [btns addTarget:self action:@selector(btnsClick) forControlEvents:UIControlEventTouchUpInside];
    [btns setImage:[UIImage imageNamed:@"gengduoxuanze"] forState:UIControlStateNormal];
    [self addSubview:btns];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(praiseBtn.mas_centerY);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 底部分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghStatusCellMargin);
        make.left.right.bottom.equalTo(self);
    }];
   
    /*
    // 蒙层
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.hidden = YES;
    backView.userInteractionEnabled = YES;
    self.backView = backView;
    backView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewClick)];
    [backView addGestureRecognizer:backViewTap];
    [self addSubview:backView];
    // 弹框背景
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.hidden = YES;
    self.backImageView = backImageView;
    [backView addSubview:backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btns.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 鼓励的按钮
    UIButton *encourageBtn = [[UIButton alloc] init];
    self.encourageBtn = encourageBtn;
    encourageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [encourageBtn addTarget:self action:@selector(encourageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [encourageBtn setImage:[UIImage imageNamed:@"guli_tanchuang"] forState:UIControlStateNormal];
    [encourageBtn setTitle:@"  鼓励" forState:UIControlStateNormal];
    [encourageBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [backImageView addSubview:encourageBtn];
    [self.encourageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(45));
        make.left.equalTo(self.backImageView).offset(kScaleY(18));
        make.top.equalTo(self.backImageView.mas_top).offset(kScaleX(ghStatusCellMargin));
    }];
    
    // 踩的按钮
    UIButton *caiBtn = [[UIButton alloc] init];
    self.caiBtn = caiBtn;
    caiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [caiBtn addTarget:self action:@selector(caiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [caiBtn setImage:[UIImage imageNamed:@"cai_tanchuang"] forState:UIControlStateNormal];
    [caiBtn setTitle:@"  踩" forState:UIControlStateNormal];
    [caiBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [backImageView addSubview:caiBtn];
    [self.caiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(45));
        make.left.equalTo(self.backImageView.mas_left).offset(kScaleY(18));
        make.top.equalTo(self.encourageBtn.mas_bottom).offset(kScaleX(-3));
    }];
    
    // 举报
    UIButton *reportBtn = [[UIButton alloc] init];
    self.reportBtn = reportBtn;
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [reportBtn setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
    [reportBtn setTitle:@"  举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [backImageView addSubview:reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(45));
        make.left.equalTo(self.backImageView.mas_left).offset(kScaleY(18));
        make.top.equalTo(self.caiBtn.mas_bottom);
    }];
     */
}
#pragma mark -- 赞的响应事件
- (void)praiseBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqPraiseBtnClick:)]) {
        [self.delegate wqPraiseBtnClick:self];
    }
}

#pragma mark -- 评论的响应事件
- (void)commentsBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqCommentsBtnClick:)]) {
        [self.delegate wqCommentsBtnClick:self];
    }
}

#pragma mark -- 分享的响应事件
- (void)sharBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSharBtnClick:)]) {
        [self.delegate wqSharBtnClick:self];
    }
}

#pragma mark -- 鼓励的响应事件
- (void)encourageBtnClick {
    self.backView.hidden = !self.backView.hidden;
    self.backImageView.hidden = !self.backImageView.hidden;
    if ([self.delegate respondsToSelector:@selector(wqEencourageBtnClick:)]) {
        [self.delegate wqEencourageBtnClick:self];
    }
}

#pragma mark -- 踩的响应事件
- (void)caiBtnClick {
    self.backView.hidden = !self.backView.hidden;
    self.backImageView.hidden = !self.backImageView.hidden;
    if ([self.delegate respondsToSelector:@selector(wqCaiBtnClick:)]) {
        [self.delegate wqCaiBtnClick:self];
    }
}

#pragma mark -- 举报的响应事件
- (void)reportBtnClick {
    self.backView.hidden = !self.backView.hidden;
    self.backImageView.hidden = !self.backImageView.hidden;
    if ([self.delegate respondsToSelector:@selector(wqReportBtnClick:)]) {
        [self.delegate wqReportBtnClick:self];
    }
}

#pragma mark -- 三个点的响应事件
- (void)btnsClick {
    
    // 万圈状态
    if ([_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        _nameArray = @[@"鼓励",@"踩",@"举报"];
    } else if ([_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        _nameArray = @[@"鼓励",@"举报"];
    }
    if ([self.delegate respondsToSelector:@selector(wqBtnsClick:)]) {
        [self.delegate wqBtnsClick:self];
    }
}

#pragma mark -- 蒙层的响应事件
- (void)backViewClick {
    self.backView.hidden = !self.backView.hidden;
    self.backImageView.hidden = !self.backImageView.hidden;
}

@end
