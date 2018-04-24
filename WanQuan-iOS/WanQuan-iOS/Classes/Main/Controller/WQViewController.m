//
//  WQViewController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"

@interface WQViewController ()

@end

@implementation WQViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
