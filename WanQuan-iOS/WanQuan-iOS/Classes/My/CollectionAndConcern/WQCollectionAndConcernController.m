//
//  WQCollectionAndConcernController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCollectionAndConcernController.h"
#import "WQMyConcernViewController.h"
#import "WQConcernMeController.h"
#import "WQMyFavoriteController.h"

@interface WQCollectionAndConcernController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, retain) UIPageViewController * pageController;
@property (nonatomic, retain) NSMutableArray * vcs;
@end

@implementation WQCollectionAndConcernController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _vcs = @[].mutableCopy;
    _pageController = [[UIPageViewController alloc]
                       initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                       options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    [self addChildViewController:_pageController];
    [_pageController didMoveToParentViewController:self];
    _pageController.delegate = self;
    _pageController.dataSource = self;
    _pageController.doubleSided = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"关注与收藏";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor blackColor]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIView * pageControllerView = _pageController.view;
    [self.view addSubview:pageControllerView];
    [pageControllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NAV_HEIGHT));
    }];
    
    WQMyConcernViewController * myConcern = [[WQMyConcernViewController alloc] init];
    WQConcernMeController * concernToMe = [[WQConcernMeController alloc] init];
    WQMyFavoriteController * favorite = [[WQMyFavoriteController alloc] init];
    
    
    _vcs = @[myConcern, concernToMe, favorite].mutableCopy;
    [_pageController setViewControllers:@[_vcs[0]]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
    
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    

    NSInteger i = [_vcs indexOfObject:viewController];
    
    switch (i) {
        case 0:
            return _vcs[1];
            break;
        case 1:
            return _vcs[2];
            break;
        case 2:
            return nil;
            break;
            
        default:
            break;
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {

    NSInteger i = [_vcs indexOfObject:viewController];
    
    switch (i) {
        case 0:
            return nil;
            break;
        case 1:
            return _vcs[0];
            break;
        case 2:
            return _vcs[1];
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
