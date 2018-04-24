//
//  WQMyWalletViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/16.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import "WQMyWalletViewController.h"
#import "WQmyWalletViewDetailsTableViewCell.h"
#import "WQaccountDetailsViewController.h"
#import "WQMyWalletModel.h"
#import "WQembodyViewController.h"
#import "WQWalletTopView.h"
#import "WQtopUpPopupWindowView.h"
#import "WXApi.h"
#import "WQUserProfileController.h"
#import "WQMyUploadIdPhotoViewController.h"

static NSString *vacanciescellid = @"vacanciescellid";
static NSString *cellid = @"cellid";

@interface WQMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate,WXApiDelegate>
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *personalInformationParams;
@property (nonatomic, strong) NSMutableDictionary *aliparams;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *titleImageArray;
@property (nonatomic, strong) UIActionSheet *withdrawalsSheet;
@property (nonatomic, strong) WQWalletTopView *topView;
@property (nonatomic, strong) WQMyWalletModel *mdoel;
@property (nonatomic, strong) WQtopUpPopupWindowView *popupWindowView;
@property (nonatomic, copy) NSString *orderString;
@property (nonatomic, copy) NSString *out_trade_no;
@property (nonatomic, copy) NSString *moneyString;
@property (nonatomic, copy) NSString *type;
@end

@implementation WQMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [self loadPersonalInformation];
    self.titleArray = @[@"充值",@"提现"];
    self.titleImageArray = @[@"qianbaochongzhi",@"qianbaotixian"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:WQWeChatSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqAliPayForSuccess) name:WQWXApiPayForSuccess object:nil];
}

#pragma mark -- 微信充值成功
- (void)wqAliPayForSuccess {
    self.popupWindowView.hidden = YES;
    [self loadData];
}

// 微信授权成功
- (void)notificationCenter:(NSNotification *)notification {
    WQembodyViewController *embodyVc = [[WQembodyViewController alloc] init];
    embodyVc.state = @"微信";
    embodyVc.code = [notification.userInfo objectForKey:@"code"];
    embodyVc.availableBalance = self.topView.accountBalanceLabel.text;
    [self.navigationController pushViewController:embodyVc animated:YES];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]) {
        
        // 支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                /** 发送支付成功的通知 */
                //[[NSNotificationCenter defaultCenter] postNotificationName:HQPaySuccessNotification object:nil userInfo:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付失败"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                /** 发送支付失败的通知 */
                //[[NSNotificationCenter defaultCenter] postNotificationName:HQCancelPayNotification object:nil userInfo:nil];
                break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    self.navigationItem.title = @"我的钱包";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor =  UIColor.clearColor;
    UIBarButtonItem *accountDetailsBtn = [[UIBarButtonItem alloc] initWithTitle:@"账户明细" style:UIBarButtonItemStylePlain target:self action:@selector(accountDetailsBtnClike)];
    self.navigationItem.rightBarButtonItem = accountDetailsBtn;
    [accountDetailsBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upList) name:WQaliPayForSuccess object:nil];
}

// 刷新数据
- (void)upList {
    self.popupWindowView.hidden = YES;
    [self loadData];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 初始化UI
- (void)setupUI {
    WQWalletTopView *topView = [[WQWalletTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScaleX(305))];
    self.topView = topView;

    UITableView *tableview = [[UITableView alloc]init];
    tableview.tableHeaderView = topView;
    tableview.backgroundColor = [UIColor colorWithHex:0xededed];
    [tableview registerNib:[UINib nibWithNibName:@"WQmyWalletViewDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    if (@available(iOS 11.0, *)) {
        tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //取消分割线
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.dataSource = self;
    tableview.delegate = self;
    self.tableview = tableview;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.popupWindowView];
    [self.popupWindowView setReturnBtnClikeBlock:^{
        weakSelf.popupWindowView.hidden = YES;
    }];
    [self.popupWindowView setSubmitBtnClikeBlock:^(NSString *moneyString) {
        weakSelf.moneyString = moneyString;
        if ([weakSelf.type isEqualToString:@"支付宝"]) {
            [weakSelf rechargeClike];
        }else {
            [weakSelf weChatPay];
        }
    }];
}

// 微信支付
- (void)weChatPay {
    NSString *urlString = @"api/pay/wxpay/signaturesurl";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"total_amount"] = self.moneyString;
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

#pragma mark -- 加载数据
- (void)loadPersonalInformation {
    NSString *urlString = @"api/user/getbasicinfo";
    self.personalInformationParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_personalInformationParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.topView.userNameLabel.text = response[@"true_name"];
        NSString *imageUrl = [imageUrlString stringByAppendingString:response[@"pic_truename"]];
        [self.topView.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"zhanweitubai"]];
        [self.tableview reloadData];
    }];
}

- (void)loadData {
    NSString *urlString = @"api/wallet/getwalletinfo";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        WQMyWalletModel *model = [WQMyWalletModel yy_modelWithJSON:response];
        self.mdoel = model;
        // 账户余额
        self.topView.accountBalanceLabel.text = [NSString stringWithFormat:@"%.2f",model.useable_money];
        // 冻结资金
        self.topView.freezeFundsLabel.text = [NSString stringWithFormat:@"%.2f",model.frozen_money];
        BOOL successBool = [response[@"success"] boolValue];
        if (successBool) {
            [self.tableview reloadData];
        }
    }];
}

