//
//  WQGroupMembersController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupMembersController.h"
#import "WQGroupMemberButton.h"
#import "WQGroupMemberModel.h"
#import "WQUserProfileController.h"
#import "WQAddMembersController.h"
#import "WQGroupMemberCell.h"
#import "WQUserProfileContrlooer.h"

NSString * WQGroupMemberCellIdenty = @"WQGroupMemberCell";

@interface WQGroupMembersController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//@property (nonatomic, retain)UIScrollView * main;

@property (nonatomic, retain)NSMutableArray * memberArray;

///**
// true string 当前用户是否为该群的群主
// */
//@property (nonatomic, copy)NSString * isOwner;

/**
 true string 群内成员总数
 */
@property (nonatomic, copy)NSString * member_count;

/**
 是否是群主
 */
@property (nonatomic, assign) BOOL groupOwner;

@property (nonatomic, retain) UIView * bg;

@property (nonatomic, retain) UICollectionView * collecitonView;

@end

@implementation WQGroupMembersController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}


#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    UILabel * title = [UILabel labelWithText:@"圈成员" andTextColor:[UIColor blackColor] andFontSize:20];
//    [title sizeToFit];
//    self.navigationItem.titleView = title;


    _memberArray = @[].mutableCopy;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    [self fetchMemberInfo];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
//    WQUserProfileContrlooer * vc;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)fetchMemberInfo {
    NSString *urlString = @"api/group/groupmemberlist";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params = @{}.mutableCopy;

    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"gid"] = self.gid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
            [loadingError show];
            return ;
        }

        
        if (![response[@"success"] boolValue]) {
            [WQAlert showAlertWithTitle:nil message:response[@"message"]?:@"请检查网络连接" duration:1.2];
        }
        
        [_memberArray removeAllObjects];
        
        
        
//        isOwner true string 当前用户是否为该群的群主
//        member_count true string 群内成员总数
//        members true array[object]
//        user_name true string 成员姓名
//        user_pic true string 成员头像
//        user_id true string 成员用户ID
//        user_idcard_status true string 成员用户idcard_status
        
        
        
        [_memberArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQGroupMemberModel class] json:response[@"members"]]];
        
        // self.groupOwner = [response[@"isOwner"] boolValue];
        if ([response[@"isOwner"] boolValue] || [response[@"isAdmin"] boolValue]) {
            self.groupOwner = YES;
        }else {
            self.groupOwner = NO;
        }
        
        NSString * memberCount = response[@"member_count"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)",@"圈成员",memberCount] ;

        [self.navigationController.navigationBar  setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                   NSForegroundColorAttributeName:[UIColor blackColor]}];
        [_collecitonView reloadData];
        [loadingView dismiss];
        [loadingError dismiss];
        NSLog(@"%@",response);
    }];

}


- (void)setupUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kScreenWidth  / 5, 100);
    
//    CGFloat space = (kScreenWidth - 20 - 60 * 5) / 6;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collecitonView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:_collecitonView];
    [_collecitonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _collecitonView.backgroundColor = [UIColor whiteColor];
    
    _collecitonView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);

    _collecitonView.delegate = self;
    _collecitonView.dataSource = self;
    [_collecitonView registerNib:[UINib nibWithNibName:@"WQGroupMemberCell" bundle:nil] forCellWithReuseIdentifier:WQGroupMemberCellIdenty];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf fetchMemberInfo];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - collectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupMemberCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WQGroupMemberCellIdenty forIndexPath:indexPath];
    
    if (_groupOwner) {
        if (indexPath.row > 1) {
            cell.model = _memberArray[indexPath.row - 2];
        }
        
        if (indexPath.row == 0) {
            [cell.avatar setImage:[UIImage imageNamed:@"tianjiachengyuan"]];
            cell.userNameLabel.text = @"";
        }
        
        if (indexPath.row == 1) {
            [cell.avatar setImage:[UIImage imageNamed:@"shanchuchengyuan"]];
            cell.userNameLabel.text = @"";
        }
    } else {
        cell.model = _memberArray[indexPath.row];
    }
   
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_groupOwner) {
        return _memberArray.count + 2;
    }
    return _memberArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_groupOwner) {
        if (indexPath.row ==  0) {
            [self addMember];
        }
        if (indexPath.row == 1) {
            [self deleteMember];
        }
        if (indexPath.row > 1) {
            WQGroupMemberModel *model = _memberArray[indexPath.row - 2];
            
            if (model.user_virtual) {
                
                [WQAlert showAlertWithTitle:nil
                                    message:[NSString stringWithFormat:@"%@正在赶来的路上",model.user_name]
                                   duration:1.3];
                return;
            }
            
            WQUserProfileController * vc =  [[WQUserProfileController alloc] initWithUserId:model.user_id];
            [self.navigationController pushViewController:vc animated:YES];
        }

    } else {
        WQGroupMemberModel *model = _memberArray[indexPath.row];
        WQUserProfileController * vc =  [[WQUserProfileController alloc] initWithUserId:model.user_id];
        
        if (model.user_virtual) {
            
            [WQAlert showAlertWithTitle:nil
                                message:[NSString stringWithFormat:@"%@正在赶来的路上",model.user_name]
                               duration:1.3];
            return;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

}



- (void)addMember {
    WQAddMembersController * vc = [[WQAddMembersController alloc] init];
    vc.gid = self.gid;
    vc.deleteType = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteMember {
    WQAddMembersController * vc = [[WQAddMembersController alloc] init];
    vc.currentMembes = self.memberArray;
    vc.deleteType = YES;
    vc.gid = self.gid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
