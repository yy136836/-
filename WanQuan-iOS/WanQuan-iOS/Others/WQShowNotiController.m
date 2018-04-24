//
//  WQShowNotiController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQShowNotiController.h"

@interface WQShowNotiController ()

@end

@implementation WQShowNotiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onclick:(id)sender {
    if (self.dissmiss) {
        self.dissmiss();
    }
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
