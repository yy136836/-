//
//  WQAlertController.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQAlertController.h"

@interface WQAlertController ()

@end

@implementation WQAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)initWQAlertControllerWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style titleArray:(NSArray *)titleArray alertAction:(void (^)(NSInteger))alertAction
{
    if (style == UIAlertControllerStyleAlert) {
        WQAlertController *alert = [WQAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (NSInteger i = 0; i < titleArray.count; i++) {
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:[titleArray objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (alertAction) {
                    alertAction(i);
                }
            }];
            [alert addAction:confirm];
        }
        return alert;
    }else{
        WQAlertController *alert = [WQAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSInteger i = 0; i < titleArray.count; i++) {
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:[titleArray objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (alertAction) {
                    alertAction(i);
                }
            }];
            [alert addAction:confirm];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        return alert;
    }
}


- (void)showWQAlert
{
    [[self getCurrentVC] presentViewController:self animated:YES completion:nil];
}

//获取当前的VC
-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
