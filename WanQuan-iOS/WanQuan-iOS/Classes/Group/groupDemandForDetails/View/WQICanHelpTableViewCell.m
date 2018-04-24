//
//  WQICanHelpTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQICanHelpTableViewCell.h"
#import "WQHomeNearby.h"
#import "WQChaViewController.h"
#import "WQNearbyroboneViewController.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQfeedbackViewController.h"

@implementation WQICanHelpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setModel:(WQHomeNearby *)model {
    _model = model;
    // 判断订单是否已经完成
    if ([model.status isEqualToString:@"STATUS_FNISHED"]) { // 已完成
        self.askBtn.hidden = YES;
        self.askBtn.enabled = NO;
        self.helpBtn.enabled = NO;
        self.helpBtn.backgroundColor = [UIColor whiteColor];
        [self.helpBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateDisabled];
        self.helpBtn.layer.borderWidth = 1.0f;
        self.helpBtn.layer.cornerRadius = 5;
        self.helpBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        [self.helpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.bottom.right.equalTo(self.contentView).offset(-15);
            make.height.offset(ghCellHeight);
        }];
    }else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        // 如果是我自己的话显示 查看我的订单详情
        if ([model.user_id isEqualToString:im_namelogin]) {
            self.askBtn.hidden = YES;
            self.helpBtn.hidden = YES;
            self.feedbackBtn.hidden = YES;
            
            // 分割线
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self);
                make.height.offset(ghStatusCellMargin);
            }];
            
            [self addSubview:self.myOrderBtn];
            [self.myOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.equalTo(self.contentView.mas_left).offset(15);
                make.bottom.equalTo(lineView.mas_top).offset(-ghDistanceershi);
                make.height.offset(ghCellHeight);
                make.width.offset(kScaleY(220));
                make.centerX.equalTo(self.contentView.mas_centerX);
            }];
        }else {
            // 分割线
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self);
                make.height.offset(ghStatusCellMargin);
            }];
            
            [self addSubview:self.feedbackBtn];
           // [self addSubview:self.askBtn];
            [self addSubview:self.helpBtn];
            
            self.askBtn.enabled = YES;
            self.helpBtn.enabled = YES;
            
            [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            }];
            
//            [_askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self).offset(ghSpacingOfshiwu);
//                make.bottom.equalTo(lineView.mas_top).offset(-ghDistanceershi);
//                make.height.offset(ghCellHeight);
//                make.width.offset(kScaleY(110));
//            }];
            [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
                make.bottom.equalTo(lineView.mas_top).offset(-ghDistanceershi);
                make.height.offset(ghCellHeight);
                make.left.equalTo(self).offset(ghSpacingOfshiwu);

                //make.left.equalTo(_askBtn.mas_right).offset(15);
            }];
        }
    }
}

#pragma mark - 监听事件
// 询问
- (void)askBtnClike {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    BOOL sholdHide = [role_id isEqualToString:@"200"];
    if (sholdHide) {
        [WQAlert showAlertWithTitle:nil message:@"请登录后操作" duration:1.5];
        return;
    }
    if ([self.model.status isEqualToString: @"STATUS_FNISHED"]) {
        return;
    }
    if ([role_id isEqualToString:@"200"]) {
        // 游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([_model.user_id isEqualToString:[EMClient sharedClient].currentUsername]){
            EaseConversationListViewController *chatList = [[EaseConversationListViewController alloc] initWithNid:self.model.id needOwnerId:self.model.user_id isFromTemp:NO bidUserList:nil];
            [self.viewController.navigationController pushViewController:chatList animated:YES];
        }else{
            // 是临时会话
            if ([self.delegate respondsToSelector:@selector(wqICanHelpTableViewCell:askBtnClike:)]) {
                [self.delegate wqICanHelpTableViewCell:self askBtnClike:nil];
            }
        }
    }
}
// 我能帮助
- (void)helpBtnClike {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    BOOL sholdHide = [role_id isEqualToString:@"200"];
    
    if (sholdHide) {
        [WQAlert showAlertWithTitle:nil message:@"请登录后操作" duration:1.5];
        return;
    }
    if ([_model.status isEqualToString: @"STATUS_FNISHED"]) {
        return;
    }
    WQNearbyroboneViewController *nearbyroboneVc = [[WQNearbyroboneViewController alloc]init];
    nearbyroboneVc.stringuserId = _model.id;
    [self.viewController.navigationController pushViewController:nearbyroboneVc animated:YES];
}
// 我的订单
- (void)myOrderBtnClike {
    WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:_model.id wqOrderType:WQOrderTypeSelected];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

// 投诉的响应事件
- (void)fankuiBtnClike {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        [WQAlert showAlertWithTitle:nil message:@"未登录不允许投诉" duration:1.5];
        return;
    }

    WQfeedbackViewController *feedbackVc = [WQfeedbackViewController new];
    [self.viewController.navigationController pushViewController:feedbackVc animated:YES];
}

#pragma mark - 懒加载
- (UIButton *)askBtn {
    if (!_askBtn) {
        _askBtn = [[UIButton alloc] init];
        _askBtn.backgroundColor = [UIColor whiteColor];
        _askBtn.layer.borderWidth = 1.0f;
        _askBtn.layer.cornerRadius = 5;
        _askBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        _askBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_askBtn setTitle:@"询问" forState:UIControlStateNormal];
        [_askBtn setTitleColor:[UIColor colorWithHex:0X9767d0] forState:UIControlStateNormal];
        [_askBtn addTarget:self action:@selector(askBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _askBtn;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [[UIButton alloc] init];
        _helpBtn.backgroundColor = [UIColor colorWithHex:0X9767d0];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_helpBtn setTitle:@"我能帮助" forState:UIControlStateNormal];
        [_helpBtn setTitle:@"需求已完成" forState:UIControlStateDisabled];
        [_helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _helpBtn.layer.cornerRadius = 5;
        [_helpBtn addTarget:self action:@selector(helpBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}
// 我的订单
- (UIButton *)myOrderBtn {
    if (!_myOrderBtn) {
        _myOrderBtn = [[UIButton alloc] init];
        _myOrderBtn.backgroundColor = [UIColor whiteColor];
        _myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _myOrderBtn.layer.borderWidth = 1.0f;
        _myOrderBtn.layer.cornerRadius = 5;
        _myOrderBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        [_myOrderBtn setTitleColor:[UIColor colorWithHex:0X9767d0] forState:UIControlStateNormal];
        [_myOrderBtn setTitle:@"查看需求详情" forState:UIControlStateNormal];
        [_myOrderBtn addTarget:self action:@selector(myOrderBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myOrderBtn;
}
// 投诉按钮
- (UIButton *)feedbackBtn {
    if (!_feedbackBtn) {
        _feedbackBtn = [[UIButton alloc] init];
        _feedbackBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_feedbackBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [_feedbackBtn setTitleColor:[UIColor colorWithHex:0x878787] forState:UIControlStateNormal];
        [_feedbackBtn addTarget:self action:@selector(fankuiBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedbackBtn;
}

@end
