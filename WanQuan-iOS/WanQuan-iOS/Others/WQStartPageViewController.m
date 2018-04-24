//
//  WQStartPageViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/2/2.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQStartPageViewController.h"

@interface WQStartPageViewController ()

@end

@implementation WQStartPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"load"];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSString *urlString = @"api/startupGraph/getStartupGraph";
//    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            return ;
//        }
//        NSLog(@"%@",response);
//        if ([response[@"success"] integerValue]) {
//            NSString *picid = response[@"startGraphPic"];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAppendingString:picid]] placeholderImage:[UIImage imageNamed:@"load"]];
//        }else {
//            imageView.image = [UIImage imageNamed:@"load"];
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
