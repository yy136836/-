//
//  WQdemaadnforHairViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/3.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>

#import "WQdemaadnforHairViewController.h"
#import "WQHomeNearbyViewController.h"
#import "WQdemaadnforHairview.h"
#import "WQpublishViewController.h"
#import "WQpublishTableViewCell.h"
#import "WQpublishTwoTableViewCell.h"
#import "CuiPickerView.h"
#import "WQvisibleRangeViewController.h"
#import "WQNeedsLabelViewController.h"
#import "WQpublishTwoTableViewCell.h"
#import "WQHomeMapViewController.h"
#import "WQNewestViewController.h"
#import "WQpopupWindowView.h"
#import "WQsubscribeToTableViewCell.h"
#import "WQIsGroupTableViewCell.h"
#import "WQGroupDynamicViewController.h"
#import "WQtopUpPopupWindowView.h"
#import "WQToChooseTimeView.h"
#import "WQWorkExperiencePopupWindowView.h"
#import "WQaddWorkViewController.h"
#import "WQPickerView.h"

#define gHframeHWXY 0

static NSString *twoCellid = @"twoCellid";
static NSString *oncCellid = @"oncCellid";
static NSString *subscribeToCellid = @"subscribeTo";
static NSString *wqIsGroupTableViewCellid = @"WQIsGroupTableViewCell";

@interface WQdemaadnforHairViewController ()<CuiPickViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WQpopupWindowViewDelegate,WQDatePickerDelegate>

@property (nonatomic, strong) WQdemaadnforHairview *demaadnforHairview;
@property (nonatomic, strong) WQpublishViewController *publishVc;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic, strong) WQvisibleRangeViewController *visibleRangeVc;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIPickerView *citPickerView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) WQpopupWindowView *popupWindowView;
@property (nonatomic, strong) NSMutableArray *certificatePhotoArrayM;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@property (nonatomic, assign) NSInteger integrr;
@property (nonatomic, assign) BOOL whetheranonymous;
@property (nonatomic, assign) BOOL visibleRangeIsTheDefault;
@property (nonatomic, assign) BOOL whetherTheDefault;
@property (nonatomic, assign) BOOL defaultTime;
@property (nonatomic, strong) NSArray *mineOptionData;
@property (nonatomic, copy) NSString *cidString;
@property (nonatomic, copy) NSString *formaString;

// 支付宝 || 微信
@property (nonatomic, copy) NSString *type;
// 支付宝证书
@property (nonatomic, copy) NSString *orderString;
// 总金额
@property (nonatomic, copy) NSString *theTotalAmountOfString;

// 第几次在线充值后的发布调用
@property (nonatomic, assign) NSInteger integer;

/**
 选择时间的view
 */
@property (nonatomic, strong) WQToChooseTimeView *toChooseTimeView;

/**
 添加工作经历的弹窗
 */
@property (nonatomic, strong) WQWorkExperiencePopupWindowView *workExperiencePopupWindowView;

/**
 添加工作经历成功
 */
@property (nonatomic, assign) BOOL addWorkSuccessful;

@property (nonatomic, assign) BOOL isAPNS;

@property (nonatomic, copy) NSString *timeString;

@end

@implementation WQdemaadnforHairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isAPNS = NO;
    self.integer = 0;
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    if (self.releaseType == WQOrderTypeGroup) {
        self.mineOptionData = @[@"1",@"期待服务者所在地",@"截止时间",@"报酬"];
    }else {
        self.mineOptionData = [self loadMineOptionData];
    }
    [WQDataSource sharedTool].mapSelectedCity = nil;
    self.imageString = [[NSString alloc]init];
    self.formaString = [WQTool getLastTime:2592000];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFriends:) name:WQselectedFriendsArray object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqAliPayForSuccess) name:WQaliPayForSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqAliPayForSuccess) name:WQWXApiPayForSuccess object:nil];
}

#pragma mark -- 支付宝支付成功
- (void)wqAliPayForSuccess {
    if (self.integer == 0) {
        [self releaseRequirements];
        self.integer++;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = self.titleString;
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseBtnClike)];
    rightBarItem.enabled = YES;
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.rightBarItem = rightBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    /*UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClike)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;*/
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

    [self loadStatus];
}

