//
//  WQHeadImageView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHeadImageView.h"
#import "WQUserProfileController.h"

@implementation WQHeadImageView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
//    }
//    return self;
//}
//
//- (instancetype)init {
//    
//    self = [self initWithFrame:CGRectZero];
//    if (self) {
//        
//    }
//    return self;
//}

- (instancetype)init {
    
    NSAssert(0, @"DO_NOT_INIT_USE_XIB_PLEASE");
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    NSAssert(0, @"DO_NOT_INIT_USE_XIB_PLEASE");
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    NSAssert(0, @"DO_NOT_INIT_USE_XIB_PLEASE");
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(0, @"DO_NOT_INIT_USE_XIB_PLEASE");
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

- (void)onTap {
    
    if (self.tapaction) {
        self.tapaction();
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    __weak typeof(self) weakSelf = self;
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    
    if (!self.tureName) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
        
        [weakSelf.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
            });
        }];
        return ;
    }
    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDefault
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
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.userId isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.userId];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.userId];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
}
@end
