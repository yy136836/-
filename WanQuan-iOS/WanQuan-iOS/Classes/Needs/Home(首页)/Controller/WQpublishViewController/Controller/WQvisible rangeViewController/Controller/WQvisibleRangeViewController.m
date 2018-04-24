//
//  WQvisibleRangeViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQvisibleRangeViewController.h"
#import "WQvisibleRangecell.h"
#import "WQvisibleRangeModel.h"
#import "WQChaViewController.h"
#import "WQSpecifyTheFriendsContrlooer.h"
#import "WQdemaadnforHairViewController.h"

static NSString *cellId = @"cellid";

@interface WQvisibleRangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *mineOptionData;
@property (nonatomic, assign) NSIndexPath *index;
@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, strong) NSArray *userlist;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WQvisibleRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"公开对象";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
//    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarbtnClick)];
//    self.navigationItem.leftBarButtonItem = leftBarbtn;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    self.mineOptionData = [self loadMineOptionData];
    [self setupUI];
    [self loadFriends];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.tableView = nil;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    UITableView *tableview = [[UITableView alloc]init];
    self.tableView = tableview;
    [tableview registerNib:[UINib nibWithNibName:@"WQvisibleRangecell" bundle:nil] forCellReuseIdentifier:cellId];
    tableview.backgroundColor = [UIColor whiteColor];
    //tableview分割线
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    tableview.dataSource = self;
    tableview.delegate = self;
 
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(numberClick:)];
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
                                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}
#pragma mark - 完成的点击事件
- (void)numberClick:(UIBarButtonItem *)sender {
 
    __weak typeof(self) weakSelf = self;
    if (self.integer == 0) {
        if (self.finishBtnBlock) {
            weakSelf.finishBtnBlock(weakSelf.integer);
        }
    }
    if (self.integer == 1) {
        if (self.finishBtnClikeBlock) {
            weakSelf.finishBtnClikeBlock(weakSelf.userlist);
        }
    }
    if (self.integer == 2) {
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//解析数据
- (NSArray*)loadMineOptionData {
    return [NSArray objectListWithPlistName:@"WQvisibleRange.plist" clsName:@"WQvisibleRangeModel"];
}
#pragma mark - 获取环信好友列表
- (void)loadFriends {

//    EMError *error = nil;
//    self.userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
//    if (!error) {
//        NSLog(@"获取成功 -- %@",_userlist);
//    }
//    // 从数据库获取所有的好友
//    _userlist = [[EMClient sharedClient].contactManager getContactsFromDB];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在加载中,请稍候..."];
    
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"degree"] = @"1";
    NSMutableArray *mArray = [NSMutableArray array];
//    for (int i = 0 ; i < _userlist.count ; i++) {
//        _params[@"uid"] = _userlist[i];
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                
                [SVProgressHUD dismissWithDelay:0.5];
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            [self.modelArray removeAllObjects];
            for (NSDictionary * aSection in response[@"friends"]) {
                [self.modelArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[WQUserProfileModel class] json:aSection[@"friend_list"]]];
            }
            
            NSMutableArray * arr = @[].mutableCopy;
            for (WQUserProfileModel * model in _modelArray) {
                @autoreleasepool {
                    [arr addObject:model.user_id];
                }
            }
            self.userlist = arr.copy;
            [SVProgressHUD dismissWithDelay:0.5];
//            NSLog(@"%@",response);
//            [mArray addObject:model];
        }];
//    }
//    self.modelArray = mArray;
    
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQvisibleRangecell *lastTimecell = [tableView cellForRowAtIndexPath:self.index];
    lastTimecell.checkImage.hidden = YES;
    WQvisibleRangecell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkImage.hidden = NO;

    __weak typeof(self) weakSelf = self;
    self.index = indexPath;
    if (indexPath.row == 0) {
        self.integer = 0;
        if (self.didSelectBlock) {
            weakSelf.didSelectBlock(weakSelf.integer);
        }
    }else if (indexPath.row == 1) {
        self.integer = 1;
        [self loadFriends];

        if (self.didSelectBlock) {
            weakSelf.didSelectBlock(weakSelf.integer);
        }
    }else if (indexPath.row == 2) {
        self.integer = 2;
        WQSpecifyTheFriendsContrlooer *specifyTheFriendsVc = [[WQSpecifyTheFriendsContrlooer alloc] init];
        specifyTheFriendsVc.friendsArray = self.modelArray;
        [self.navigationController pushViewController:specifyTheFriendsVc animated:YES];
    }

    cell.quanquanImageView.hidden = !cell.checkImage.hidden;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mineOptionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQvisibleRangecell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQvisibleRangeModel *Model = self.mineOptionData[indexPath.row];
    cell.visibleRangemodel = Model;
    
    if (cell.checkImage.hidden) {
        cell.quanquanImageView.hidden = NO;
    }
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

@end
