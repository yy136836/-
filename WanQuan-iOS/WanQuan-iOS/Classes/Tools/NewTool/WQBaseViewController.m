//
//  WQBaseViewController.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQBaseViewController.h"
@interface WQBaseViewController ()
@property (nonatomic,retain)WQLoadingView *loadingView;
@property (nonatomic,retain)WQLoadingError *loadingError;
;
@end

@implementation WQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showLogading:(BOOL)show
{
    if (show) {
        [self.loadingView show];
    }else{
        [self.loadingView dismiss];
    }
    
}

- (WQLoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[WQLoadingView alloc] init];
        [self.view addSubview:_loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _loadingView;
}

- (WQLoadingError *)loadingError
{
    if (!_loadingError) {
        _loadingError = [[WQLoadingError alloc] init];
        [self.view addSubview:_loadingError];
        [_loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NAV_HEIGHT);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _loadingError;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
