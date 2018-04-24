//
//  WQembodyViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQembodyViewController.h"
#import "WQIntroductionsController.h"
#import "WXApi.h"
#import "WQEmbodyView.h"

static NSString *cellid = @"cellid";

@interface WQembodyViewController ()<WXApiDelegate,WQEmbodyViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *embodyBtn;
@property (nonatomic, strong) NSArray *oncArray;
@property (nonatomic, strong) NSArray *twoArray;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *accounString;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *amountString;

@property (nonatomic, strong) WQEmbodyView *embodyView;
@end

@implementation WQembodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    self.navigationItem.title = @"提现";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    
//    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarbtnClick)];
//    self.navigationItem.leftBarButtonItem = leftBarbtn;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -- 初始化UI
- (void)setupUI {
    WQEmbodyView *embodyView = [[WQEmbodyView alloc] init];
    self.embodyView = embodyView;
    embodyView.state = self.state;
    embodyView.availableBalanceLabel.text = [[@"可用余额" stringByAppendingString:self.availableBalance] stringByAppendingString:@"元"];
    embodyView.delegate = self;
    [self.view addSubview:embodyView];
    [embodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.height.offset(kScaleX(259));
    }];
    
    [self.view addSubview:self.embodyBtn];
    [_embodyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(embodyView.mas_bottom).offset(kScaleX(50));
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(45);
    }];
}

#pragma mark -- WQEmbodyViewDelegate
- (void)wqDescriptionBtnClick:(WQEmbodyView *)embodyView {
    WQIntroductionsController *introductionsVc = [[WQIntroductionsController alloc] init];
    [self.navigationController pushViewController:introductionsVc animated:YES];
}

#pragma mark -- 监听事件
- (void)embodyBtnClike {
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
    if ([self.state isEqualToString:@"支付宝"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *urlString = @"api/pay/alipay/cashget";
            self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
            // 账号
            _params[@"payee_user_account"] = self.embodyView.accountTextField.text;
            // 提现金额
            _params[@"amount"] = self.embodyView.embodyTextField.text;
            // 姓名
            _params[@"payee_user_name"] = self.embodyView.nameTextField.text;
            [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                    return ;
                }
                if ([response isKindOfClass:[NSData class]]) {
                    response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                }
                NSLog(@"%@",response);
                if ([response[@"success"] boolValue]) {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"提现申请已提交至平台" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }];
                }else {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                        });
                    }];
                }
            }];
            
        });
    }else {
        NSString *urlString = @"api/pay/wxpay/cashget";
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        //dict[@"payee_user_account"] = self.accounString;
        dict[@"payee_user_account"] = self.code;
        dict[@"amount"] = self.embodyView.embodyTextField.text;
        dict[@"payee_user_name"] = self.embodyView.nameTextField.text;
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"提现申请已提交至平台" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }
}

#pragma mark -- 懒加载
- (UIButton *)embodyBtn {
    if (!_embodyBtn) {
        _embodyBtn = [[UIButton alloc]init];
        _embodyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _embodyBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        [_embodyBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        [_embodyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _embodyBtn.layer.cornerRadius = 5;
        [_embodyBtn addTarget:self action:@selector(embodyBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _embodyBtn;
}
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSString *)availableBalance {
    if (!_availableBalance) {
        _availableBalance = [[NSString alloc] init];
    }
    return _availableBalance;
}

#pragma mark -- 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
