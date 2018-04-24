//
//  WQMyReceivinganOrderViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMyReceivinganOrderViewController.h"
#import "WQReceivinganOrdercollectionCell.h"
#import "WQReceivinganOrderView.h"
#import "WQbiddingCollectionViewCell.h"
#import "WQloseAbidCollectionViewCell.h"
#import "WQChaViewController.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQevaluateViewController.h"
#import "WQorderViewController.h"
#import "WQPrefixHeader.pch"

//待开标
static NSString *cellID = @"cellid";
//中标
static NSString *celltwoid = @"WQbiddingCollectionViewCell";
//未中标
static NSString *cellWQloseAbidCollectionViewCellid = @"WQloseAbidCollectionViewCell";

@interface WQMyReceivinganOrderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView * ordorView;
@property (nonatomic, weak) UIView* catogoryView;
@property (nonatomic, weak) UIView* viewLine;
@property (nonatomic, strong) NSArray* allBtns;
@property (nonatomic, strong) UIButton* btn;;

@property (nonatomic, assign) BOOL haveToSelectDealWith;

@property (nonatomic, assign) BOOL selectedBIdDealWith;



@end

@implementation WQMyReceivinganOrderViewController

#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    // Do any additional setup after loading the view.

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_ordorView) {
        
        [self loadBtn];
    } else {
        
        UICollectionViewCell * cellTmp = [_ordorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([cellTmp respondsToSelector:@selector(loadData)]) {
            [cellTmp performSelector:@selector(loadData)];
        }
        
        UICollectionViewCell * cellSelect = [_ordorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([cellSelect respondsToSelector:@selector(loadData)]) {
            [cellSelect performSelector:@selector(loadData)];
        }
    }
    [self updateBidStatus];

    self.navigationItem.title = @"我接的需求";
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector()];
//    self.navigationItem.leftBarButtonItem = leftBarbtn;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBidStatus {
    NSString * strURL = @"api/message/reddot";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
//        my_bidded_need_bidded_finished_count true number “我抢单的需求”-已完成-红点数
//        my_bidded_need_bidding_count true number “我抢单的需求”-已抢单-红点数
//        my_bidded_need_bidded_doing_count tru
        
        self.haveToSelectDealWith = [response[@"my_bidded_need_bidding_count"] boolValue];
        
        self.selectedBIdDealWith = [response[@"my_bidded_need_bidded_doing_count"] boolValue];
        
//        if (self.haveToSelectDealWith) {
//            [_AwaitOrderBtn showDotBadge];
//        } else {
//            [_AwaitOrderBtn hideDotBadge];
//        }
//        
//        if (self.selectedBIdDealWith) {
//            [_GetingBtn showDotBadge];
//        } else {
//            [_GetingBtn hideDotBadge];
//        }
         [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
    }];
}



- (void)hideOrShowDotForBills:(NSArray *)billIds ofBidType:(BidType)type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSString * bidId in billIds) {
            
            if ([WQUnreadMessageCenter haveUnreadMessageForBid:bidId]||self.haveToSelectDealWith|| self.selectedBIdDealWith) {
                
                 if ((type == BidTypeToSelect||_haveToSelectDealWith) && (!_selectedBIdDealWith)) {
                    [_AwaitOrderBtn showDotBadge];
                    return ;
                }
                if ((type == BidTypeSelected||_selectedBIdDealWith) && (!_haveToSelectDealWith)) {
                    [_GetingBtn showDotBadge];
                    return;
                }
                
            }
        }
        
        if (type == BidTypeToSelect &&!self.haveToSelectDealWith) {
            [_AwaitOrderBtn hideDotBadge];
            return;
        }
        if (type == BidTypeSelected && !self.selectedBIdDealWith) {
            [_GetingBtn hideDotBadge];
            return;
        }
    });
}


- (void)loadBtn {
    //创建一个分类视图
    UIView *catogoryView = [[UIView alloc]init];
    catogoryView.backgroundColor = [UIColor blackColor];
    self.catogoryView = catogoryView;
    [self.view addSubview:catogoryView];
    //创建三个按钮
    _AwaitOrderBtn     = [[UIButton alloc]init];
    _GetingBtn         = [[UIButton alloc]init];
    _GettedBtn         = [[UIButton alloc]init];
    //设置按钮文字
    
    [_AwaitOrderBtn setTitle:@"已抢单" forState:UIControlStateNormal];
    [_GetingBtn setTitle:@"进行中" forState:UIControlStateNormal];
    [_GettedBtn setTitle:@"已结束" forState:UIControlStateNormal];
    
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
        [self.catogoryView addSubview:btn];
        [btn sizeToFit];
    }
    
    //滚动横条
    UIView *viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = [UIColor colorWithHex:0x9767d0];
    viewLine.layer.masksToBounds = YES;
    viewLine.layer.cornerRadius = 2;
    [self.catogoryView addSubview:viewLine];
    self.viewLine = viewLine;
    //设置约束
    [catogoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.height.offset(44);
    }];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        
    }];
    for (int i = 0; i<allBtn.count - 1; i++) {
        UIButton *currentBtn = allBtn[i];
        UIButton *nextBtn = allBtn[i + 1];
        if (i == 0) { // 如果是第一个需要设置左边
            [currentBtn mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.offset(0);
            }];
        }
        
        if (i == allBtn.count - 2) { // 如果是最后一个需要设置右边
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
        make.centerX.equalTo(_AwaitOrderBtn);
        make.width.equalTo(@22);
        make.height.offset(4);
        make.bottom.equalTo(catogoryView);
    }];
    
    
