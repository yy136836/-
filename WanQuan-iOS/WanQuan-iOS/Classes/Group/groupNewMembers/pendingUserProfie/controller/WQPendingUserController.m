//
//  WQPendingUserController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPendingUserController.h"
#import "WQUserProfileTableHeaderView.h"
#import "WQUserProfileTableViewCell.h"
#import "WQGroupRequestInfoCell.h"


@interface WQPendingUserController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, retain) UIButton * bottomButton;
@property (nonatomic, retain) WQUserProfileModel *userModel;
@end

@implementation WQPendingUserController {
    NSMutableArray * _education;
    NSMutableArray * _work;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupUI];
}

- (void)setupUI {
    
    UITableView *tableview =  ({
        UITableView *v = [[UITableView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        [v registerNib:[UINib nibWithNibName:@"WQUserProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"WQUserProfileTableViewCell"];
        [v registerNib:[UINib nibWithNibName:@"WQGroupRequestInfoCell" bundle:nil] forCellReuseIdentifier:@"WQGroupRequestInfoCell"];
        //取消分割线
        
        //        v.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-65);
        }];
        v.tableFooterView = [UIView new];
        v.dataSource = self;
        v.delegate = self;
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [v setSeparatorColor:[UIColor colorWithHex:0xefefef]];
        v.allowsSelection = NO;
        v;
    });
    self.tableview = tableview;
    
    //头部试图
    
    _bottomButton = ({
        UIButton * btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth - 30));
            make.height.equalTo(@50);
            make.top.equalTo(_tableview.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(15);
        }];
        
        [btn setBackgroundColor:[UIColor colorWithHex:0x573084]];
        
        [btn addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn;
        
    });
    
    tableview.tableHeaderView = [[WQUserProfileTableHeaderView alloc] init];
    
    
    [self loadData];
}



#pragma mark - 请求数据
- (void)loadData {
    
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * params = @{}.mutableCopy;
    
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"uid"] = self.uid;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        _education = response[@"education"];
        _work = response[@"work_experience"];
        
        //        判断该页面的状态确定该页面的 UI

            
        [_bottomButton setTitle:@"通过验证" forState:UIControlStateNormal];
        
        _userModel = [WQUserProfileModel yy_modelWithJSON:response];
        ((WQUserProfileTableHeaderView *)(_tableview.tableHeaderView)).model = _userModel;
        _tableview.tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        
        if ([response[@"idcard_status"] isEqualToString:@"STATUS_UNVERIFY"]) {
            
            NSArray  *viewArray = [[NSBundle mainBundle]loadNibNamed:@"WQUserProfileTableFooterView" owner:nil options:nil];
            UIView *footer = [viewArray firstObject];
            //加载视图
            footer.frame = CGRectMake(0, 0, kScreenWidth, 60);
            _tableview.tableFooterView = footer;
        }
        
        //        (WQUserProfileTableHeaderView *)(_tableview.tableHeaderView))
        [_tableview reloadData];
    }];
}


#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section== 1) {
        return _userModel.work_experience.count;
    } else if ( section== 2) {
        return _userModel.education.count;
    } else {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQGroupRequestInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQGroupRequestInfoCell"];
        cell.requeustInfoLabel.text = self.requestInfo;
        return cell;
    }
    if (indexPath.section == 1) {
        WQUserProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileTableViewCell"];
        cell.profileMode = _userModel.work_experience[indexPath.row];
        cell.rightArrow.hidden = YES;
        return cell;
    }
    
    if (indexPath.section == 2) {
        WQUserProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileTableViewCell"];
        cell.userProfileModel = _userModel.education[indexPath.row];
        cell.rightArrow.hidden = YES;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 60;
    } else {
        return 132;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.1;
    }
    
    if(section == 1 || section == 2) {
        return 49;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    UIView * topGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    topGray.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [view addSubview:topGray];
    
    UIView * leftPurple = [[UIView alloc] initWithFrame:CGRectMake(15, 22, 3, 15)];
    leftPurple.backgroundColor = [UIColor colorWithHex:0x4b0b7f];
    [view addSubview:leftPurple];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, kScreenWidth, 38)];
    [view addSubview:textLabel];
    
    textLabel.textColor = [UIColor colorWithHex:0x333333];
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [view addSubview:bottomLine];
    
    
    view.backgroundColor = [UIColor whiteColor];
    
    
    if (section == 0) {
        return topGray;
    }
    
    if (section == 1) {
        textLabel.text = @"工作经历";
        return view;
    } else if (section == 2) {
        textLabel.text = @"学习经历";
        return view;
    }
    
    return [UIView new];
    
}


- (void)bottomButtonClicked:(UIButton *)sender {
    NSString *urlString = @"api/group/agreenewgroupmember";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"gid"] = self.gid;
    
    
    
    NSArray *uidArray = @[_uid];
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"uid"] = idcardStr;
    [SVProgressHUD showWithStatus:@"正在通过验证"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"验证不成功，请重试"];
            [SVProgressHUD dismissWithDelay:0.1];
            NSLog(@"%@",error);
            return ;
            
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        
        if ([response[@"success"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismissWithDelay:0.3];
        } else {
            [SVProgressHUD showWithStatus:@"验证不成功，请重试"];
            [SVProgressHUD dismissWithDelay:0.1];
        }
        
        NSLog(@"%@",response);
    }];
}
//- (void)agreeWithUserId:(NSString *)userid {
//    NSString *urlString = @"api/group/agreenewgroupmember";
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
//    params[@"gid"] = self.groupId;
//    NSArray *uidArray = @[userid];
//    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
//    params[@"uid"] = idcardStr;
//    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            return ;
//        }
//        if ([response isKindOfClass:[NSData class]]) {
//            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//        }
//        
//        NSLog(@"%@",response);
//        if ([response[@"success"] boolValue]) {
//            [self loadList];
//            if (self.operationIsSuccessfulBlock) {
//                self.operationIsSuccessfulBlock();
//            }
//        }
//    }];
//}



@end