#pragma mark -- 获取用户状态
- (void)loadStatus {
    NSString *urlString = @"api/user/getbasicinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *ghUserDefaults = [NSUserDefaults standardUserDefaults];
    params[@"secretkey"] = [ghUserDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        NSString *statusString = response[@"idcard_status"];
        [WQDataSource sharedTool].work_experienceArray = response[@"work_experience"];
        [WQDataSource sharedTool].loginStatus = statusString;
    }];
}

- (void)cancelBtnClike {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否放弃已编辑的内容？"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"退出"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  //[self dismissViewControllerAnimated:YES completion:nil];
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 通知方法
- (void)selectedFriends:(NSNotification *)notification {
    self.visibleRangeIsTheDefault = YES;
    NSArray *selectedFriendsArray = [notification.userInfo objectForKey:@"selectedFriendsArray"];
    self.params[@"push_range"] = @"PUSH_RANGE_PART";
    self.params[@"range_value"] = [self arrayToString:selectedFriendsArray];
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    cell.callbackLabel.text = @"指定好友";
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.tableview = tableView;
    // 上，左，下，右
    // tableView.separatorInset = UIEdgeInsetsMake(0, 15, 20, 15);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"WQpublishTableViewCell" bundle:nil] forCellReuseIdentifier:oncCellid];
    [tableView registerNib:[UINib nibWithNibName:@"WQpublishTwoTableViewCell" bundle:nil] forCellReuseIdentifier:twoCellid];
    [tableView registerClass:[WQsubscribeToTableViewCell class] forCellReuseIdentifier:subscribeToCellid];
    if (self.releaseType == WQOrderTypeGroup) {
        [tableView registerNib:[UINib nibWithNibName:@"WQIsGroupTableViewCell" bundle:nil] forCellReuseIdentifier:wqIsGroupTableViewCellid];
    }
    
    //WQdemaadnforHairview *demaadnforHairviewview = [[WQdemaadnforHairview alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 221)];
    NSInteger hight = 320;
    if ([self.titleString rangeOfString:@"帮忙"].location !=NSNotFound) {
        hight = 325;
    }else if ([self.titleString rangeOfString:@"BBS"].location !=NSNotFound) {
        hight = 310;
    }else if ([self.titleString rangeOfString:@"问事"].location !=NSNotFound) {
        hight = 346;
    }else if ([self.titleString rangeOfString:@"找人"].location !=NSNotFound) {
        hight = 345;
    }
    WQdemaadnforHairview *demaadnforHairviewview = [[WQdemaadnforHairview alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hight) titleString:self.titleString];
    self.demaadnforHairview = demaadnforHairviewview;
    tableView.tableHeaderView = demaadnforHairviewview;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //[self.view addSubview:self.popupWindowView];
//    [self.navigationController.view addSubview:self.popupWindowView];
    if ([self.titleString isEqualToString:@"BBS "]) {
        self.popupWindowView.isBBS = YES;
    }else {
        self.popupWindowView.isBBS = NO;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.popupWindowView];
    self.popupWindowView.delegate = self;
    
    WQvisibleRangeViewController *visibleRangeVc = [[WQvisibleRangeViewController alloc] init];
    self.visibleRangeVc = visibleRangeVc;
    __weak typeof(self) weakSelf = self;
    
    [visibleRangeVc setFinishBtnClikeBlock:^(NSArray *finishArray) {
        self.visibleRangeIsTheDefault = YES;
        weakSelf.params[@"push_range"] = @"PUSH_RANGE_PART";
        weakSelf.params[@"range_value"] = [weakSelf arrayToString:finishArray];
        WQpublishTwoTableViewCell *cell = [weakSelf.tableview cellForRowAtIndexPath:weakSelf.indexPath];
        cell.callbackLabel.text = @"仅好友";
    }];
    [visibleRangeVc setFinishBtnBlock:^(NSInteger integer) {
        weakSelf.visibleRangeIsTheDefault = YES;
        weakSelf.params[@"push_range"] = @"PUSH_RANGE_ALL";
        WQpublishTwoTableViewCell *cell = [weakSelf.tableview cellForRowAtIndexPath:weakSelf.indexPath];
        cell.callbackLabel.text = @"所有人";
    }];
    
    [self.popupWindowView setReturnBtnClikeBlock:^{
        weakSelf.popupWindowView.hidden = YES;
    }];

//    [self.view addSubview:self.topUpPopupWindowView];
//    [self.topUpPopupWindowView setReturnBtnClikeBlock:^{
//        weakSelf.topUpPopupWindowView.hidden = YES;
//    }];
//    [self.topUpPopupWindowView setSubmitBtnClikeBlock:^(NSString *moneyString) {
//        if ([weakSelf.type isEqualToString:@"支付宝"]) {
//            [weakSelf rechargeClike:moneyString];
//        }else {
//            [weakSelf weChatPay:moneyString];
//        }
//    }];
    
    WQToChooseTimeView *toChooseTimeView = [[WQToChooseTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.toChooseTimeView = toChooseTimeView;
    toChooseTimeView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:toChooseTimeView];
    
    [toChooseTimeView setToChooseTimeBlock:^(NSString *timeString) {
        self.toChooseTimeView.hidden = !self.toChooseTimeView.hidden;
        WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
        if ([timeString isEqualToString:@"7天"]) {
            self.timeString = timeString;
            self.formaString = [WQTool getLastTime:604800];
            cell.callbackLabel.text = timeString;
        }else if ([timeString isEqualToString:@"15天"]) {
            self.formaString = [WQTool getLastTime:1296000];
            self.timeString = timeString;
            cell.callbackLabel.text = timeString;
        }else if ([timeString isEqualToString:@"1个月"]) {
            self.formaString = [WQTool getLastTime:2592000];
            self.timeString = timeString;
            cell.callbackLabel.text = timeString;
        }else {
            WQPickerView *datePicker = [[WQPickerView alloc]init];
            datePicker.delegate = self;
            [datePicker show];
        }
    }];
    
    WQWorkExperiencePopupWindowView *workExperiencePopupWindowView = [[WQWorkExperiencePopupWindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.workExperiencePopupWindowView = workExperiencePopupWindowView;
    self.workExperiencePopupWindowView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:workExperiencePopupWindowView];
    
    WQaddWorkViewController *vc = [[WQaddWorkViewController alloc] init];
    [vc setAddSuccessfulBlock:^{
        self.rightBarItem.enabled = YES;
        self.addWorkSuccessful = YES;
    }];
    __weak typeof(workExperiencePopupWindowView) weakWorkExperiencePopupWindowView = workExperiencePopupWindowView;
    [workExperiencePopupWindowView setAddWorkBlock:^{
        weakWorkExperiencePopupWindowView.hidden = YES;
        vc.isReleaseNeeds = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [workExperiencePopupWindowView setBtnClickBlock:^{
        self.rightBarItem.enabled = YES;
        self.addWorkSuccessful = YES;
    }];
}
#pragma mark - **************** 时间选择器Delegate
- (void)didSelectDate:(NSString *)dateStr
{
    self.defaultTime = YES;
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    cell.callbackLabel.text = dateStr;
    self.formaString = dateStr;
}

#pragma mark -- 支付宝支付
- (void)rechargeClike:(NSString *)moneyString {
    NSString *urlString = @"api/pay/alipay/signaturesurl";
    NSMutableDictionary *aliparams = [NSMutableDictionary dictionary];
    aliparams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    aliparams[@"partner"] = @"2088521293409001";
    aliparams[@"service"] = @"mobile.securitypay.pay";
    aliparams[@"seller_id"] = @"2088521293409001";
    aliparams[@"total_amount"] = moneyString;
    //aliparams[@"total_amount"] = @"0.01";
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:aliparams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        weakSelf.orderString = response[@"data"];
        BOOL successBool = [response[@"success"] boolValue];
        if (successBool) {
            [weakSelf setupAlipaySDK];
        }
    }];
}

#pragma mark -- 阿里
- (void)setupAlipaySDK {
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *appScheme = @"ghcom.belight-wanquan";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:self.orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            //[self loadData];
            NSLog(@"支付成功");
        }
        NSString *resultStatus = resultDic[@"resultCode"];
        
    }];
}

