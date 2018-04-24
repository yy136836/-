//
//  WQMyOrderViewController.m
//
//  Created by  on.
//  Copyright © 2016年 All rights reserved.
//

#import "WQMyOrderViewController.h"
#import "WQOrderCollectionView.h"
#import "WQWaitOrderCollectionViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQWaitOrderoncModel.h"
#import "WQChaViewController.h"
#import "WQinprogressCollectionViewCell.h"
#import "WQCompletedCollectionViewCell.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQDataEmptyView.h"

static NSString *cellID = @"cellid";                //待接单
static NSString *celltwoid = @"celltwoid";          //进行中
static NSString *cellCompleted = @"cellCompleted";  //已完成

@interface WQMyOrderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSString *needsid;        //用户id
@property (nonatomic, weak) UICollectionView *ordorView;
@property (nonatomic, weak) UIView* catogoryView;
@property (nonatomic, weak) UIView* viewLine;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSArray* allBtns;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, strong) WQWaitOrderCollectionViewCell *cell;
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL haveToSelectDealWith;

@property (nonatomic, assign) BOOL selectedBIdDealWith;

// 进行中的红点
@property (nonatomic, assign) NSInteger redDotCount;




@end


@implementation WQMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateBidStatus];
    if (!_ordorView) {
        
        [self loadBtn];
    } else {
//
//    [self loadBtn];
        UICollectionViewCell * cellTmp = [_ordorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([cellTmp respondsToSelector:@selector(loadData)]) {
            [cellTmp performSelector:@selector(loadData)];
        }
        
        UICollectionViewCell * cellSelect = [_ordorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([cellSelect respondsToSelector:@selector(loadData)]) {
            [cellSelect performSelector:@selector(loadData)];
        }
    }
    
    self.navigationItem.title = @"我发的需求";
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


- (void)loadRedDot {
    NSString *urlString = @"api/message/reddot";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        self.redDotCount = [[NSString stringWithFormat:@"%@",response[@"my_created_need_bidded_count"]] integerValue];
        NSLog(@"%zd",self.redDotCount);
        if (self.redDotCount) {
            // 红点的view
            UIView *redView = [[UIView alloc] init];
            redView.backgroundColor = [UIColor redColor];
            redView.layer.cornerRadius = 4;
            redView.layer.masksToBounds = YES;
            [_GetingBtn addSubview:redView];
            [redView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(8, 8));
                make.top.equalTo(_GetingBtn).offset(5);
                make.right.equalTo(@(-kScreenWidth / 3 / 10));
            }];
        }
    }];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    // 代理置空，否则会崩
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    // 开启iOS7的滑动返回效果
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        // 只有在二级页面生效
//        if ([self.navigationController.viewControllers count] == 2) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
//    }
//}


- (void)updateBidStatus {
    
//    NSString * strURL = @"api/message/reddot";
//    
//    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//    if (!secreteKey.length) {
//        return;
//    }
//    NSDictionary * param = @{@"secretkey":secreteKey};
//    
//    WQNetworkTools *tools = [WQNetworkTools sharedTools];
//    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
//        if (error) {
//            return ;
//        }
//        
//        
//        if ([response isKindOfClass:[NSData class]]) {
//            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//        }
//        
////        my_created_need_bidding_count true number “我发布的需求”-待接单-红点数
////        my_created_need_finished_count true number “我发布的需求”-已完成-红点数
////        my_created_need_bidded_count true number
//        
//        self.haveToSelectDealWith = [response[@"my_created_need_bidding_count"] boolValue];
//        
//        self.selectedBIdDealWith = [response[@"my_created_need_bidded_count"] boolValue];
//        
////        if (self.haveToSelectDealWith) {
////            [_AwaitOrderBtn showDotBadge];
////        } else {
////            [_AwaitOrderBtn hideDotBadge];
////        }
////        
////        if (self.selectedBIdDealWith) {
////            [_GetingBtn showDotBadge];
////        } else {
////            [_GetingBtn hideDotBadge];
////        }
////         [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
//    }];
}


- (void)hideOrShowDotForBills:(NSArray *)billIds ofBidType:(BidType)type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSString * bidId in billIds) {
            
            if ([WQUnreadMessageCenter haveUnreadMessageForBid:bidId]||_haveToSelectDealWith||_selectedBIdDealWith) {
                
                if ((type == BidTypeToSelect||_haveToSelectDealWith) && (!_selectedBIdDealWith)) {
                    [_AwaitOrderBtn showDotBadge];
                    return;

                }
                if ((type == BidTypeSelected||_selectedBIdDealWith) && (!_haveToSelectDealWith)) {
                    [_GetingBtn showDotBadge];
                    return;

                }
            }
        }
        
        
        if (type == BidTypeToSelect && !self.haveToSelectDealWith) {
            [_AwaitOrderBtn hideDotBadge];
            return;

        }
        if (type == BidTypeSelected && !self.selectedBIdDealWith) {
            [_GetingBtn hideDotBadge];
            return;

        }
    });

    
    
}




