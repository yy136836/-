//
//  WQFocusOnCollectViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFocusOnCollectViewController.h"
#import "WQiCareCollectionViewCell.h"
#import "WQFocusOnModel.h"
#import "WQPayAttentionToMeCollectionViewCell.h"

static NSString *identifier = @"identifier";
static NSString *celltwoid = @"celltwoid";

@interface WQFocusOnCollectViewController () <UICollectionViewDelegate,UICollectionViewDataSource>


/**
 底部视图
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 分类视图
 */
@property (nonatomic, strong) UIView *catogoryView;

/**
 btn数组
 */
@property (nonatomic, strong) NSArray *allBtns;

/**
 滚动条
 */
@property (nonatomic, strong) UIView *viewLine;

@end

@implementation WQFocusOnCollectViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"关注与收藏";
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)setUpView {
    // 分类视图
    UIView *catogoryView = [[UIView alloc]init];
    catogoryView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.catogoryView = catogoryView;
    [self.view addSubview:catogoryView];
    // 我关注的按钮
    UIButton *iCareBtn = [[UIButton alloc] init];
    // 关注我的按钮
    UIButton *payAttentionToMeBtn = [[UIButton alloc] init];
    // 收藏的按钮
    UIButton *collectBtn = [[UIButton alloc] init];
    
    [iCareBtn setTitle:@"我关注" forState:UIControlStateNormal];
    [payAttentionToMeBtn setTitle:@"关注我" forState:UIControlStateNormal];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [iCareBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    [payAttentionToMeBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    
    NSArray *allBtns = @[iCareBtn,payAttentionToMeBtn,collectBtn];
    self.allBtns = allBtns;
    //通过数组存放按钮,设置相同属性
    for (int i = 0; i < allBtns.count; i++) {
        UIButton *btn = allBtns[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(ordorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [catogoryView addSubview:btn];
        [btn sizeToFit];
    }
    
    //滚动横条
    UIView *viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = [UIColor colorWithHex:0x9767d0];
    viewLine.layer.masksToBounds = YES;
    viewLine.layer.cornerRadius = 2;
    [catogoryView addSubview:viewLine];
    self.viewLine = viewLine;
    //设置约束
    [catogoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.height.offset(44);
    }];
    [allBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
    }];
    for (int i = 0; i < allBtns.count - 1; i++) {
        UIButton *currentBtn = allBtns[i];
        UIButton *nextBtn = allBtns[i + 1];
        if (i == 0) { // 如果是第一个需要设置左边
            [currentBtn mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.offset(0);
            }];
        }
        if (i == allBtns.count - 2) { // 如果是最后一个需要设置右边
            [nextBtn mas_makeConstraints:^(MASConstraintMaker* make) {
                make.right.offset(0);
            }];
        }
        [nextBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            // 后一个和前一个等宽
            make.width.equalTo(currentBtn);
            // 后一个的左边 和 前一个的右边 一样
            make.left.equalTo(currentBtn.mas_right);
        }];
    }
    
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iCareBtn);
        make.width.equalTo(@22);
        make.height.offset(4);
        make.bottom.equalTo(catogoryView);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView = collectionView;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    [collectionView registerClass:[WQiCareCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [collectionView registerClass:[WQPayAttentionToMeCollectionViewCell class] forCellWithReuseIdentifier:celltwoid];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(catogoryView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.collectionView.size.width, self.collectionView.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

#pragma mark - 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        WQPayAttentionToMeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:celltwoid forIndexPath:indexPath];
        
        return cell;
    }
    
    WQiCareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.isMyFocusOn = YES;
        
    }
    
    if (indexPath.row == 1) {
        cell.isMyFocusOn = NO;
    }
    
    return cell;
}

#pragma mark - 点击按钮，下面横条滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //   //获取offset
    CGFloat offsetX = scrollView.contentOffset.x;
    UIButton *firstBtn = [self.allBtns firstObject];
    UIButton *lastBtn = [self.allBtns lastObject];
    //最大值与最小值之间的距离
    CGFloat dis = lastBtn.center.x - firstBtn.center.x;
    //获取这个范围的最大值和最小值
    CGFloat leftValue = -dis / 2;
    CGFloat rightValue = dis / 2;
    YHValue resValue = YHValueMake(leftValue, rightValue);
    YHValue conValue = YHValueMake(0, (self.allBtns.count - 1) * self.collectionView.bounds.size.width );
    
    CGFloat res = [NSObject resultWithConsult:offsetX andResultValue:resValue andConsultValue:conValue];
    
    [self.viewLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(res);
        make.width.offset(22);
        make.height.offset(4);
        make.bottom.equalTo(self.catogoryView);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.catogoryView layoutIfNeeded];
    }];
}

- (void)ordorButtonClick:(UIButton *)button {
    [self.collectionView setContentOffset:CGPointMake(button.tag * self.collectionView.bounds.size.width, 0) animated:NO];
}

@end
