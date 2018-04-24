//
//  WQInquiryUserInfoController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQInquiryUserInfoController.h"

#define TAG_BTN 1000

@interface WQInquiryUserInfoController ()

@end

@implementation WQInquiryUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)chooseUserSituation:(id)sender {
    
//    todohanyang
    NSInteger buttonIndex = ((UIButton *)sender).tag - TAG_BTN;
    
    switch (buttonIndex) {
        case 0:{
//            MBA
            
            break;
        }
        case 1:{
//            社科院
            
            break;
        }
        case 2:{
//            都不是
            
            break;
        }
        default:
            break;
    }
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
