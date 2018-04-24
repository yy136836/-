//
//  WQpublishViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import "WQpublishViewController.h"
#import "WQpublishTableViewCell.h"
#import "WQpublishTwoTableViewCell.h"
#import "WQpublishModel.h"
#import "WQvisibleRangeViewController.h"
#import "WQNeedsLabelViewController.h"
#import "WQdemaadnforHairViewController.h"
#import "WQHomeMapViewController.h"
#import "WQHomeNearbyViewController.h"
#import "WQNewestViewController.h"
#import "CuiPickerView.h"

static NSString *cellID = @"cellid";
static NSString *cellIDtwo = @"cellidTwo";

@interface WQpublishViewController ()<UITableViewDelegate,UITableViewDataSource,CuiPickViewDelegate>
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic, strong) WQdemaadnforHairViewController * demaadnforHairVc;
@property (nonatomic, strong) WQvisibleRangeViewController *visibleRangeVc;
@property (nonatomic, strong) WQpublishTwoTableViewCell *cell;
@property (nonatomic, strong) NSArray *mineOptionData;
@property (nonatomic, strong) NSMutableArray *labelTagData;                      //标签
@property (nonatomic, strong) NSMutableDictionary *params;                       //参数
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) UIDatePicker *datePicker1;
@property (nonatomic, strong) UIButton *currentTimeBtn;                          //时间选择器确定的按钮
@property (nonatomic, strong) NSString *formaString;                             //时间
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL whetheranonymous;                             //是否匿名
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSString *rewardString;                              //单人报酬
@property (nonatomic, copy) NSString *numberString;                              //期待完成人数
@property (nonatomic, copy) NSString *cidString;

@end

@implementation WQpublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0Xf0f0f3];
    self.mineOptionData = [self loadMineOptionData];
//    BOOL whetheranonymous;
//    _whetheranonymous = whetheranonymous;
    [WQDataSource sharedTool].mapSelectedCity = nil;
    self.demaadnforHairVc = [WQdemaadnforHairViewController new];
    self.formaString = [[NSString alloc]init];
    self.rewardString = [[NSString alloc]init];
    self.numberString = [[NSString alloc]init];
    [self setupUI];
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFriends:) name:WQselectedFriendsArray object:nil];
}



#pragma mark - 初始化UI
- (void)setupUI
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"发需求";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(numberClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UITableView *tableview = [[UITableView alloc]init];
    self.tableview = tableview;
    [tableview registerNib:[UINib nibWithNibName:@"WQpublishTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [tableview registerNib:[UINib nibWithNibName:@"WQpublishTwoTableViewCell" bundle:nil] forCellReuseIdentifier:cellIDtwo];
    tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableview];
    //tableview分割线
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];

    WQvisibleRangeViewController *visibleRangeVc = [WQvisibleRangeViewController new];
    self.visibleRangeVc = visibleRangeVc;
    __weak typeof(self) weakSelf = self;

    [visibleRangeVc setFinishBtnClikeBlock:^(NSArray *finishArray) {
        weakSelf.params[@"push_range"] = @"PUSH_RANGE_PART";
        weakSelf.params[@"range_value"] = [self arrayToString:finishArray];
        WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
        cell.callbackLabel.text = @"仅好友";
    }];
    [visibleRangeVc setFinishBtnBlock:^(NSInteger integer) {
        weakSelf.params[@"push_range"] = @"PUSH_RANGE_ALL";
        WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
        cell.callbackLabel.text = @"所有人";
    }];
    
}

- (void)selectedFriends:(NSNotification *)notification
{
    NSArray *selectedFriendsArray = [notification.userInfo objectForKey:@"selectedFriendsArray"];
    self.params[@"push_range"] = @"PUSH_RANGE_PART";
    self.params[@"range_value"] = [self arrayToString:selectedFriendsArray];
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    cell.callbackLabel.text = @"指定好友";
}

//把NSArray转为一个json字符串
- (NSString *)arrayToString:(NSArray *)array {
    
    NSString *str = @"['";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            str = [str stringByAppendingString:@"','"];
        }
        str = [str stringByAppendingString:array[i]];
    }
    str = [str stringByAppendingString:@"']"];
    
    return str;
}