#pragma mark -- 响应事件
- (void)accountDetailsBtnClike {
    WQaccountDetailsViewController *accountDetailsVc = [[WQaccountDetailsViewController alloc] init];
    [self.navigationController pushViewController:accountDetailsVc animated:YES];
}

#pragma mark - 弹窗
- (void)toThePopupWindowType:(NSString *)type {
    self.type = type;
    self.popupWindowView.hidden = NO;
    CGRect popupWindowView = self.popupWindowView.frame;
    popupWindowView.origin.y = self.view.bounds.origin.y;
    popupWindowView.size.height = kScreenHeight;
    popupWindowView.size.width = kScreenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.popupWindowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
        self.popupWindowView.frame = popupWindowView;
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    // 提现
    if (actionSheet == self.withdrawalsSheet) {
        WQembodyViewController *embodyVc = [[WQembodyViewController alloc] init];
        embodyVc.availableBalance = self.topView.accountBalanceLabel.text;
        embodyVc.state = @"支付宝";
        if ([title isEqualToString:@"支付宝"]) {
            embodyVc.state = @"支付宝";
            [self.navigationController pushViewController:embodyVc animated:YES];
        }else if ([title isEqualToString:@"微信"]) {
            //embodyVc.state = @"微信";
            //构造SendAuthReq结构体
            SendAuthReq* req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"wanquan" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        }
    }else {
        // 充值
        if ([title isEqualToString:@"支付宝"]) {
            [self toThePopupWindowType:title];
        }else if ([title isEqualToString:@"微信"]) {
            [self toThePopupWindowType:title];
        }
    }
}

#pragma mark -- TableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        [sheet showInView:self.view];
    }else{
        NSUserDefaults *ghUserDefaults = [NSUserDefaults standardUserDefaults];
        if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"110"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"为保障账户安全，上传证件照片进行实名认证后可提现"
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                 }];
            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"去实名认证"
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          WQMyUploadIdPhotoViewController *vc = [[WQMyUploadIdPhotoViewController alloc] init];
                                                                          vc.user_picImage = self.topView.headPortraitImageView.image;
                                                                          [self.navigationController pushViewController:vc animated:YES];
                                                                      }];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            [destructiveButton setValue:[UIColor colorWithHex:0x9767d0] forKey:@"titleTextColor"];
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        
        UIActionSheet *withdrawalsSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        self.withdrawalsSheet = withdrawalsSheet;
        [withdrawalsSheet showInView:self.view];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQmyWalletViewDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.titleImageView.image = [UIImage imageNamed:self.titleImageArray[indexPath.row]];
    
    return cell;
}

- (void)rechargeClike {
    NSString *urlString = @"api/pay/alipay/signaturesurl";
    self.aliparams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _aliparams[@"partner"] = @"2088521293409001";
    _aliparams[@"service"] = @"mobile.securitypay.pay";
    _aliparams[@"seller_id"] = @"2088521293409001";
    _aliparams[@"total_amount"] = self.moneyString;
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_aliparams completion:^(id response, NSError *error) {
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
    // NOTE: 将签名成功字符串格式化为需求字符串,请严格按照该格式
    NSString *appScheme = @"ghcom.belight-wanquan";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:self.orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            [self loadData];
        }
        NSString *resultStatus = resultDic[@"resultCode"];
        
        [self handle:resultStatus];
    }];
}
#pragma mark -- /*判断回调的code*/
- (void)handle:(NSString *)code {
    
    //    if ([code isEqualToString:@"9000"]) {
    //
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //
    //        return ;
    //    }
    //
    //    if ([code isEqualToString:@"8000"]) {
    //        ZXAlertMessage(@"正在处理中", self.view);
    //        return;
    //    }
    //    if ([code isEqualToString:@"4000"]) {
    //        ZXAlertMessage(@"充值失败", self.view);
    //        return;
    //    }
    //    if ([code isEqualToString:@"6001"]) {
    //        ZXAlertMessage(@"您取消了充值", self.view);
    //        return;
    //    }
    //    if ([code isEqualToString:@"6002"]) {
    //        ZXAlertMessage(@"请检查您的网络连接", self.view);
    //        return;
    //    }
    //    if ([code isEqualToString:@"6004"]) {
    //        ZXAlertMessage(@"结果未知", self.view);
    //        return;
    //    }
    //    if ([code isEqualToString:@"其他"]) {
    //        ZXAlertMessage(@"未知错误", self.view);
    //        return;
    //    }
    
}

#pragma mark -- 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)aliparams {
    if (!_aliparams) {
        _aliparams = [[NSMutableDictionary alloc]init];
    }
    return _aliparams;
}
- (NSMutableDictionary *)personalInformationParams {
    if (!_personalInformationParams) {
        _personalInformationParams = [[NSMutableDictionary alloc] init];
    }
    return _personalInformationParams;
}
- (WQtopUpPopupWindowView *)popupWindowView {
    if (!_popupWindowView) {
        _popupWindowView = [[WQtopUpPopupWindowView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width,0)];
        _popupWindowView.backgroundColor = [UIColor colorWithHex:0Xb2b2b2];
    }
    return _popupWindowView;
}

@end