#pragma mark -- 微信支付
- (void)weChatPay:(NSString *)moneyString {
    NSString *urlString = @"api/pay/wxpay/signaturesurl";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"total_amount"] = moneyString;
    //params[@"total_amount"] = @"0.01";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSString *timestamp = response[@"timestamp"];
            PayReq *rep = [[PayReq alloc] init];
            rep.partnerId = [response objectForKey:@"partnerid"];
            rep.prepayId = [response objectForKey:@"prepayid"];
            rep.nonceStr = [response objectForKey:@"noncestr"];
            rep.timeStamp = [timestamp intValue];
            rep.package = [response objectForKey:@"package"];
            rep.sign = [response objectForKey:@"sign"];
            BOOL isSuccessful = [WXApi sendReq:rep];
            NSLog(@"%d",isSuccessful);
        }
    }];
}


#pragma mark - 发布需求
- (void)releaseRequirements {
    // [[WQAuthorityManager manger] showAlertForAPNSAuthority];
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (!self.isAPNS) {
        if (!settings.types) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"还未开启通知" message:@"开启通知能让您及时了解订单状态,收到好友的消息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.isAPNS = YES;
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            __weak typeof([UIApplication sharedApplication]) weakapp =  [UIApplication sharedApplication];
            UIAlertAction * setting = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.isAPNS = YES;
                [weakapp openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            
            [alert addAction:actionCancle];
            [alert addAction:setting];
            [self presentViewController:alert animated:YES completion:nil];
            self.rightBarItem.enabled = YES;
            return;
        }
    }
    
    
    NSString *urlString = @"api/need/createneed";
    //用户密钥
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    NSString *title = [self.titleString stringByReplacingOccurrencesOfString:@" "withString:@""];
    if ([self.titleString isEqualToString:@"问事 "]) {
        _params[@"subject"] = [[[[@"【" stringByAppendingString:title] stringByAppendingString:@"】"] stringByAppendingString:self.demaadnforHairview.label.text] stringByAppendingString:self.demaadnforHairview.headlineTextField.text];
    }else if ([self.titleString isEqualToString:@"找人 "]) {
        _params[@"subject"] = [[[[@"【" stringByAppendingString:title] stringByAppendingString:@"】"] stringByAppendingString:@"求介绍"]stringByAppendingString:self.demaadnforHairview.headlineTextField.text];
    }else {
        _params[@"subject"] = [[[@"【" stringByAppendingString:title] stringByAppendingString:@"】"] stringByAppendingString:self.demaadnforHairview.headlineTextField.text];
    }
    if ([self.titleString isEqualToString:@"BBS "]) {
        if ([self.childNodesString isEqualToString:@"其他"]) {
            _params[@"subject"] = [[[@"【" stringByAppendingString:@"BBS"] stringByAppendingString:@"】"] stringByAppendingString:self.demaadnforHairview.headlineTextField.text];
        }else {
            _params[@"subject"] = [[[@"【" stringByAppendingString:self.childNodesString] stringByAppendingString:@"】"] stringByAppendingString:self.demaadnforHairview.headlineTextField.text];
        }
    }
    _params[@"content"] = self.demaadnforHairview.contentTextView.text;
    NSString *isTruename = (_whetheranonymous == false) ? @"true" : @"false";
    _params[@"truename"] = isTruename;
    _params[@"finished_date"] = self.formaString;
    //_params[@"cid"] = self.cidString;
    _params[@"cid"] = self.needsId;
    _params[@"addr_geo_lat"] = _params[@"addr_geo_lat"] ?:@([WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude).description;
    _params[@"addr_geo_lng"] = _params[@"addr_geo_lng"] ?:@([WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude).description;
    _params[@"content_time"] = self.demaadnforHairview.timeTextFieid.text;
    _params[@"content_addr"] = self.demaadnforHairview.placeTextField.text;
    if (self.releaseType == WQOrderTypeGroup) {
        _params[@"push_range"] = @"PUSH_RANGE_GROUP";
        _params[@"range_value"] = self.gid;
    }
    
    NSMutableString *content_requirement = [NSMutableString string];
    if ([self.titleString isEqualToString:@"找人 "]) {
        if (self.demaadnforHairview.contactBtn.selected) {
            [content_requirement appendString:self.demaadnforHairview.contactBtn.titleLabel.text];
        }
        if (self.demaadnforHairview.facilitateBtn.selected) {
            [content_requirement appendString:@"  "];
            [content_requirement appendString:self.demaadnforHairview.facilitateBtn.titleLabel.text];
        }
        if (self.demaadnforHairview.arrangeBtn.selected) {
            [content_requirement appendString:@"  "];
            [content_requirement appendString:self.demaadnforHairview.arrangeBtn.titleLabel.text];
        }
        _params[@"content_requirement"] = content_requirement;
    }
    if ([self.titleString isEqualToString:@"问事 "]) {
        _params[@"content_requirement"] = self.demaadnforHairview.qualificationTextView.text;
    }
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:self.certificatePhotoArrayM options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    _params[@"pic"]  = self.certificatePhotoArrayM.count != 0 ? idcardStr : @"[\n\n]";
    NSString *mapArea = [WQDataSource sharedTool].mapSelectedCity;
    _params[@"addr"] = mapArea ? : [WQLocationManager defaultLocationManager].currentCity?:[WQLocationManager defaultLocationManager].defaultCity;
    _params[@"tag"] = @"[\n\n]";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        // 您钱包中的可用金额不足！
        if ([[NSString stringWithFormat:@"%@",response[@"ecode"]] isEqualToString:@"-6"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的钱包余额不足"
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSLog(@"取消");
                                                                     self.rightBarItem.enabled = YES;
                                                                 }];
            UIAlertAction *destructiveButton =
            [UIAlertAction actionWithTitle:@"在线支付"
                                     style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       
                                       UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                                       [sheet showInView:self.view];
                                       self.rightBarItem.enabled = YES;
                                       
                                   }];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            [destructiveButton setValue:[UIColor colorWithHex:0x9767d0] forKey:@"titleTextColor"];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        BOOL successbool = [response[@"success"] boolValue];
        if (successbool) {
            self.rightBarItem.enabled = YES;
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"发布成功，请及时回复他人接单" preferredStyle:UIAlertControllerStyleAlert];
            _params = nil;
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQSuccessfulReleaseDemand object:self];
                    if (self.releaseType == WQOrderTypeGroup) {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[WQGroupDynamicViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }else {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[WQHomeNearbyViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }
                });
            }];
        }else{
            self.rightBarItem.enabled = YES;
            [self.certificatePhotoArrayM removeAllObjects];
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    // 充值
    if ([title isEqualToString:@"支付宝"]) {
        [self rechargeClike:self.theTotalAmountOfString];
    }else if ([title isEqualToString:@"微信"]) {
        [self weChatPay:self.theTotalAmountOfString];
    }
}

