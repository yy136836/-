//
//  WQlittleHelperStatusToolBarView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQlittleHelperStatusToolBarView.h"

@interface WQlittleHelperStatusToolBarView()
@property (nonatomic, strong) UIView *dividingLine;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *cellSpacingView;
@end

@implementation WQlittleHelperStatusToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor]; 
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 评论
    UIButton *commentBtn = [self addChildButtonWithImageName:@"haoyouquanpinglun" defaultTitle:@""];
    [commentBtn addTarget:self action:@selector(commentBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    // 赞
    UIButton *unlikeBtn = [self addChildButtonWithImageName:@"haoyouquanzan" defaultTitle:@""];
    self.unlikeBtn = unlikeBtn;
    [unlikeBtn addTarget:self action:@selector(unlikeBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *btnArray = @[unlikeBtn,commentBtn];
    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:172 leadSpacing:70 tailSpacing:70];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(self).offset(-ghStatusCellMargin);
        make.top.equalTo(self).offset(ghStatusCellMargin);
    }];
    
    //[self addSubview:self.dividingLine];
    [self addSubview:self.likeLabel];
    [self addSubview:self.CommentsLabel];
    [self addSubview:self.topView];
    [self addSubview:self.cellSpacingView];
    
//    [_dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self).offset(ghStatusCellMargin);
//        make.bottom.equalTo(self).offset(-15);
//        make.width.offset(0.5);
//    }];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unlikeBtn.mas_centerY);
        make.left.equalTo(unlikeBtn.mas_right);
    }];
    [_CommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentBtn.mas_centerY);
        make.left.equalTo(commentBtn.mas_right);
    }];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self);
        make.height.offset(0.5);
    }];
    [_cellSpacingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(10);
        make.left.right.bottom.equalTo(self);
    }];
}

// 评论的响应事件
- (void)commentBtnCliek {
    if (self.commentBtnBlock) {
        self.commentBtnBlock();
    }
}

// 赞的响应事件
- (void)unlikeBtnCliek {
    if (self.unlikeBtnBlock) {
        self.unlikeBtnBlock();
    }
}

- (void)setIsHome:(BOOL)isHome {
    _isHome = isHome;
    // 不是从首页过来的,是详情
    if (!isHome) {
        _cellSpacingView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        [_cellSpacingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.left.right.bottom.equalTo(self);
        }];
    }
}

- (UIButton *)addChildButtonWithImageName:(NSString *)imageName  defaultTitle:(NSString *)title {
    UIButton *btn = [UIButton setNormalTitle:title andNormalColor:[UIColor grayColor] andFont:12];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

#pragma mark - 懒加载
// 赞的数量
- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [UILabel labelWithText:@"12" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _likeLabel;
}
// 评论数量
- (UILabel *)CommentsLabel {
    if (!_CommentsLabel) {
        _CommentsLabel = [UILabel labelWithText:@"22" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _CommentsLabel;
}
// 中间的分割线
- (UIView *)dividingLine {
    if (!_dividingLine) {
        _dividingLine = [[UIView alloc] init];
        _dividingLine.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _dividingLine;
}
// 顶部的线
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _topView;
}

- (UIView *)cellSpacingView {
    if (!_cellSpacingView) {
        _cellSpacingView = [[UIView alloc] init];
        _cellSpacingView.backgroundColor = [UIColor colorWithHex:0xededed];
    }
    return _cellSpacingView;
}

@end
