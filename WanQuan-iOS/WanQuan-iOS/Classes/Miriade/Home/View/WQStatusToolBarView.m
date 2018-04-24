//
//  WQStatusToolBarView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/13.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQStatusToolBarView.h"

@interface WQStatusToolBarView()

// 踩,评论,打赏支持4个btn
@property (strong, nonatomic) UIButton *retweetbtn;
@property (strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIButton *playTourBtn;

@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIView *cellSpacingView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *leftDividerView;
@property (nonatomic, strong) UIView *rightDividerView;
@end

@implementation WQStatusToolBarView{
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
    //[retweetbtn setEnlargeEdgeWithTop:ghStatusCellMargin right:40 bottom:ghStatusCellMargin left:40];
    // 评论
    UIButton *commentBtn = [self addChildButtonWithImageName:@"haoyouquanpinglun" defaultTitle:@""];
    //[commentBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    // 赞
    UIButton *unlikeBtn = [self addChildButtonWithImageName:@"haoyouquanzan" defaultTitle:@""];
    //[unlikeBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    // 鼓励支持
    UIButton *playTourBtn = [self addChildButtonWithImageName:@"haoyouquanguli" defaultTitle:@""];
    //[playTourBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [playTourBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    playTourBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [retweetbtn addTarget:self action:@selector(retweetbtnClike) forControlEvents:UIControlEventTouchUpInside];
    [unlikeBtn addTarget:self action:@selector(unlikeBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [playTourBtn addTarget:self action:@selector(playTourBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    self.retweetbtn = retweetbtn;
    self.commentBtn = commentBtn;
    self.unlikeBtn = unlikeBtn;
    self.playTourBtn = playTourBtn;
    
    _btnArray = @[unlikeBtn,retweetbtn,commentBtn,playTourBtn];
    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [_btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(55) leadSpacing:kScaleX(29) tailSpacing:kScaleX(54)];
    [_btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self).offset(ghStatusCellMargin);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-ghStatusCellMargin);
    }];
    
    //添加懒加载控件
    [self addSubview:self.likeLabel];
    [self addSubview:self.TreadLable];
    [self addSubview:self.CommentsLabel];
    [self addSubview:self.topLineView];
    [self addSubview:self.cellSpacingView];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(unlikeBtn.mas_right);
        //.offset(kScaleX(ghStatusCellMargin));
    }];
    
    _likeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unlikeBtnClike)];
    [_likeLabel addGestureRecognizer:tap];
    
    [_TreadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(retweetbtn.mas_right);
        //.offset(kScaleX(ghStatusCellMargin));
    }];
    
    _TreadLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *treadLabletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retweetbtnClike)];
    [_TreadLable addGestureRecognizer:treadLabletap];
    
    [_CommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(commentBtn.mas_right);
        //.offset(kScaleX(ghStatusCellMargin));
    }];
    
    _CommentsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *commentsLabeltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentBtnClike)];
    [_CommentsLabel addGestureRecognizer:commentsLabeltap];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self);
        make.height.offset(0.5);
    }];
    
    UILabel *playTourlable = [UILabel labelWithText:@"鼓励" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self addSubview:playTourlable];
    [playTourlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_unlikeBtn.mas_centerY);
        make.left.equalTo(playTourBtn.mas_right);
        //.offset(kScaleX(8));
    }];
    
    playTourlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *playTourlabletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTourBtnClike)];
    [playTourlable addGestureRecognizer:playTourlabletap];
    
    [_cellSpacingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(10);
        make.left.bottom.right.equalTo(self);
        //make.top.equalTo(_commentBtn.mas_bottom).offset(5);
    }];
}

- (UIButton *)addChildButtonWithImageName:(NSString *)imageName  defaultTitle:(NSString *)title {
    UIButton *btn = [UIButton setNormalTitle:title andNormalColor:[UIColor colorWithHex:0x999999] andFont:12];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

#pragma mark - btn点击事件
- (void)retweetbtnClike { //踩
    self.retweetbtn.selected = !self.retweetbtn.selected;
    if (self.retweetbtnBlock) {
        self.retweetbtnBlock();
    }
}

- (void)unlikeBtnClike { //赞
    if (self.unlikeBtnBlock) {
        self.unlikeBtnBlock();
    }
}

- (void)commentBtnClike { //评论
    if (self.commentBtnBlock) {
        self.commentBtnBlock();
    }
}

- (void)playTourBtnClike { //打赏支持
    if (self.playTourBtnClikeBlock) {
        self.playTourBtnClikeBlock();
    }
}

#pragma mark - 懒加载
// 赞的数量
- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [UILabel labelWithText:@"12" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _likeLabel;
}
// 踩的数量
- (UILabel *)TreadLable {
    if (!_TreadLable) {
        _TreadLable = [UILabel labelWithText:@"20" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _TreadLable;
}
// 评论数量
- (UILabel *)CommentsLabel {
    if (!_CommentsLabel) {
        _CommentsLabel = [UILabel labelWithText:@"22" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _CommentsLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _topLineView;
}

- (UIView *)cellSpacingView {
    if (!_cellSpacingView) {
        _cellSpacingView = [[UIView alloc] init];
        _cellSpacingView.backgroundColor = [UIColor colorWithHex:0xededed];
    }
    return _cellSpacingView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _centerView;
}

- (UIView *)leftDividerView {
    if (!_leftDividerView) {
        _leftDividerView = [[UIView alloc] init];
        _leftDividerView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _leftDividerView;
}

- (UIView *)rightDividerView {
    if (!_rightDividerView) {
        _rightDividerView = [[UIView alloc] init];
        _rightDividerView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _rightDividerView;
}

@end
