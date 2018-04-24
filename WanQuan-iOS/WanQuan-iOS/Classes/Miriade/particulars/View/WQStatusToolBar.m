//
//  WQStatusToolBar.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQStatusToolBar.h"

@interface  WQStatusToolBar()
@property (strong, nonatomic) UIButton *retweetbtn;   //踩,评论,打赏支持4个btn
@property (strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIButton *playTourBtn;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation WQStatusToolBar{
    NSArray <UIButton *>*_btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    
    // 添加button
    // 踩
    UIButton *retweetbtn = [self addChildButtonWithImageName:@"haoyouquancai" defaultTitle:@""];
    // 评论
    UIButton *commentBtn = [self addChildButtonWithImageName:@"haoyouquanpinglun" defaultTitle:@""];
    // 赞
    UIButton *unlikeBtn = [self addChildButtonWithImageName:@"haoyouquanzan" defaultTitle:@""];
    // 鼓励支持
    UIButton *playTourBtn = [self addChildButtonWithImageName:@"haoyouquanguli" defaultTitle:@" 鼓励"];
    [playTourBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    playTourBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [retweetbtn addTarget:self action:@selector(retweetbtnClike) forControlEvents:UIControlEventTouchUpInside];
    [unlikeBtn addTarget:self action:@selector(unlikeBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [playTourBtn addTarget:self action:@selector(playTourBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    self.retweetbtn =retweetbtn;
    self.commentBtn = commentBtn;
    self.unlikeBtn = unlikeBtn;
    self.playTourBtn = playTourBtn;
    
    _btnArray = @[unlikeBtn,retweetbtn,commentBtn,playTourBtn];
    
    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [_btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:5 tailSpacing:10];
    
    [_btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-ghStatusCellMargin);
        make.top.equalTo(self).offset(ghStatusCellMargin);
    }];
    
    [_playTourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentBtn.mas_top);
    }];
    
    //添加懒加载控件
    [self addSubview:self.likeLabel];
    [self addSubview:self.TreadLable];
    [self addSubview:self.CommentsLabel];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(_unlikeBtn.mas_right).offset(-23);
    }];
    [_TreadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(self.retweetbtn.mas_right).offset(-23);
    }];
    [_CommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(self.commentBtn.mas_right).offset(-23);
    }];
    
    UIView *topline = [[UIView alloc]init];
    topline.backgroundColor = [UIColor colorWithHex:0Xeeeeee];
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(self);
        make.height.offset(0.5);
    }];
    
    [self addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(0.5);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(ghStatusCellMargin);
    }];
}

- (UIButton *)addChildButtonWithImageName:(NSString *)imageName  defaultTitle:(NSString *)title {
    UIButton *btn = [UIButton setNormalTitle:title andNormalColor:[UIColor grayColor] andFont:12];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

#pragma mark - btn点击事件
// 踩
- (void)retweetbtnClike {
    if (self.treadBtnClikeBlock) {
        self.treadBtnClikeBlock();
    }
}

// 赞
- (void)unlikeBtnClike {
    if (self.likeBtnClikeBlock) {
        self.likeBtnClikeBlock();
    }
}

// 评论
- (void)commentBtnClike {
    if (self.commentsBtnClikeBlock) {
        self.commentsBtnClikeBlock();
    }
}

// 打赏支持
- (void)playTourBtnClike {
    if (self.playTourBtnClikeBlock) {
        self.playTourBtnClikeBlock();
    }
}

#pragma mark - 懒加载
- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _likeLabel;
}

- (UILabel *)TreadLable {
    if (!_TreadLable) {
        _TreadLable = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _TreadLable;
}

- (UILabel *)CommentsLabel {
    if (!_CommentsLabel) {
        _CommentsLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _CommentsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHex:0Xeeeeee];
    }
    return _lineView;
}

@end