#pragma mark - 发布按钮响应事件
- (void)releaseBtnClike {
    [self.view endEditing:YES];
    // 标题是否为空
    NSString *subjectString = [self.demaadnforHairview.headlineTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([subjectString length] == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"标题不可为空" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [self.certificatePhotoArrayM removeAllObjects];
        self.rightBarItem.enabled = YES;
        return;
    }
    
    NSString *conString = [self.demaadnforHairview.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([conString length] == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"内容不可为空" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [self.certificatePhotoArrayM removeAllObjects];
        self.rightBarItem.enabled = YES;
        return;
    }
    
    float money = [self.params[@"money"] floatValue];
    if (![self.titleString isEqualToString:@"BBS "]) {
        if (money <= 0) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"单人报酬不能为0元" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.certificatePhotoArrayM removeAllObjects];
            self.rightBarItem.enabled = YES;
            return;
        }
    }else{
        if (money <= 0) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"红包金额不能为0" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.certificatePhotoArrayM removeAllObjects];
            self.rightBarItem.enabled = YES;
            return;
        }

        
    }
    
    if ([self.titleString isEqualToString:@"找人 "]) {
        if (self.demaadnforHairview.headlineTextField.text.length > 13) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过13个字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.certificatePhotoArrayM removeAllObjects];
            self.rightBarItem.enabled = YES;
            return;
        }
    }else if ([self.titleString isEqualToString:@"问事 "]) {
        if ([self.demaadnforHairview.label.text isEqualToString:@"咨询"]) {
            if (self.demaadnforHairview.headlineTextField.text.length > 14) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过14个字" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                [self.certificatePhotoArrayM removeAllObjects];
                self.rightBarItem.enabled = YES;
                return;
            }
        }else {
            if (self.demaadnforHairview.headlineTextField.text.length > 13) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过13个字" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                [self.certificatePhotoArrayM removeAllObjects];
                self.rightBarItem.enabled = YES;
                return;
            }
        }
    }else if ([self.titleString isEqualToString:@"帮忙 "]) {
        if (self.demaadnforHairview.headlineTextField.text.length > 16) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过16个字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.certificatePhotoArrayM removeAllObjects];
            self.rightBarItem.enabled = YES;
            return;
        }
    }else {
        if (self.demaadnforHairview.headlineTextField.text.length > 16) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过16个字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.certificatePhotoArrayM removeAllObjects];
            self.rightBarItem.enabled = YES;
            return;
        }
    }
    
    if (self.addWorkSuccessful) {
        self.workExperiencePopupWindowView.hidden = YES;
    }else {
        if ([WQDataSource sharedTool].work_experienceArray.count) {
            self.workExperiencePopupWindowView.hidden = YES;
        }else {
            self.workExperiencePopupWindowView.hidden = NO;
            return;
        }
    }
    
    self.rightBarItem.enabled = NO;
    dispatch_group_t group = dispatch_group_create();
    
    for (id image in self.demaadnforHairview.imageArray) {
        dispatch_group_enter(group);
        NSString *fileName;
        if (_integrr == 1) {
            fileName = @"rightBtn";
        }else {
            fileName = @"leftBtn";
        }
        
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSString *urlString = @"file/upload";
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            [self.certificatePhotoArrayM addObject:responseObject[@"fileID"]];;
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
            self.rightBarItem.enabled = YES;
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self releaseRequirements];
        [SVProgressHUD dismiss];
    });
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