//    UIView *segmentationLineView = [[UIView alloc] init];
//    segmentationLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//    UIView *segmentationTwoLineView = [[UIView alloc] init];
//    segmentationTwoLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//    
//    [self.view addSubview:segmentationLineView];
//    [self.view addSubview:segmentationTwoLineView];
//    
//    NSArray *segmentationLineArray = @[segmentationLineView,segmentationTwoLineView];
//    //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
//    [segmentationLineArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(125) leadSpacing:kScaleX(123) tailSpacing:kScaleX(123)
//     ];
//    [segmentationLineArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_AwaitOrderBtn.mas_centerY);
//        make.width.offset(1);
//        make.height.offset(16);
//    }];
    
    [self setupCollectionView];
}

#pragma mark - 添加collectionVeiw
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *ordorView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.ordorView = ordorView;
    ordorView.pagingEnabled = YES;
    ordorView.bounces = NO;
    [ordorView registerClass:[WQReceivinganOrdercollectionCell class] forCellWithReuseIdentifier:cellID];
    [ordorView registerClass:[WQbiddingCollectionViewCell class] forCellWithReuseIdentifier:celltwoid];
    [ordorView registerClass:[WQloseAbidCollectionViewCell class] forCellWithReuseIdentifier:cellWQloseAbidCollectionViewCellid];
    ordorView.delegate = self;
    ordorView.dataSource = self;
    
    [self.view addSubview:ordorView];
    [ordorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.catogoryView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
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
        WQReceivinganOrdercollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell setPushxiangqingClikeBlock:^(NSString *huanxinId, NSString *nid, NSString *needOwnerId, NSString *fromName, NSString *fromPic, NSString *toName, NSString *toPic, BOOL isBidding, BOOL isTrueName, BOOL isBidTureName) {
            //环信单聊
            WQChaViewController *chatController = [[WQChaViewController alloc] initWithConversationChatter:huanxinId conversationType:EMConversationTypeChat needId:nid needOwnerId:needOwnerId fromName:fromName fromPic:fromPic toName:toName toPic:toPic isFromTemp:NO isTrueName:isTrueName isBidTureName:isBidTureName];
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
        return cell;
    }else if (indexPath.row == 1){
        WQbiddingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:celltwoid forIndexPath:indexPath];
        [cell setBiddingpushxiangqingBlock:^(NSString *huanxinId, NSString *nid, NSString *needOwnerId, NSString *userName, NSString *userPic, NSString *toName, NSString *toPic, BOOL isBidding, BOOL isTrueName, BOOL isBidTureName) {
            //环信单聊
            //TODO linhuijie：这里需要设置匿名状态以及需求id
            WQChaViewController *chatController = [[WQChaViewController alloc]initWithConversationChatter:huanxinId conversationType:EMConversationTypeChat needId:nid needOwnerId:needOwnerId fromName:userName fromPic:userPic toName:toName toPic:toPic isFromTemp:NO isTrueName:isTrueName isBidTureName:isBidTureName];
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
        return cell;
    }else{
        WQloseAbidCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellWQloseAbidCollectionViewCellid forIndexPath:indexPath];
        [cell setEvaluateBtnBlock:^(NSString *needid) {
            WQevaluateViewController *vc = [[WQevaluateViewController alloc]initWithneedId:needid];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
        return cell;
    }
    
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
    CGFloat rightValue = dis /2;
    YHValue resValue = YHValueMake(leftValue, rightValue);
    YHValue conValue = YHValueMake(0, (self.allBtns.count - 1) * self.ordorView.bounds.size.width );
    
    CGFloat res = [NSObject resultWithConsult:offsetX andResultValue:resValue andConsultValue:conValue];
    
    [ self.viewLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(res);
        make.width.offset(22);
        make.height.offset(4);
        make.bottom.equalTo(self.catogoryView);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.catogoryView layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
