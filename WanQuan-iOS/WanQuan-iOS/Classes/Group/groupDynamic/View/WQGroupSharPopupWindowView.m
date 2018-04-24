//
//  WQGroupSharPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupSharPopupWindowView.h"

@interface WQGroupSharPopupWindowView ()

@property (nonatomic, strong) UIImageView *ImageView;

@end

@implementation WQGroupSharPopupWindowView

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
    UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenxiangdikuang"]];
    self.ImageView = ImageView;
    ImageView.userInteractionEnabled = YES;
    [self addSubview:ImageView];
    [ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-ghStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(127, 106));
    }];
    
    // 转发至万圈好友
    UIButton *friendsBtn = [[UIButton alloc] init];
    [friendsBtn setTitle:@"万圈好友" forState:UIControlStateNormal];
    friendsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [friendsBtn addTarget:self action:@selector(friendsBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self addSubview:friendsBtn];
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ImageView);
        make.top.equalTo(ImageView.mas_top).offset(ghStatusCellMargin);
        make.height.offset(48);
    }];
    
    // 分割线
    UIView *separatedView = [[UIView alloc] init];
    separatedView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self addSubview:separatedView];
    [separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(friendsBtn);
        make.top.equalTo(friendsBtn.mas_bottom);
        make.height.offset(0.5);
    }];
    
    // 转发至群组
    /*UIButton *groupBtn = [[UIButton alloc] init];
    [groupBtn setTitle:@"分享至万圈" forState:UIControlStateNormal];
    groupBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [groupBtn addTarget:self action:@selector(groupBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [groupBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self addSubview:groupBtn];
    [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ImageView);
        make.top.equalTo(separatedView.mas_bottom);
        make.height.offset(48);
    }];*/
    
    // 分割线
//    UIView *twoSeparatedView = [[UIView alloc] init];
//    twoSeparatedView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//    [self addSubview:twoSeparatedView];
//    [twoSeparatedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.equalTo(groupBtn);
//        make.top.equalTo(groupBtn.mas_bottom);
//        make.height.offset(0.5);
//    }];

    
    // 分享到第三方
    UIButton *sharBtn = [[UIButton alloc] init];
    [sharBtn addTarget:self action:@selector(sharBtnClike) forControlEvents:UIControlEventTouchUpInside];
    sharBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sharBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [sharBtn setTitle:@"分享至第三方" forState:UIControlStateNormal];
    [self addSubview:sharBtn];
    [sharBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ImageView);
        make.bottom.equalTo(ImageView.mas_bottom);
        make.height.offset(48);
    }];

}

// 转发至万圈好友
- (void)friendsBtnClike {
    if ([self.delegate respondsToSelector:@selector(friendsBtnClike:)]) {
        [self.delegate friendsBtnClike:self];
    }
}

// 转发万圈
- (void)groupBtnClike {
    if ([self.delegate respondsToSelector:@selector(groupBtnClike:)]) {
        [self.delegate groupBtnClike:self];
    }
}

// 分享第三方
- (void)sharBtnClike {
    if ([self.delegate respondsToSelector:@selector(sharBtnClike:)]) {
        [self.delegate sharBtnClike:self];
    }
}

// 点击屏幕隐藏分享菜单
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(WQSharMenuViewHidden:)]) {
        [self.delegate WQSharMenuViewHidden:self];
    }
}


- (void)setIsWQGroupDynamicVC:(BOOL)isWQGroupDynamicVC {
    _isWQGroupDynamicVC = isWQGroupDynamicVC;
    if (isWQGroupDynamicVC) {
        [self.ImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(ghNavigationBarHeight);
            make.right.equalTo(self).offset(-ghStatusCellMargin);
            make.size.mas_equalTo(CGSizeMake(127, 106));
        }];
    }
}

@end
