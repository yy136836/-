//
//  WQlineOfCreditViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/4.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQlineOfCreditViewController.h"
#import "WQillustrationController.h"
#import "WQMyCriditView.h"

@interface WQlineOfCreditViewController ()
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) WQMyCriditView * criditView;
//@property (nonatomic, strong) UILabel *creditValueslabel;
//@property (nonatomic, strong) UIImageView *shieldImageView;
//@property (nonatomic, strong) UIImageView *backgroundImgaeView;
//@property (nonatomic, strong) UILabel *tagLabel;
@end

@implementation WQlineOfCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"我的信用";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 0.5)]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];


    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
}

#pragma mark -- 加载数据
- (void)loadData
{
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSString *credit_score = response[@"credit_score"];
            NSInteger integer = [credit_score integerValue];
            
            _criditView.creditValue = integer;
            if (integer < 40) {
//                self.tagLabel.text = @"信用不足";
//                self.creditValueslabel.textColor = [UIColor colorWithHex:0xffffff];
//                self.shieldImageView.image = [UIImage imageNamed:@"mu"];
            }else if (integer >= 40 && integer < 60){
//                self.tagLabel.text = @"信用一般";
//                self.creditValueslabel.textColor = [UIColor colorWithHex:0xffffff];
//                self.shieldImageView.image = [UIImage imageNamed:@"tie"];
            }else if (integer >= 60 && integer < 80){
//                self.tagLabel.text = @"信用良好";
//                self.creditValueslabel.textColor = [UIColor colorWithHex:0x5d2a89];
//                self.shieldImageView.image = [UIImage imageNamed:@"yin"];
            }else{
//                self.tagLabel.text = @"信用优秀";
//                self.creditValueslabel.textColor = [UIColor colorWithHex:0x5d2a89];
//                self.shieldImageView.image = [UIImage imageNamed:@"jin"];
            }
//            self.creditValueslabel.text = [NSString stringWithFormat:@"%@",credit_score];
        }
    }];
}

#pragma mark -- 初始化UI
- (void)setupUI {

    
    _criditView = [[NSBundle mainBundle] loadNibNamed:@"WQMyCriditView" owner:self options:nil].lastObject;
    _criditView.frame = self.view.frame;
    __weak typeof(self) weakself = self;
    _criditView.toKnowMore = ^{
        [weakself promoteBtnClike];
    };
    [self.view addSubview:_criditView];
}

#pragma mark -- 监听事件
- (void)promoteBtnClike {
    WQillustrationController *illustrationVc = [WQillustrationController new];
    [self.navigationController pushViewController:illustrationVc animated:YES];
}

#pragma mark -- 懒加载

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

//- (UIImageView *)shieldImageView {
//    if (!_shieldImageView) {
//        _shieldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    }
//    return _shieldImageView;
//}
//
//- (UIImageView *)backgroundImgaeView {
//    if (!_backgroundImgaeView) {
//        _backgroundImgaeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinyongedudi"]];
//    }
//    return _backgroundImgaeView;
//}
//- (UILabel *)creditValueslabel {
//    if (!_creditValueslabel) {
//        _creditValueslabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5d2a89] andFontSize:40];
//    }
//    return _creditValueslabel;
//}
//- (UILabel *)tagLabel {
//    if (!_tagLabel) {
//        _tagLabel = [UILabel labelWithText:@"信用优秀" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:15];
//    }
//    return _tagLabel;
//}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
