//
//  WQGreetViewController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGreetViewController.h"
#import "WQTabBarController.h"
#import "WQLogInController.h"
@interface WQGreetViewController ()<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView * mainScroll;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, assign) NSInteger counter;
@end

@implementation WQGreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _mainScroll = ({
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:scrollView];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(kScreenHeight * 3, 5);
        scrollView.delegate = self;
        NSString * imageName = @"loading";
        
        for (NSInteger i = 0 ; i < 3 ; ++ i) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",imageName,i + 1]];
            [scrollView addSubview:imageView];
            
            if (i == 2) {
                UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - kScreenHeight / 15, kScreenWidth, kScreenHeight / 15)];
                imageView.userInteractionEnabled = YES;
                [imageView addSubview:btn];
                [btn addTarget:self action:@selector(changeRoot) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        scrollView;
    });
   
//    _counter = 0;
    
    __weak typeof(self) weakSelf = self;
    
    _timer = [NSTimer timerWithTimeInterval:10 target:weakSelf selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)autoScroll {
    
    _counter ++;
    
    if (!(_counter % 3)) {
        if (_mainScroll.contentOffset.x > 2 * kScreenWidth) {
            _timer.fireDate = [NSDate distantFuture];
            [_timer invalidate];
            _timer = nil;
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            _mainScroll.contentOffset = CGPointMake(_mainScroll.contentOffset.x + kScreenWidth, _mainScroll.contentOffset.y);
        }];
    }
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _counter = 0;
    
    
    if (scrollView.contentOffset.x > 2 * kScreenWidth) {
        [_timer invalidate];
        _timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].delegate.window.rootViewController = [WQSingleton sharedManager].isUserLogin? [[WQTabBarController alloc]init] : [[WQLogInController alloc] init];
        });
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     _counter = 0;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _counter = 0;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    _timer.fireDate = [NSDate distantFuture];
    [_timer invalidate];
    _timer = nil;
    [super viewWillDisappear:animated];
}


- (void)changeRoot {
    [_timer invalidate];
    _timer = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].delegate.window.rootViewController = [WQSingleton sharedManager].isUserLogin? [[WQTabBarController alloc]init] : [[WQLogInController alloc] init];
    });
}

- (void)dealloc {
    NSLog(@"%@",_timer);
}
@end
