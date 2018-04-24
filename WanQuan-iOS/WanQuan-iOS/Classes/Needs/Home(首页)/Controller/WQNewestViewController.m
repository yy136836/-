//
//  WQNewestViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNewestViewController.h"
#import "AwesomeMenu.h"
#import "WQButtonCategoryView.h"
#import "WQHomeNewViewController.h"
#import "WQHomeNearbyViewController.h"
#import "WQHomeSubscribeViewController.h"
#import "WQRailTableView.h"
#import "WQdemaadnforHairViewController.h"
#import "WQHomeMapViewController.h"
#import "WQHomeSearchViewController.h"
#import "WQMapViewSearchController.h"
#import "WQAddneedController.h"
#import "WQLogInController.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"
#import "WQNavigationController.h"
#import "WQLatestControllerCollectionViewCell.h"
#import "WQNearControllerCollectionViewCell.h"
#import "WQSubscribeControllerCollectionViewCell.h"

static NSString *identifier = @"Identifier";
static NSString *identifiertwo = @"identifiertwo";
static NSString *identifierthree = @"identifierthree";

@interface WQNewestViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ButtonCategoryDelegate,WQLoginPopupWindowDelegate>

@property (nonatomic, strong) WQButtonCategoryView *categoryView;
@property (nonatomic, strong) NSMutableDictionary *vcCache;
@property (nonatomic, weak) UIScrollView* shopDetailView;
@property (nonatomic, weak) WQRailTableView *railView;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@property (nonatomic, assign) NSInteger intager;

@property (nonatomic, strong) UIBarButtonItem *searchBtn;
@property (nonatomic, strong) UIBarButtonItem *subscribeBtn;
@property (nonatomic, strong) UIBarButtonItem *nearBtn;
@property (nonatomic, strong) NSMutableArray *barButtons;
@property (nonatomic, strong) NSMutableArray *rightBarButtons;

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WQNewestViewController {
    NSUserDefaults *userDefaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];

    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyesousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    self.searchBtn = searchBtn;
    UIBarButtonItem *subscribeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyedingyue"] style:UIBarButtonItemStylePlain target:self action:@selector(subscribeBtnClick)];
    self.subscribeBtn = subscribeBtn;
    UIBarButtonItem *nearBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyefujin"] style:UIBarButtonItemStylePlain target:self action:@selector(nearBtnClick)];
    self.nearBtn = nearBtn;
    self.navigationItem.rightBarButtonItems = @[subscribeBtn,searchBtn];
    self.navigationItem.leftBarButtonItem = nearBtn;
    
    self.rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [self.rightBarButtons removeObject:subscribeBtn];
    self.navigationItem.rightBarButtonItems = self.rightBarButtons;
    self.barButtons = [self.navigationItem.leftBarButtonItems mutableCopy];
    [self.barButtons removeObject:self.nearBtn];
    self.navigationItem.leftBarButtonItems = self.barButtons;
    
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"WQNewestViewController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.navigationItem.title = @"需求";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = HEX(0xfafafa);
    self.navigationController.navigationBar.shadowImage = WQ_SHADOW_IMAGE;
    [MobClick beginLogPageView:@"WQNewestViewController"];
}

+ (void)setBackgroundTaskEnabled:(BOOL)value {
//    value = YES;
}

