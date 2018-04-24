//
//  WQNeedsController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNeedsController.h"
#import "WQHomeNewViewController.h"
#import "WQHomeNearbyViewController.h"
#import "WQHomeSubscribeViewController.h"
#import "SPPageMenu.h"


@interface WQNeedsController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, retain) UIPageViewController * pageController;
@property (nonatomic, retain) NSArray * pageItemViewControllers;
@property (nonatomic, retain) SPPageMenu * pageMenu;
@end

@implementation WQNeedsController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

- (void)setUpUI {
    

    [self addChildViewController:_pageController];
    _pageController.delegate = self;
    _pageController.dataSource = self;
    [_pageController didMoveToParentViewController:self];
    _pageController.doubleSided = YES;
    
    WQHomeNewViewController *shopDetailOrderVC = [WQHomeNewViewController new];
    WQHomeNearbyViewController *shopDetailCommentVC = [WQHomeNearbyViewController new];
    WQHomeSubscribeViewController *shopDetailShopVC = [WQHomeSubscribeViewController new];
    
    _pageItemViewControllers = @[shopDetailOrderVC, shopDetailCommentVC, shopDetailShopVC];
    
    [_pageController setViewControllers:@[shopDetailCommentVC]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    
    
    [self.view addSubview:_pageController.view];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"需求";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:20]}];
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

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSInteger i = [_pageItemViewControllers indexOfObject:viewController];
    if (i < _pageItemViewControllers.count -1) {
        return _pageItemViewControllers[i + 1];
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger i = [_pageItemViewControllers indexOfObject:viewController];
    if (i == 0) {
        return nil;
    }
    return _pageItemViewControllers[i - 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return _pageItemViewControllers.count;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}


@end
