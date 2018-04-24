//
//  WQCircleApplyListController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCircleApplyListController.h"
#import "WQCircleListCell.h"
#import "WQCircleApplyModel.h"
#import "WQGroupDynamicViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface WQCircleApplyListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, retain) UITableView * maintable;
@property (nonatomic, retain) NSMutableArray * requestListArray;

@end

NSString * WQCircleListCellIdenty = @"1";

@implementation WQCircleApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;


    _requestListArray = @[].mutableCopy;
    self.navigationItem.title = @"入圈申请";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;


    [super viewWillAppear:animated];
    [self loadApplyList];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                                                      [UIColor blackColor]}];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)setupUI {
    
    _maintable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT)];
    [self.view addSubview:_maintable];
    _maintable.delegate = self;
    _maintable.dataSource = self;
    _maintable.tableFooterView = [UIView new];
    _maintable.tableHeaderView = [UIView new];
    _maintable.rowHeight = UITableViewAutomaticDimension;
    _maintable.estimatedRowHeight = 93;
    _maintable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UINib * nib = [UINib nibWithNibName:@"WQCircleListCell" bundle:nil];
    
    [_maintable registerNib:nib forCellReuseIdentifier:@"WQCircleListCell"];
    _maintable.emptyDataSetDelegate = self;
    _maintable.emptyDataSetSource =self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _requestListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQCircleListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQCircleListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    __weak typeof(self) weakself = self;
    
    WQCircleApplyModel * model = _requestListArray[indexPath.row];
    
    cell.model = model;
    
    typeof(cell) weakcell = cell;
    cell.agreeOnclick = ^(UIButton *sender) {
        
        if (sender.enabled == NO) {
            return ;
        }
        
        
        NSString * strURL = @"api/group/agreenewgroupmember";
        
        NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
        if (!secreteKey.length) {
            return;
        }
        [SVProgressHUD show];
        //    gid true string 群ID
        //    uid true string jsonarray格式，每个元素为用户的32位ID
        NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
        param[@"gid"] = model.group_id;
        
        NSArray *uidArray = @[model.user_id];
        NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
        param[@"uid"] = idcardStr;
        
//        param[@"uid"] = model.user_id;
        
        WQNetworkTools *tools = [WQNetworkTools sharedTools];
        [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [WQAlert showAlertWithTitle:nil message:@"添加失败,请重试" duration:1.3];
                return ;
            }
            
            if (![response[@"success"] boolValue]) {
                [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
                return;
            }
            [WQAlert showAlertWithTitle:nil message:@"添加成功" duration:1.3];
            [[WQNetworkTools  sharedTools] fetchRedDot];

            weakcell.agreeButton.enabled = NO;
        }];
    };
    cell.circleNameOnclick = ^{
        __strong typeof(weakself) strongself = weakself;
        WQGroupDynamicViewController * vc = [[WQGroupDynamicViewController alloc] init];
        vc.gid = model.group_id;
        [strongself.navigationController pushViewController:vc animated:YES];
    };
    
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WQCircleApplyModel * model = _requestListArray[indexPath.row];
    NSString * strURL = @"api/group/removenewgroupmember";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    //    gid true string 群ID
    //    uid true string jsonarray格式，每个元素为用户的32位ID
    param[@"gid"] = model.group_id;
    NSArray *uidArray = @[model.user_id];
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:uidArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    param[@"uid"] = idcardStr;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [WQAlert showAlertWithTitle:nil message:@"删除失败,请重试" duration:1.3];
            return ;
        }
        
        if (![response[@"success"] boolValue]) {
            [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];

            return;
        }
        
        [_requestListArray removeObjectAtIndex:indexPath.row];
        [[WQNetworkTools  sharedTools] fetchRedDot];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    
    
}



- (void)loadApplyList {
    NSString * strURL = @"api/group/groupnewmemberlist";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        _requestListArray = [NSArray yy_modelArrayWithClass:[WQCircleApplyModel class] json:response[@"fresh_members"]].mutableCopy;
        [_maintable reloadData];
    }];

}





- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}





//- (void)agree:(WQCircleApplyModel *)model {
//    NSString * strURL = @"api/message/agreenewgroupmember";
//    
//    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//    if (!secreteKey.length) {
//        return;
//    }
//    
////    gid true string 群ID
////    uid true string jsonarray格式，每个元素为用户的32位ID
//    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
//    
//    
//    WQNetworkTools *tools = [WQNetworkTools sharedTools];
//    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
//        if (error) {
//            return ;
//        }
//    }];
//
//}
#pragma DZNEmpty
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    return [UIImage imageNamed:@"wuxiaoxi"];
    
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * noResult = @"\n没有新的入圈申请";
    
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:noResult attributes:att]];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    
    return str;
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}


@end
