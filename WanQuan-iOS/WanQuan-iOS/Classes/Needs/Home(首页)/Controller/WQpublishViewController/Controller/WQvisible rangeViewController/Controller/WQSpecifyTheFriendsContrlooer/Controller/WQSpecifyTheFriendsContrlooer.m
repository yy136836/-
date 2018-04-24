//
//  WQSpecifyTheFriendsContrlooer.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSpecifyTheFriendsContrlooer.h"
#import "WQSpecifyTheFriendsTableViewCell.h"
#import "WQpublishViewController.h"
#import "WQdemaadnforHairViewController.h"
#import "WQfriend_listModel.h"

static NSString *cellid = @"cellid";

@interface WQSpecifyTheFriendsContrlooer ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *selectedFriendsArray;

@property (nonatomic, assign) NSInteger index;

@end

@implementation WQSpecifyTheFriendsContrlooer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"指定好友";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClike)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化
- (void)setupView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[WQSpecifyTheFriendsTableViewCell class] forCellReuseIdentifier:cellid];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
}

#pragma mark - 监听事件
- (void)completeBtnClike {
    NSDictionary *dict = @{@"selectedFriendsArray" : self.selectedFriendsArray};
    [[NSNotificationCenter defaultCenter] postNotificationName:WQselectedFriendsArray object:self userInfo:dict];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[WQdemaadnforHairViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQSpecifyTheFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.duihaoImageView.hidden == YES) {
        cell.duihaoImageView.hidden = !cell.duihaoImageView.hidden;
        [self.selectedFriendsArray addObject:cell.model.user_id];
    }else {
        cell.duihaoImageView.hidden = !cell.duihaoImageView.hidden;
        [self.selectedFriendsArray removeObject:cell.model.user_id];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQSpecifyTheFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];

    cell.model = self.friendsArray[indexPath.row];
    BOOL selected = NO;
    
    for (NSString * id in self.selectedFriendsArray) {
        if ([id isEqualToString:cell.model.user_id]) {
            selected = YES;
            break;
        }
    }
    
    cell.duihaoImageView.hidden = !selected;
    cell.quanImageView.hidden = !cell.duihaoImageView.hidden;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 懒加载
- (NSArray *)friendsArray {
    if (!_friendsArray) {
        _friendsArray = [[NSArray alloc] init];
    }
    return _friendsArray;
}
- (NSMutableArray *)selectedFriendsArray {
    if (!_selectedFriendsArray) {
        _selectedFriendsArray = [[NSMutableArray alloc] init];
    }
    return _selectedFriendsArray;
}

@end
