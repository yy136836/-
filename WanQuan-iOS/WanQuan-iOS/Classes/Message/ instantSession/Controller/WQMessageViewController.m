//
//  WQMessageViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMessageViewController.h"
#import "WQNewsHomeModel.h"
#import "UMSocialUIManager.h"
#import "WQPushMessageTableViewCell.h"
#import "WQmessageHomeModel.h"
#import "ChatHelper.h"
#import "WQmessageHomeTopView.h"

#import "WQsystemMessageCollectionViewCell.h"
#import "WQGroupsCollectionViewCell.h"
#import "WQsessionCollectionViewCell.h"
#import "WQslidingView.h"
#import "WQGroupController.h"
#import "WQGroupInformationViewController.h"

static NSString *cellID = @"cellid";
static NSString *cellTwoId = @"cellTwoId";

@interface WQMessageViewController()<EaseConversationListViewControllerDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger messageCount;
//@property (nonatomic, strong) WQmessageHomeTopView *topView;
@property (nonatomic, strong) WQslidingView *slidingView;
@property (nonatomic, retain) WQGroupController * group;
@end

@implementation WQMessageViewController {
    NSUserDefaults *userDefaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //初始化游客登录UI
        [self setupTouristUI];
    }else{
        [self setupUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    /*[self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"消息";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];*/
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUnreadMessageCount];
    
    if (_group) {
        [_group loadGroupList];
    }
    
    // popo回来之后会有问题,所有popo回来之后显示上次离开的btn
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if (![role_id isEqualToString:@"200"]) {
        NSString *btnTag = [userDefaults objectForKey:@"topViewRightBtnTag"];
        if ([btnTag integerValue] == 1) {
            self.topView.rightBtn.tag = 1;
            self.topView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.topView.rightBtn setTitle:@"新建圈" forState:UIControlStateNormal];
            [self.topView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.topView.rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else {
            self.topView.rightBtn.tag = 2;
            [self.topView.rightBtn setImage:[UIImage imageNamed:@"tongxunlu"] forState:UIControlStateNormal];
            [self.topView.rightBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    WQTabBarController * main = (WQTabBarController * )[UIApplication sharedApplication].delegate.window.rootViewController;
    
    if (![main isKindOfClass:[WQTabBarController class]]) {
        return;
    }

    [main setupUnreadMessageCount:nil];
    
    // 界面消失的时候记录btn的tag,默认储存的topViewRightBtnTag在最新首页,默认为1
    [userDefaults setObject:@(self.topView.rightBtn.tag).description forKey:@"topViewRightBtnTag"];
}


-(void)clickAtMessage {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.5 animations:^{
//            [_collectionView setContentOffset:CGPointMake(kScreenWidth, 0)];
//            
//        }];
//    });
}
#pragma mark - 初始化UI
- (void)setupTouristUI {
    
    
    _topView = ({
        
        UIImageView * imageView = [[UIImageView alloc] init];
        
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@64);
            
        }];
        
        UILabel * title = [UILabel labelWithText:@"消息" andTextColor:[UIColor whiteColor] andFontSize:18];
        
        [imageView addSubview:title];
        [title sizeToFit];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(1));
            make.centerY.equalTo(@(1)).offset(10);
        }];
        
        imageView.image = [UIImage imageNamed:@"dingbulan"];
        imageView;
    });
    
//    __weak typeof(self) weakself = self;
//    [_topView setSystemMessageBtnClikeBlock:^(NSInteger index) {
//        [weakself.collectionView setContentOffset:CGPointMake(index * self.view.bounds.size.width, 0) animated:NO];
//    }];
//    self.topView = _topView;
//    [self.view addSubview:_topView];
//    
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.equalTo(self.view);
//        make.height.offset(ghNavigationBarHeight);
//    }];
//    
//    for (UIButton * btn in _topView.subviews) {
//        if (![btn isKindOfClass:[UIImageView class]]) {
//            [btn  removeFromSuperview];
//        }
//    }
    
    WQTouristView *touristView = [[WQTouristView alloc]init];
    
    [self.view addSubview:touristView];
    
    [touristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(kScreenHeight - 64));
        make.top.equalTo(_topView.mas_bottom);
    }];
}

- (void)setupUI {
    _topView = [[WQmessageHomeTopView alloc] init];
    
    __weak typeof(self) weakself = self;
    [_topView setSystemMessageBtnClikeBlock:^(NSInteger index) {
        [weakself.collectionView setContentOffset:CGPointMake(index * self.view.bounds.size.width, 0) animated:NO];
    }];
    self.topView = _topView;
    [self.view addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.offset(ghNavigationBarHeight);
    }];
    

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[WQGroupsCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [collectionView registerClass:[WQsessionCollectionViewCell class] forCellWithReuseIdentifier:cellTwoId];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-49);
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

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if(conversation.ext){
            if([conversation.ext objectForKey:@"isfriend"]){
                unreadCount += conversation.unreadMessagesCount;
            }
        }
    }
    //self.messageCount = unreadCount;
    //[self.tableView reloadData];
    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.topView reloadSlodingViewLocation:scrollView.contentOffset.x];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WQGroupsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        
        
        WQGroupController * vc = [[WQGroupController alloc] init];
        [self addChildViewController:vc];
        self.group = vc;
        [vc didMoveToParentViewController:self];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
        [cell.contentView addSubview:vc.view];
        vc.view.backgroundColor = [UIColor cyanColor];
        //self.topView.rightBtn.hidden = YES;
        return cell;
    }else{
        //self.topView.rightBtn.hidden = NO;
        WQsessionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellTwoId forIndexPath:indexPath];
        EaseConversationListViewController *vc = [EaseConversationListViewController new];
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        vc.dataSource = self;
        [cell.contentView addSubview:vc.view];
        
        return cell;
    }
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
@end
