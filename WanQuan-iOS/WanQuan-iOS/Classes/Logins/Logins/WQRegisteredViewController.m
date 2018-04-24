//
//  WQRegisteredViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRegisteredViewController.h"
#import "WQQuickRegistrationViewController.h"
#import "WQQuickRegistrationCollectionViewCell.h"
#import "WQRealNameRegistrationCollectionViewCell.h"
#import "WQlogonnRootViewController.h"

static NSString *cellid = @"cellid";
static NSString *realNameRegistrationCollectionViewCellid = @"WQRealNameRegistrationCollectionViewCell";

@interface WQRegisteredViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *scrollBarView;         // 滚动条
@property (nonatomic, strong) UIButton *quickRegistrationBtn;// 快速注册
@property (nonatomic, strong) UIButton *realNameRegistrationBtn;// 实名注册
@property (nonatomic, strong) UIView *quickRegistrationBtnBackgroundView; // 快速注册btn背景view
@property (nonatomic, strong) UIView *realNameRegistrationBtnBackgroundView; // 实名注册btn背景view

@end

@implementation WQRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    [self setupCollectionView];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"快速注册";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (!self.isLogin) {
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClike)];
    self.navigationItem.leftBarButtonItem = leftBarItem;

    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHex:0Xe4f1fd];
}

- (void)cancelClike {
    if (self.isLogin) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 初始化collectionview
- (void)setupCollectionView {
    // 快速注册btn背景view
    UIView *quickRegistrationBtnBackgroundView = [[UIView alloc] init];
    self.quickRegistrationBtnBackgroundView = quickRegistrationBtnBackgroundView;
    quickRegistrationBtnBackgroundView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.view addSubview:quickRegistrationBtnBackgroundView];
    [quickRegistrationBtnBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghCellHeight);
        make.left.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
    }];
    
    // 实名注册btn背景view
    UIView *realNameRegistrationBtnBackgroundView = [[UIView alloc] init];
    self.realNameRegistrationBtnBackgroundView = realNameRegistrationBtnBackgroundView;
    realNameRegistrationBtnBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:realNameRegistrationBtnBackgroundView];
    [realNameRegistrationBtnBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghCellHeight);
        make.right.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
    }];
    
    UIButton *quickRegistrationBtn = [[UIButton alloc] init];
    quickRegistrationBtn.tag = 0;
    self.quickRegistrationBtn = quickRegistrationBtn;
    quickRegistrationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [quickRegistrationBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [quickRegistrationBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [quickRegistrationBtn addTarget:self action:@selector(quickRegistrationBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickRegistrationBtn];
    
    UIButton *realNameRegistrationBtn = [[UIButton alloc] init];
    realNameRegistrationBtn.tag = 1;
    self.realNameRegistrationBtn = realNameRegistrationBtn;
    realNameRegistrationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [realNameRegistrationBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [realNameRegistrationBtn setTitle:@"实名注册" forState:UIControlStateNormal];
    [realNameRegistrationBtn addTarget:self action:@selector(quickRegistrationBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:realNameRegistrationBtn];
    
    NSArray *btnArrAy = @[quickRegistrationBtn,realNameRegistrationBtn];
    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [btnArrAy mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleY(85) leadSpacing:kScaleY(55) tailSpacing:kScaleY(55)];
    [btnArrAy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(quickRegistrationBtnBackgroundView.mas_centerY);
    }];
    
    // 滚动条
    UIView *scrollBarView = [[UIView alloc] init];
    self.scrollBarView = scrollBarView;
    scrollBarView.backgroundColor = [UIColor colorWithHex:0x5d2a89];
    [self.view addSubview:scrollBarView];
    [scrollBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(quickRegistrationBtn);
        //make.width.equalTo(quickRegistrationBtn.mas_width);
        make.top.equalTo(quickRegistrationBtn.mas_bottom).offset(-1);
        make.height.offset(2);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[WQQuickRegistrationCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    [collectionView registerClass:[WQRealNameRegistrationCollectionViewCell class] forCellWithReuseIdentifier:realNameRegistrationCollectionViewCellid];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(quickRegistrationBtn.mas_bottom).offset(15);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.collectionView.frame.size;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

// 快速注册||实名的注册的按钮响应事件
- (void)quickRegistrationBtnClike:(UIButton *)btn {
    [self.collectionView setContentOffset:CGPointMake(btn.tag * self.view.bounds.size.width, 0) animated:NO];
    [self.scrollBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.top.equalTo(btn.mas_bottom).offset(3);
        make.height.offset(2);
    }];
    // 快速注册时实名注册的背景为白色.快速注册为colorWithHex:0xededed
    if (btn == self.quickRegistrationBtn) {
        self.navigationItem.title = self.quickRegistrationBtn.titleLabel.text;
        [self.quickRegistrationBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
        [self.realNameRegistrationBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        self.quickRegistrationBtnBackgroundView.backgroundColor = [UIColor colorWithHex:0xededed];
        self.realNameRegistrationBtnBackgroundView.backgroundColor = [UIColor whiteColor];
    }else {
        self.navigationItem.title = self.realNameRegistrationBtn.titleLabel.text;
        [self.quickRegistrationBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [self.realNameRegistrationBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
        self.quickRegistrationBtnBackgroundView.backgroundColor = [UIColor whiteColor];
        self.realNameRegistrationBtnBackgroundView.backgroundColor = [UIColor colorWithHex:0xededed];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        WQQuickRegistrationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
        WQQuickRegistrationViewController *vc = [WQQuickRegistrationViewController new];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [cell addSubview:vc.view];
        return cell;
    }else {
        WQRealNameRegistrationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:realNameRegistrationCollectionViewCellid forIndexPath:indexPath];
        return cell;
    }
}

@end
