//
//  WQRelationsCircleHomeHeaderView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRelationsCircleHomeHeaderView.h"

@implementation WQRelationsCircleHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHeaderView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化HeaderView
- (void)setupHeaderView {
    
    // 底部分割线
//    UIView *bottomLineView = [[UIView alloc] init];
//    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
//    [self addSubview:bottomLineView];
//    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(kScaleX(ghStatusCellMargin));
//        make.left.right.bottom.equalTo(self);
//    }];
    
    // 背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewWanquanbanner.jpg"]];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
//    // 因为有阴影,用图片
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle 6 Copy"]];
//    [backgroundImageView addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
//        make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
//        make.bottom.equalTo(bottomLineView.mas_top).offset(kScaleX(3));
//        make.height.offset(kScaleY(80));
//    }];
    
//    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
//    if ([role_id isEqualToString:@"200"]) {
//        // 游客登录
//        // 图标
//        UIImageView *visitorsLogIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanquanHome游客好友圈"]];
//        [imageView addSubview:visitorsLogIcon];
//        [visitorsLogIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imageView.mas_top).offset(kScaleX(6));
//            make.left.equalTo(imageView.mas_left).offset(kScaleY(5));
//            make.size.mas_equalTo(CGSizeMake(kScaleY(80), kScaleX(68)));
//        }];
//
//        // 立即登录的label
//        UILabel *loginImmediatelyLabel = [UILabel labelWithText:@"立即登录" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
//        loginImmediatelyLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:16];
//        [imageView addSubview:loginImmediatelyLabel];
//        [loginImmediatelyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imageView.mas_top).offset(kScaleX(ghDistanceershi));
//            make.left.equalTo(visitorsLogIcon.mas_right).offset(kScaleX(ghSpacingOfshiwu));
//        }];
//
//        // 浏览动态label
//        UILabel *browseLabel = [UILabel labelWithText:@"浏览动态，加入圈子" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
//        [imageView addSubview:browseLabel];
//        [browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(loginImmediatelyLabel.mas_left);
//            make.top.equalTo(loginImmediatelyLabel.mas_bottom).offset(kScaleX(ghStatusCellMargin));
//        }];
//    }else {
//        // 头像
//        UIImageView *headPortrait = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodehaoyouquan-1"]];
//        [imageView addSubview:headPortrait];
//        [headPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(kScaleY(50), kScaleX(50)));
//            make.top.equalTo(imageView).offset(kScaleX(ghSpacingOfshiwu));
//            make.left.equalTo(imageView).offset(kScaleY(ghSpacingOfshiwu));
//        }];
//
//        // 我的好友圈的Label
//        UILabel *myFriendsCircle = [UILabel labelWithText:@"我的好友圈" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:18];
//        myFriendsCircle.font = [UIFont fontWithName:@".PingFangSC-Medium" size:18];
//        [imageView addSubview:myFriendsCircle];
//        [myFriendsCircle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headPortrait.mas_top);
//            make.left.equalTo(headPortrait.mas_right).offset(kScaleY(ghSpacingOfshiwu));
//        }];
//
//        // 发布人的头像
//        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanquan_icon1111-40"]];
//        self.headPortrait = logoImageView;
//        logoImageView.contentMode = UIViewContentModeScaleAspectFill;
//        logoImageView.layer.cornerRadius = ghStatusCellMargin;
//        logoImageView.layer.masksToBounds = YES;
//        [self addSubview:logoImageView];
//        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(kScaleY(ghDistanceershi), kScaleX(ghDistanceershi)));
//            make.left.equalTo(headPortrait.mas_right).offset(17);
//            make.bottom.equalTo(headPortrait.mas_bottom);
//        }];
//
//        // 发不的新内容
//        UILabel *subjectLabel = [UILabel labelWithText:@"万圈小助手等几位好友发布了新的动态了新的了新的" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
//        self.subjectLabel = subjectLabel;
//        subjectLabel.numberOfLines = 1;
//        [self addSubview:subjectLabel];
//        [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(logoImageView.mas_right).offset(7);
//            make.right.equalTo(self.mas_right).offset(-40);
//            make.centerY.equalTo(logoImageView.mas_centerY);
//        }];
//    }
//
//    // 三角
//    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sanjiao"]];
//    [self addSubview:triangleImage];
//    [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.size.mas_equalTo(CGSizeMake(kScaleX(12), kScaleY(14)));
//        make.right.equalTo(imageView.mas_right).offset(-ghStatusCellMargin);
//        make.centerY.equalTo(imageView.mas_centerY);
//    }];
}

@end
