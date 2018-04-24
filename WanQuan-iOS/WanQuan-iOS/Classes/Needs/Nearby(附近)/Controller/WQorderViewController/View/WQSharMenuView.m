//
//  WQSharMenuView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSharMenuView.h"

@implementation WQSharMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMenu];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark - 初始化按钮
- (void)setupMenu {
    UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xialacaidan"]];
    ImageView.userInteractionEnabled = YES;
    [self addSubview:ImageView];
    [ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghNavigationBarHeight);
        make.right.equalTo(self).offset(-ghStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(127, 96));
    }];
    
    // 转发至群组
    UIButton *groupBtn = [[UIButton alloc] init];
    self.groupBtn = groupBtn;
    groupBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [groupBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self addSubview:groupBtn];
    [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ImageView);
        make.height.offset(ghCellHeight);
    }];
    // 分享到第三方
    UIButton *sharBtn = [[UIButton alloc] init];
    [sharBtn addTarget:self action:@selector(sharBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    sharBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sharBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [sharBtn setTitle:@"分享至第三方" forState:UIControlStateNormal];
    [self addSubview:sharBtn];
    [sharBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ImageView);
        make.bottom.equalTo(groupBtn.mas_top).offset(3);
        make.height.offset(ghCellHeight);
    }];
}

- (void)setIsGroupFriends:(BOOL)isGroupFriends {
    _isGroupFriends = isGroupFriends;
    if (isGroupFriends) {
        [self.groupBtn setTitle:@"万圈好友" forState:UIControlStateNormal];
        [self.groupBtn addTarget:self action:@selector(friendsBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self.groupBtn setTitle:@"转发至圈子" forState:UIControlStateNormal];
        [self.groupBtn addTarget:self action:@selector(groupBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 转发万圈好友
- (void)friendsBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqFriendsBtnClike)]) {
        [self.delegate wqFriendsBtnClike];
    }
}

// 转发至群组
- (void)groupBtnCliek {
    if ([self.delegate respondsToSelector:@selector(wqGroupBtnCliek)]) {
        [self.delegate wqGroupBtnCliek];
    }
}
// 分享到第三方
- (void)sharBtnCliek {
    if ([self.delegate respondsToSelector:@selector(wqSharBtnCliek)]) {
        [self.delegate wqSharBtnCliek];
    }
}

// 点击屏幕隐藏分享菜单
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(WQSharMenuViewHidden)]) {
        [self.delegate WQSharMenuViewHidden];
    }
}

@end