#pragma mark - 初始化UI
- (void)loadBtn {
    //创建一个分类视图
    UIView *catogoryView = [[UIView alloc]init];
    catogoryView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    self.catogoryView = catogoryView;
    [self.view addSubview:catogoryView];
    //创建三个按钮
    _AwaitOrderBtn     = [[UIButton alloc]init];
    _GetingBtn         = [[UIButton alloc]init];
    _GettedBtn         = [[UIButton alloc]init];
    
    //设置按钮文字
    [_AwaitOrderBtn setTitle:@"待选定" forState:UIControlStateNormal];
    [_GetingBtn setTitle:@"进行中" forState:UIControlStateNormal];
    [_GettedBtn setTitle:@"已完成" forState:UIControlStateNormal];
    _AwaitOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _GetingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _GettedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_AwaitOrderBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [_GetingBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [_GettedBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    //添加按钮到一个数组中
    NSArray *allBtn = @[_AwaitOrderBtn,_GetingBtn,_GettedBtn];
    self.allBtns = allBtn;
    //通过数组存放按钮,设置相同属性
    for (int i = 0; i<allBtn.count; i++) {
        UIButton *btn = allBtn[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(ordorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.catogoryView addSubview:btn];
        [btn sizeToFit];
    }
    
    //滚动横条
//    UIView *bkLine = [[UIView alloc] init];
//    bkLine.backgroundColor = [UIColor colorWithHex:0x5d2a89];
//    [self.catogoryView addSubview:bkLine];
//    
//    bkLine.backgroundColor = [UIColor whiteColor];
//    [bkLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@22);
//        make.height.offset(4);
//        make.bottom.equalTo(catogoryView);
//        
//    }];
    
    UIView *viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = [UIColor colorWithHex:0x9767d0];
    viewLine.layer.masksToBounds = YES;
    viewLine.layer.cornerRadius = 2;
    [self.catogoryView addSubview:viewLine];
    self.viewLine = viewLine;
    //设置约束
    [catogoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(64);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.left.right.offset(0);
        make.height.offset(44);
    }];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
    }];
    
    for (int i = 0; i<allBtn.count - 1; i++) {
        UIButton *currentBtn = allBtn[i];
        UIButton *nextBtn = allBtn[i + 1];
        if (i == 0) {
            [currentBtn mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.offset(0);
                make.width.equalTo(@(kScreenWidth / 3));
            }];
        }
        
        if (i == allBtn.count - 2) {
            [nextBtn mas_makeConstraints:^(MASConstraintMaker* make) {
                make.right.offset(0);
            }];
        }
        
        [nextBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(currentBtn);
            make.left.equalTo(currentBtn.mas_right);
        }];
    }
    
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_AwaitOrderBtn);
        //make.width.offset(64);
        make.width.equalTo(@22);
        make.height.offset(4);
        make.bottom.equalTo(catogoryView);
    }];
    
    [self setupCollectionView];
    [self loadRedDot];
    
}

#pragma mark - 添加collectionVeiw
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *ordorView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    ordorView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.ordorView = ordorView;
    ordorView.pagingEnabled = YES;
    ordorView.bounces = NO;
    [ordorView registerClass:[WQWaitOrderCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [ordorView registerClass:[WQinprogressCollectionViewCell class] forCellWithReuseIdentifier:celltwoid];
    [ordorView registerClass:[WQCompletedCollectionViewCell class] forCellWithReuseIdentifier:cellCompleted];
    ordorView.delegate = self;
    ordorView.dataSource = self;
    
    [self.view addSubview:ordorView];
    [ordorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.catogoryView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    [ordorView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.ordorView.collectionViewLayout;
    layout.itemSize = CGSizeMake(_ordorView.size.width -1, _ordorView.size.height);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

- (void)ordorButtonClick:(UIButton *)button {
    
    [self.ordorView setContentOffset:CGPointMake(button.tag * self.ordorView.bounds.size.width, 0) animated:NO];
}

#pragma mark - 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        WQWaitOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell setPushxiangqingClikeBlock:^(NSString *needid) {
            WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:needid wqOrderType:WQOrderTypeSelected];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [cell setXiangqingWQDefaultTasksBlock:^(NSString *needid) {
            self.index = 0;
            WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:needid index:WQDefaultTasks];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }else if (indexPath.row == 1)
    {
        WQinprogressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:celltwoid forIndexPath:indexPath];
        [cell setInprogressPushxiangqingClikeBlock:^(NSString *needid) {
            self.index = 1;
            WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:needid wqOrderType:WQOrderTypeEnsure];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }else{
        WQCompletedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellCompleted forIndexPath:indexPath];
        [cell setCompletedPushxiangqingClikeBlock:^(NSString *needid) {
            self.index = 2;
            WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:needid wqOrderType:WQOrderTypeFinish];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
}


#pragma mark - scrollViewDelegate
#pragma mark - 点击按钮，下面横条滑动


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //   //获取offset
    
    if (!scrollView.size.height) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    UIButton *firstBtn = [self.allBtns firstObject];
    UIButton *lastBtn = [self.allBtns lastObject];
    //最大值与最小值之间的距离
    CGFloat dis = lastBtn.center.x - firstBtn.center.x;
    //获取这个范围的最大值和最小值
    CGFloat leftValue = -dis / 2;
    CGFloat rightValue = dis /2;
    YHValue resValue = YHValueMake(leftValue, rightValue);
    YHValue conValue = YHValueMake(0, (self.allBtns.count - 1) * self.ordorView.bounds.size.width );
    
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


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = scrollView.contentOffset.x / kScreenWidth;
    
    UICollectionViewCell * cellTmp = [_ordorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    if ([cellTmp respondsToSelector:@selector(loadData)]) {
        [cellTmp performSelector:@selector(loadData)];
    }
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}
- (NSMutableDictionary *)haunxinparams {
    if (!_haunxinparams) {
        _haunxinparams = [[NSMutableDictionary alloc]init];
    }
    return _haunxinparams;
}

@end