// 解析数据
- (NSArray*)loadMineOptionData {
    return [NSArray objectListWithPlistName:@"WQpublishViewControllerList.plist" clsName:@"WQpublishModel"];
}

#pragma mark - 弹窗
- (void)toThePopupWindow {
//    [[NSNotificationCenter defaultCenter] postNotificationName:WQpopupWindowToLoadTheUI object:self userInfo:nil];
//    self.popupWindowView.hidden = NO;
//    CGRect popupWindowView = self.popupWindowView.frame;
//    popupWindowView.origin.y = self.view.bounds.origin.y;
//    popupWindowView.size.height = kScreenHeight;
//    popupWindowView.size.width = kScreenWidth;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.popupWindowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
//        self.popupWindowView.frame = popupWindowView;
//    }];
    self.popupWindowView.hidden = !self.popupWindowView.hidden;
}

#pragma mark - WQpopupWindowViewDelegate
- (void)wqPopupWindowView:(WQpopupWindowView *)popupWindowView TotalAmountOf:(NSString *)totalAmountOf aSinglePayment:(NSString *)aSinglePayment theTotalAmountOf:(NSString *)theTotalAmountOf {
    if ([totalAmountOf integerValue] == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"交易人数不可为0" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }

    if ([aSinglePayment integerValue] < 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"报酬不可以为0元" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    // 显示金额是否默认
    self.whetherTheDefault = YES;
    self.popupWindowView.hidden = YES;
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    cell.callbackLabel.text = theTotalAmountOf;
    self.params[@"total_count"] = totalAmountOf;
    self.params[@"money"] = aSinglePayment;
    self.theTotalAmountOfString = theTotalAmountOf;
    [self.tableview reloadData];
}

- (void)wqDetermineBtnClick:(WQpopupWindowView *)popupWindowView totalString:(NSString *)totalString personNum:(NSString *)personNum moneyString:(NSString *)moneyString {
    popupWindowView.hidden = !popupWindowView.hidden;
    // 显示金额是否默认
    self.whetherTheDefault = YES;
    self.popupWindowView.hidden = YES;
    NSIndexPath *index;
    if (self.releaseType == WQOrderTypeGroup) {
        index = [NSIndexPath indexPathForRow:3 inSection:1];
    }else {
        index = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:index];
    cell.callbackLabel.text = totalString;
    self.params[@"total_count"] = personNum;
    self.params[@"money"] = moneyString;
    self.theTotalAmountOfString = totalString;
    [self.tableview reloadData];
}

#pragma mark - CuiPickViewDelegate
-(void)didFinishPickView:(NSString *)date {
    self.defaultTime = YES;
    WQpublishTwoTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    cell.callbackLabel.text = date;
    self.formaString = date;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.indexPath = indexPath;
    //发送通知取消键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:WQresignFirstResponder object:self userInfo:nil];
    WQpublishTwoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.releaseType == WQOrderTypeGroup) {
        switch (indexPath.row) {
            case 0:{
                
            }
                break;
            case 1:{
                
                
                if (![WQAuthorityManager manger].haveLocateAuthority) {
                    [[WQAuthorityManager manger] showAlertForLocateAuthority];
                    return;
                }
                
                WQHomeMapViewController *vc = [WQHomeMapViewController new];
                __weak typeof(self) weakSelf = self;
                [vc setCoordinateBlock:^(CLLocationCoordinate2D locaiton) {
                    weakSelf.params[@"addr_geo_lat"] = @(locaiton.latitude).description;
                    weakSelf.params[@"addr_geo_lng"] = @(locaiton.longitude).description;
                }];
                [vc setGeographicalPositionBlock:^(NSString *str){
                    cell.callbackLabel.text = str;
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                self.toChooseTimeView.hidden = !self.toChooseTimeView.hidden;
//                _cuiPickerView = [[CuiPickerView alloc]init];
//                _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
//                //这一步很重要
//                _cuiPickerView.myTextField = nil;
//
//                _cuiPickerView.delegate = self;
//                _cuiPickerView.curDate=[NSDate date];
//                [self.view addSubview:_cuiPickerView];
//                [_cuiPickerView showInView:self.view];
            }
                break;
            case 3:{
                [self toThePopupWindow];
            }
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:{
                /*WQManagesubscriptionsViewController *vc = [WQManagesubscriptionsViewController new];
                 [vc setPopoBlock:^(NSString *cidString) {
                 self.cidString = cidString;
                 WQsubscribeToTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                 cell.isSelectedLabel.text = @"已选";
                 }];
                 [self.navigationController pushViewController:vc animated:YES];*/
            }
                break;
            case 1:{
                
                if (![WQAuthorityManager manger].haveLocateAuthority) {
                    [[WQAuthorityManager manger] showAlertForLocateAuthority];
                    return;
                }
                
                WQHomeMapViewController *vc = [WQHomeMapViewController new];
                [vc setGeographicalPositionBlock:^(NSString *str){
                    cell.callbackLabel.text = str;
                }];
                __weak typeof(self) weakSelf = self;
                [vc setCoordinateBlock:^(CLLocationCoordinate2D locaiton) {
                    weakSelf.params[@"addr_geo_lat"] = @(locaiton.latitude).description;
                    weakSelf.params[@"addr_geo_lng"] = @(locaiton.longitude).description;
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                [self.navigationController pushViewController:self.visibleRangeVc animated:YES];
            }
                break;
            case 3:{
                self.toChooseTimeView.hidden = !self.toChooseTimeView.hidden;

            }
                break;
            case 4:{
                [self toThePopupWindow];
            }
                break;
            case 5:{
                /*[WQEditTextView showWithController:self andRequestDataBlock:^(NSString *text) {
                 self.rewardString = text;
                 NSLog(@"这里面去实现数据的回调");
                 WQpublishTwoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                 
                 cell.callbackLabel.text = self.rewardString;
                 }];*/
                
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.releaseType == WQOrderTypeGroup) {
        if (indexPath.section == 1) {
            return 55;
        }else {
            return ghCellHeight;
        }
    }else {
        return ghCellHeight;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.releaseType == WQOrderTypeGroup) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.releaseType == WQOrderTypeGroup) {
        if (section == 0) {
            return self.mineOptionData.count;
        }else {
            return 1;
        }
    }else {
        return self.mineOptionData.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (self.releaseType == WQOrderTypeGroup) {
        if (indexPath.section == 1) {
            WQIsGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wqIsGroupTableViewCellid forIndexPath:indexPath];
            // 是否转发到需求
            [cell setIsForwardingNeedsBlock:^(BOOL isForwardingNeeds){
                if (isForwardingNeeds) {
                    weakSelf.params[@"range_push_all"] = @"true";
                }else {
                    weakSelf.params[@"range_push_all"] = @"false";
                }
            }];
            
            return cell;
        }
    }
    if (indexPath.row == 0) {
        WQpublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncCellid forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.boolwhetheranonymousBlock = ^(BOOL whetheranonymous) {
            _whetheranonymous = whetheranonymous;
        };
        return cell;
    }else{
        WQpublishTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCellid forIndexPath:indexPath];
        if (self.releaseType == WQOrderTypeGroup) {
            cell.publishTwoLabel.text = self.mineOptionData[indexPath.row];
        }else {
            cell.publishModel = self.mineOptionData[indexPath.row];
        }
        // 群组
        if (self.releaseType == WQOrderTypeGroup) {
            if (indexPath.row == 3) {
                if ([self.titleString isEqualToString:@"BBS "]) {
                    if (!self.whetherTheDefault) {
                        cell.callbackLabel.text = @"10";
                        self.params[@"total_count"] = @"100";
                        self.params[@"money"] = @"0.1";
                        self.theTotalAmountOfString = @"10";
                    }
                }else {
                    if (!self.whetherTheDefault) {
                        cell.callbackLabel.text = @"10";
                        self.params[@"total_count"] = @"1";
                        self.params[@"money"] = @"10";
                        self.theTotalAmountOfString = @"10";
                    }
                }
            }
            if (indexPath.row == 2) {
                
                if (!self.defaultTime) {
                    cell.callbackLabel.text = @"1个月";
                }
            }
        }else {
            if (indexPath.row == 4) {
                if ([self.titleString isEqualToString:@"BBS "]) {
                    if (!self.whetherTheDefault) {
                        cell.callbackLabel.text = @"10";
                        self.params[@"total_count"] = @"100";
                        self.params[@"money"] = @"0.1";
                        self.theTotalAmountOfString = @"10";
                    }
                }else {
                    if (!self.whetherTheDefault) {
                        cell.callbackLabel.text = @"10";
                        self.params[@"total_count"] = @"1";
                        self.params[@"money"] = @"10";
                        self.theTotalAmountOfString = @"10";
                    }
                }
            }
            if (indexPath.row == 3) {
                if (self.timeString.length) {
                    cell.callbackLabel.text = self.timeString;
                }else if (!self.defaultTime) {
                    cell.callbackLabel.text =  @"1个月";
                }
            }
            if (indexPath.row == 2) {
                // 是否显示默认可见范围
                if (!self.visibleRangeIsTheDefault) {
                    cell.callbackLabel.text = @"所有人";
                    self.params[@"push_range"] = @"PUSH_RANGE_ALL";
                }
            }
        }
        if (indexPath.row == 1) {
            if (!self.whetherTheDefault) {
                cell.callbackLabel.text = @"当前位置";
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - 下一步点击事件
- (void)numberClick:(UIBarButtonItem *)sender {
    if (self.demaadnforHairview.titlenil == NO) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入标题" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (self.demaadnforHairview.contentnil == NO) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (self.demaadnforHairview.fontLength == NO) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"本标题请勿超过18个字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    dispatch_group_t group=dispatch_group_create();
    
    for (id image in self.picArray) {
        dispatch_group_enter(group);
        NSString *fileName;
        if (_integrr == 1) {
            fileName = @"rightBtn";
        }else {
            fileName = @"leftBtn";
        }
        
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSString *urlString = @"file/upload";
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            [self.certificatePhotoArrayM addObject:responseObject[@"fileID"]];;
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        WQpublishViewController *publishVc = [WQpublishViewController new];
        self.publishVc = publishVc;
        //图片ID赋值
        publishVc.imageId = self.certificatePhotoArrayM;
        self.contentTextViewtext = self.demaadnforHairview.contentTextView.text;
        publishVc.headlineTextField = self.demaadnforHairview.headlineTextField.text;
        publishVc.contentTextView = self.contentTextViewtext;
        [self.navigationController pushViewController:publishVc animated:YES];
    });

}

#pragma mark - 懒加载
- (NSMutableArray *)certificatePhotoArrayM {
    if (!_certificatePhotoArrayM) {
        _certificatePhotoArrayM = [NSMutableArray array];
    }
    return _certificatePhotoArrayM;
}
- (NSMutableArray *)picArray {
    if (!_picArray) {
        _picArray = [[NSMutableArray alloc]init];
    }
    return _picArray;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

- (WQpopupWindowView *)popupWindowView {
    if (!_popupWindowView) {
        _popupWindowView = [[WQpopupWindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _popupWindowView.hidden = YES;
                            //WithFrame:CGRectMake(gHframeHWXY, kScreenHeight,kScreenHeight,gHframeHWXY)];
    }
    return _popupWindowView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)back {
    NSString *subjectString = [self.demaadnforHairview.headlineTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contentString = [self.demaadnforHairview.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([subjectString length] == 0 && [contentString length] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃已编辑内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:cancle];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
