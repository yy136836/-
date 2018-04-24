//
//  WQmessageHomeTopView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmessageHomeTopView.h"
#import "WQslidingView.h"
#import "WQFriendsViewController.h"
#import "WZLBadgeImport.h"
#import "WQNewGroupViewController.h"
#import "WQUserProfileController.h"
#import "WQSystemMessageController.h"
#import "WQTabBarController.h"
@interface WQmessageHomeTopView()
@end

@implementation WQmessageHomeTopView {
    NSArray <UIButton *>*_btnArray;
    UIButton * _chatButton;
    //UIButton *newGroupBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingbulan"]];
    
    [self addSubview:backgroundImageView];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    WQslidingView *slidingView = [[WQslidingView alloc] init];
    self.slidingView = slidingView;
    [self addSubview:slidingView];
    
    UIButton *systemMessageBtn = [[UIButton alloc] init];
    self.systemMessageBtn = systemMessageBtn;
    UIButton *sessionBtn = [[UIButton alloc] init];
    [systemMessageBtn setTitle:@"群组" forState:UIControlStateNormal];
    systemMessageBtn.tag = 0;
    [systemMessageBtn addTarget:self action:@selector(systemMessageBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    sessionBtn.tag = 1;
    [sessionBtn setTitle:@"聊天" forState:UIControlStateNormal];
    [sessionBtn addTarget:self action:@selector(systemMessageBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    [systemMessageBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [sessionBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    systemMessageBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    sessionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _chatButton = sessionBtn;
    [self addSubview:systemMessageBtn];
    [self addSubview:sessionBtn];
    
    _btnArray = @[systemMessageBtn,sessionBtn];
    
    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [_btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(50) leadSpacing:kScaleX(110) tailSpacing:kScaleX(110)];
    [_btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(slidingView.mas_top).offset(0);
    }];
    
    [slidingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-8);
        make.height.offset(2);
        make.width.equalTo(systemMessageBtn.mas_width);
        make.centerX.equalTo(systemMessageBtn.mas_centerX);
    }];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    self.rightBtn = rightBtn;
    rightBtn.hidden = NO;
    rightBtn.tag = 1;
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitle:@"新建群" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(rightBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sessionBtn.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
    }];
    
    // 系统消息
    UIButton *systemMessage = [[UIButton alloc] init];
    __weak typeof(self) weakSelf = self;
    
    [systemMessage setImage:[UIImage imageNamed:@"SystemMessage"] forState:UIControlStateNormal];
    [self addSubview:systemMessage];
    [systemMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightBtn.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    
    WQTabBarController * root = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if ([root isKindOfClass:[WQTabBarController class]]) {
        if (root.haveSystemInfoToDealWith) {
            [systemMessage showBadge];
        }
    }
    
    __weak typeof(systemMessage) weaksystemMessage = systemMessage;
    [systemMessage addClickAction:^(UIButton * _Nullable sender) {
        root.haveSystemInfoToDealWith = NO;
        [weaksystemMessage clearBadge];
        WQSystemMessageController *vc = [[WQSystemMessageController alloc] init];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [self hideOrShowDot:nil];
}

- (void)rightBtnClike:(UIButton *)sender {
    if (sender.tag == 1) {
        if (![WQDataSource sharedTool].verified) {
            // 快速注册的用户
            UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                     message:@"实名认证后可创建群"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSLog(@"取消");
                                                                 }];
            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];

                                                                          [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                      }];
            [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            return;
        }
        WQNewGroupViewController *vc = [[WQNewGroupViewController alloc] init];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQFriendsViewController *vc = [[WQFriendsViewController alloc] init];
        vc.isNewFriends = NO;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

// 系统消息
- (void)systemMessageBtnClike:(UIButton *)sender {
    if (sender.tag == 0) {
        self.rightBtn.hidden = NO;
        self.rightBtn.tag = 1;
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"新建圈" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        self.rightBtn.hidden = NO;
        self.rightBtn.tag = 2;
        [self.rightBtn setImage:[UIImage imageNamed:@"tongxunlu"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (self.systemMessageBtnClikeBlock) {
        self.systemMessageBtnClikeBlock(sender.tag);
    }
}

// 即时会话
- (void)sessionBtnClike {
    
}

- (void)reloadSlodingViewLocation:(CGFloat)offsetX {
    CGFloat width = self.systemMessageBtn.frame.size.width;
    [self.slidingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.systemMessageBtn.mas_centerX).offset((kScaleX(50) + width ) / [UIScreen mainScreen].bounds.size.width * offsetX);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.btnCGfloat = _btnArray[0].frame.size.width;
}


- (void)hideOrShowDot:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL shouldShowDot = [WQUnreadMessageCenter haveUnreadFriendMessage];
        if (shouldShowDot) {
            [_chatButton showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
            
        } else {
            [_chatButton clearBadge];
        }
        
        
        WQTabBarController * root = [UIApplication sharedApplication].delegate.window.rootViewController;
        
        if ([root isKindOfClass:[WQTabBarController class]]) {
            if (root.haveSystemInfoToDealWith) {
                [_systemMessageBtn showBadge];
            } else {
                [_systemMessageBtn clearBadge];
            }
        }
        
        
    });
}

@end
