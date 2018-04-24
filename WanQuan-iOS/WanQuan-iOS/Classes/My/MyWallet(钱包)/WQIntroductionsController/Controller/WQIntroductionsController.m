//
//  WQIntroductionsController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQIntroductionsController.h"

@interface WQIntroductionsController ()

@end

@implementation WQIntroductionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff];
    
    self.navigationItem.title = @"提现说明";
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
}

#pragma mark -- 初始化UI
- (void)setupUI {
    UILabel *oncLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.text = @"如何提现:";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kScaleX(ghDistanceershi) + ghNavigationBarHeight);
            make.left.equalTo(self.view).offset(ghSpacingOfshiwu);
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *twoLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"1. 万圈支持提现到支付宝或微信，万圈将承担您充值和提现的支付宝或微信手续费。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oncLabel.mas_left);
            make.top.equalTo(oncLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghDistanceershi);
        }];
        label;
    });
    UILabel *threeLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"2. 为保障您的财务安全，请理解只能提现到与万圈实名认证时使用的姓名一致的支付宝或微信用户。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoLabel.mas_left);
            make.top.equalTo(twoLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fourLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"3. 提现金额：因万圈为用户承担提现手续费，请理解单次提现需50元以上。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoLabel.mas_left);
            make.top.equalTo(threeLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fiveLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"4. 提现频率:每天均可申请提现，但为了确保账户信息安全准确，每天只可申请提现一次。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fourLabel.mas_left);
            make.top.equalTo(fourLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"5. 到账时间：提现申请成功递交后，请耐心等待；万圈每周定期两次批量进行人工审核，审核通过后立即完成支付。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fourLabel.mas_left);
            make.top.equalTo(fiveLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabel1 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"6. 因填写提现账号错误等原因导致提现失败时，钱款将退回钱包。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fourLabel.mas_left);
            make.top.equalTo(sevenLabel.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabel2 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"7. 特殊情况请直接联系客服（意见反馈、联系“万圈小助手”或发邮件到service@belightinnovation.com）。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fourLabel.mas_left);
            make.top.equalTo(sevenLabel1.mas_bottom).offset(kScaleX(5));
            make.right.equalTo(self.view).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
