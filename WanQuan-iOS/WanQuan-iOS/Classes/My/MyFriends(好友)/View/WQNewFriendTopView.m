//
//  WQNewFriendTopView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewFriendTopView.h"
#import "WZLBadgeImport.h"
@implementation WQNewFriendTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQRecieveFriendRequestNotifacation object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQAddFriendNotifacation object:nil];
    [self hideOrShowDot:nil];
    self.badge.centerY = frame.size.height / 2;
    self.badge.centerX = frame.size.width - 25;
    return self;
}

- (void)hideOrShowDot:(NSNotification *)noti {
    if ([WQContactManager haveUnacceptedFriendRequest]) {
        [self showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    } else {
        [self clearBadge];
    }
}
#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xindepengyou"]];
    imageView.layer.cornerRadius = 22;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UILabel *titleLabel = [UILabel labelWithText:@"新的朋友" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(15);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    UIButton *pushNewFriendbtn = [[UIButton alloc] init];
    [pushNewFriendbtn addTarget:self action:@selector(pushNewFriendbtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pushNewFriendbtn];
    [pushNewFriendbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

static void extracted(WQNewFriendTopView *object) {
    object.pushNewFriend();
}

- (void)pushNewFriendbtnClike {
    if (self.pushNewFriend) {
        extracted(self);
    }
}

//-(void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQAddFriendNotifacation object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQRecieveFriendRequestNotifacation object:nil];
//}

@end