#pragma mark - 初始化UI
- (void)setupUI {
    WQButtonCategoryView *categoryView = [[WQButtonCategoryView alloc]init];
    categoryView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    categoryView.delegate = self;
    self.categoryView = categoryView;
    
    //点击事件
    __weak typeof(self) weakSelf = self;
    categoryView.BtnClickBlock = ^(NSInteger index) {
        [weakSelf.collectionView setContentOffset:CGPointMake(index * self.view.bounds.size.width, 0) animated:NO];
        
        switch (index) {
            case 0:
                self.navigationItem.leftBarButtonItems = @[self.nearBtn];
                self.navigationItem.rightBarButtonItems =@[self.searchBtn];
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:categoryView];
    
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.height.offset(40);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[WQNearControllerCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [collectionView registerClass:[WQLatestControllerCollectionViewCell class] forCellWithReuseIdentifier:identifiertwo];
    [collectionView registerClass:[WQSubscribeControllerCollectionViewCell class] forCellWithReuseIdentifier:identifierthree];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(categoryView.mas_bottom);
    }];

    WQRailTableView *railView = [[WQRailTableView alloc] init];
    self.railView = railView;
    [categoryView addSubview:railView];
    
    [railView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(categoryView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScaleX(20), kScaleY(3)));
        make.centerX.equalTo(categoryView.mas_left).offset(_intager);
    }];
    
    [self.view layoutIfNeeded];
    _intager = (categoryView.bounds.size.width - self.categoryView.btnCGfloat * 3) / 2 + self.categoryView.btnCGfloat* 0.5;
    
    categoryView.BtnClickBlock(1);
    
    UIButton *plusBtn = [[UIButton alloc]init];
    [plusBtn setImage:[UIImage imageNamed:@"fabuanniulanxuqiu"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.offset(106);
        make.bottom.equalTo(self.view).offset(-55);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionRight];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.collectionView.frame.size;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

#pragma mark -- 附近的点击事件
- (void)nearBtnClick {
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    WQHomeMapViewController *homeMapVc = [WQHomeMapViewController new];
    homeMapVc.isNearby = YES;
    [self.navigationController pushViewController:homeMapVc animated:YES];
}

#pragma mark -- 订阅的点击事件
- (void)subscribeBtnClick {
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    WQAddneedController *managesubscriptionsVc = [WQAddneedController new];
    managesubscriptionsVc.type = NeedControllerTypeSubScription;
    [self.navigationController pushViewController:managesubscriptionsVc animated:YES];
}

#pragma mark -- 搜索的点事件
- (void)searchBtnClick {
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    ROOT(root);
    
    WQHomeSearchViewController *homeSearchVc = [[WQHomeSearchViewController alloc] init];
    WQNavigationController * nc = [[WQNavigationController alloc] initWithRootViewController:homeSearchVc];
    [root presentViewController:nc animated:NO completion:nil];
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    //WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    //vc.isLogin = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}


/**
 发布新的需求
 */
- (void)plusBtnClike {
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
    }else{
        WQAddneedController *demaadnforHairVc = [[WQAddneedController alloc] init];;
        demaadnforHairVc.type = NeedControllerTypeNeeds;
        [self.navigationController pushViewController:demaadnforHairVc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.railView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.categoryView.mas_left).offset(_intager + self.categoryView.btnCGfloat * (scrollView.contentOffset.x / self.view.bounds.size.width));

    }];
    if (self.self.shopDetailView.contentOffset.x==30) {

        [self.shopDetailView setContentOffset:CGPointMake(30, self.shopDetailView.contentOffset.y)];

    }
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < kScreenWidth / 2.0 ) {
        //self.categoryView.shousuoBtn.hidden = NO;
        if (![self.rightBarButtons containsObject:self.searchBtn]) {
            //现实，实则add进来
            [self.rightBarButtons addObject:self.searchBtn];
            self.navigationItem.rightBarButtonItems = self.rightBarButtons;
        }
        //self.categoryView.mapBtn.hidden = NO;
        if (![self.barButtons containsObject:self.nearBtn]) {
            //现实，实则add进来
            [self.barButtons addObject:self.nearBtn];
            self.navigationItem.leftBarButtonItems = self.barButtons;
        }
    }else {
        //self.categoryView.mapBtn.hidden = YES;
        self.barButtons = [self.navigationItem.leftBarButtonItems mutableCopy];
        [self.barButtons removeObject:self.nearBtn];
        self.navigationItem.leftBarButtonItems = self.barButtons;
    }

    if (offsetX < kScreenWidth + kScreenWidth / 2 && offsetX > kScreenWidth / 2.0) {
        //self.categoryView.shousuoBtn.hidden = NO;
        if (![self.rightBarButtons containsObject:self.searchBtn]) {
            //现实，实则add进来
            [self.rightBarButtons addObject:self.searchBtn];
            self.navigationItem.rightBarButtonItems = self.rightBarButtons;
        }
        //self.categoryView.srbBtn.hidden = YES;
        self.rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
        [self.rightBarButtons removeObject:self.subscribeBtn];
        self.navigationItem.rightBarButtonItems = self.rightBarButtons;
    }

    if (offsetX > kScreenWidth + kScreenWidth / 2) {
        //self.categoryView.shousuoBtn.hidden = YES;
        self.rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
        [self.rightBarButtons removeObject:self.searchBtn];
        self.navigationItem.rightBarButtonItems = self.rightBarButtons;
        //self.categoryView.srbBtn.hidden = NO;
        if (![self.rightBarButtons containsObject:self.subscribeBtn]) {
            //现实，实则add进来
            [self.rightBarButtons addObject:self.subscribeBtn];
            self.navigationItem.rightBarButtonItems = self.rightBarButtons;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    scrollView.scrollEnabled = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        WQNearControllerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        // 附近的控制器
        WQHomeNewViewController *vc = [WQHomeNewViewController new];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.size.height);
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [cell.contentView addSubview:vc.view];
        return cell;
    }else if (indexPath.item == 1) {
        WQLatestControllerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifiertwo forIndexPath:indexPath];
        // 最新的控制器
        WQHomeNearbyViewController *vc = [WQHomeNearbyViewController new];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.size.height);
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [cell.contentView addSubview:vc.view];
        return cell;
    }else {
        WQSubscribeControllerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierthree forIndexPath:indexPath];
        // 订阅的控制器
        WQHomeSubscribeViewController *vc = [WQHomeSubscribeViewController new];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.size.height);
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [cell.contentView addSubview:vc.view];
        return cell;
    }
}


@end
