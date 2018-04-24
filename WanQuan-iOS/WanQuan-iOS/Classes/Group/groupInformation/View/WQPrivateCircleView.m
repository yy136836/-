//
//  WQPrivateCircleView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPrivateCircleView.h"

@implementation WQPrivateCircleView {
    // 底部提示的文案
    UILabel *promptLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.offset(55);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"设为私密圈" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    textLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(ghSpacingOfshiwu);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UISwitch *wqSwitch = [[UISwitch alloc] init];
    self.wqSwitch = wqSwitch;
    // wqSwitch.on = YES;
    wqSwitch.onTintColor = [UIColor colorWithHex:0x9767d0];
    [wqSwitch addTarget:self action:@selector(switchAnonymous:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:wqSwitch];
    [wqSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textLabel.mas_centerY);
        make.right.equalTo(view.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 底部提示的文案
    promptLabel = [UILabel labelWithText:@"开启时，加入圈子需先发送申请，圈主或管理员同意后才可加入。" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
    promptLabel.numberOfLines = 0;
    [self addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textLabel.mas_left);
        make.top.equalTo(view.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
    }];
}

- (void)switchAnonymous:(UISwitch *)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (sender.isOn) {
        params[@"privacy"] = @"true";
    }else {
        params[@"privacy"] = @"false";
    }
    
    // 圈主页
    if (_isNewGroup == false) {
        NSString *urlString = @"api/group/updategroup";
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"gid"] = self.gid;
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
                [SVProgressHUD dismissWithDelay:1];
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            // UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            [self.viewController presentViewController:alertVC animated:YES completion:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                });
//            }];
        }];
    }
}

- (void)setIsNewGroup:(BOOL)isNewGroup {
    _isNewGroup = isNewGroup;
    
    if (isNewGroup) {
        promptLabel.text = @"开启时，加入圈子需先发送申请，圈主或管理员同意后才可加入;圈子建立后可在圈名片页面修改。";
    }else {
        promptLabel.text = @"开启时，加入圈子需先发送申请，圈主或管理员同意后才可加入。";
    }
}

@end
