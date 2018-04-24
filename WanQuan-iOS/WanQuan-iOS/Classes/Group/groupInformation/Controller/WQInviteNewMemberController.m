//
//  WQInviteNewMemberController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQInviteNewMemberController.h"
#import "WQShareFriendListController.h"

#define BTN_TITLES  @[@"万圈好友"/**,@"转发至万圈"*/,@"第三方好友"]

@interface WQInviteNewMemberController ()

@end

@implementation WQInviteNewMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)];
    [self.view addGestureRecognizer:tap];
    [self setupUI];
    
}

- (void)setupUI {
    for (NSInteger i = 0 ; i < BTN_TITLES.count; ++ i) {
        
        UIButton * btn = [[UIButton alloc] init];
        [btn setTitle:BTN_TITLES[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHex:0x5d2a89].CGColor;
        [btn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];

        [self.view addSubview:btn];
        
        CGFloat width = kScreenWidth / 3 - 10;
        
        CGFloat margin = (kScreenWidth - 2 * width) / 3;
        
        btn.frame = CGRectMake(margin + i * (width + margin), kScreenHeight - 120, width, 44);
        btn.center = CGPointMake(btn.centerX, kScreenHeight / 7 * 6);
        
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)share:(UIButton *)sender {
    
    NSString * title = sender.currentTitle;
    
    if ([title isEqualToString:BTN_TITLES[0]]) {
        if (self.shareToEMFriend) {
            self.shareToEMFriend();
        }
    }
    
//    if ([title isEqualToString:BTN_TITLES[1]]) {
//        if (self.shareToMiriade) {
//            self.shareToMiriade();
//        }
//    }
    
    if ([title isEqualToString:BTN_TITLES[1]]) {
        if (self.shereToThird) {
            self.shereToThird();
        }
    }

    [self ontap];
    
}

- (void)ontap {
    [self.view removeFromSuperview];
}

@end