#pragma mark - 点击事件
- (void)numberClick:(UIBarButtonItem *)sender
{
    //NSString* homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    // file路径
    //NSString* filePath = [homePath stringByAppendingPathComponent:@"_cellpropellingXml.data"];
    // 解档标签
    // self.labelTagData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [self.labelTagData addObject:@"哈哈"];
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:self.labelTagData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *labelTagString = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    
    int intStrig = [self.rewardString intValue];
    if (intStrig == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"建议输入金额大于0元" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    NSString *urlString = @"api/need/createneed";
    //用户密钥
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _params[@"subject"] = self.headlineTextField;
    _params[@"content"] = self.contentTextView;
    NSString *stringFloat = (_whetheranonymous==false)?@"true":@"false";
    _params[@"truename"] = stringFloat;
    _params[@"finished_date"] = self.formaString;
    _params[@"money"] = self.rewardString;
    _params[@"total_count"] =  self.numberString;
    _params[@"cid"] = self.cidString;
    _params[@"addr_geo_lat"] = _params[@"addr_geo_lat"] ?:@([WQDataSource sharedTool].location.latitude).description;
    _params[@"addr_geo_lng"] = _params[@"addr_geo_lng"] ?:@([WQDataSource sharedTool].location.longitude).description;
    
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:self.imageId options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    _params[@"pic"]  = self.imageId.count != 0 ? idcardStr : @"[\n\n]";
    NSString *mapArea = [WQDataSource sharedTool].mapSelectedCity;
    NSString *originalCity = [WQDataSource sharedTool].orignalCity;
    _params[@"addr"] = mapArea ? : originalCity;
    _params[@"tag"] = labelTagString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL successbool = [response[@"success"] boolValue];
        if (successbool) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"发布成功，请及时回复他人接单" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[WQNewestViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }

                });
            }];
        }else
        {
            NSString *str = [NSString stringWithFormat:@"%@",response[@"message"]];;
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

//解析数据
- (NSArray*)loadMineOptionData
{
    return [NSArray objectListWithPlistName:@"WQpublishViewControllerList.plist" clsName:@"WQpublishModel"];
}

#pragma mark - CuiPickViewDelegate
-(void)didFinishPickView:(NSString*)date
{
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.index];
    cell.callbackLabel.text = date;
    self.formaString = date;
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.indexPath = indexPath;
    self.index = indexPath;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7) {
        //发送通知取消键盘
        [[NSNotificationCenter defaultCenter] postNotificationName:WQresignFirstResponder object:self userInfo:nil];
    }
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:self.visibleRangeVc animated:YES];
        
    }else if (indexPath.row == 3)
    {
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        //这一步很重要
        _cuiPickerView.myTextField = nil;
        
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [self.view addSubview:_cuiPickerView];
        [_cuiPickerView showInView:self.view];
        
    }else if (indexPath.row== 7)
    {
        WQNeedsLabelViewController *vc = [WQNeedsLabelViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4)
    {
        /*WQManagesubscriptionsViewController *vc = [WQManagesubscriptionsViewController new];
        [vc setPopoBlock:^(NSString *cidString) {
            self.cidString = cidString;
            WQpublishTwoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.callbackLabel.text = @"已选";
        }];
        [self.navigationController pushViewController:vc animated:YES];*/
    }else if (indexPath.row == 5)
    {
    }else if (indexPath.row == 6)
    {
    }else if (indexPath.row == 1)
    {
        __weak typeof(self) weakSelf = self;
        WQHomeMapViewController *vc = [WQHomeMapViewController new];
        [vc setCoordinateBlock:^(CLLocationCoordinate2D locaiton) {
            weakSelf.params[@"addr_geo_lat"] = @(locaiton.latitude).description;
            weakSelf.params[@"addr_geo_lng"] = @(locaiton.longitude).description;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mineOptionData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WQpublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.boolwhetheranonymousBlock = ^(BOOL whetheranonymous)
        {
            _whetheranonymous = whetheranonymous;
        };
        return cell;
    }else{
        WQpublishTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDtwo forIndexPath:indexPath];
        self.cell = cell;
        WQpublishModel *wqmodel = self.mineOptionData[indexPath.row];
        cell.publishModel = wqmodel;
        if (indexPath.row == 1) {
            cell.callbackLabel.text = @"当前位置";
        }
        return cell;
    }
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)labelTagData
{
    if (!_labelTagData) {
        _labelTagData = [[NSMutableArray alloc] init];
    }
    return _labelTagData;
}

@end
