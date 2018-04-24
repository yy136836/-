//
//  WQUpdatePopupwindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/5.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQUpdatePopupwindowView.h"

@implementation WQUpdatePopupwindowView {
    UILabel *contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinbanbenshangxian"]];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(135);
    }];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.userInteractionEnabled = YES;
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.masksToBounds = YES;
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(-5);
        make.width.offset(303);
        make.left.right.equalTo(imageView);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"新版本上线啦" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:18];
    textLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:18];
    [backgroundView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_top);
        make.left.equalTo(backgroundView.mas_left).offset(ghDistanceershi);
    }];
    
    UILabel *versionNumberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:13];
    self.versionNumberLabel = versionNumberLabel;
    versionNumberLabel.numberOfLines = 1;
    [backgroundView addSubview:versionNumberLabel];
    [versionNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(textLabel.mas_left);
    }];
    
    contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x777777] andFontSize:13];
    contentLabel.numberOfLines = 0;
    [backgroundView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionNumberLabel.mas_bottom).offset(25);
        make.left.equalTo(versionNumberLabel.mas_left);
        make.right.equalTo(backgroundView.mas_right).offset(-ghDistanceershi);
    }];
    
    UIButton *updateBtn = [[UIButton alloc] init];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    updateBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    updateBtn.layer.cornerRadius = 5;
    updateBtn.layer.masksToBounds = YES;
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.top.equalTo(contentLabel.mas_bottom).offset(35);
        make.size.mas_equalTo(CGSizeMake(260, ghCellHeight));
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [btn setTitle:@"稍后再说" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.top.equalTo(updateBtn.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(ghDistanceershi);
    }];
}

#pragma mark -- 立即更新的响应事件
- (void)updateBtnClick {
//    itms-apps://itunes.apple.com/cn/app/万圈-实名认证校友圈/id1195908226?mt=8
    NSURL *url = [NSURL URLWithString:@"itms://itunes.apple.com/cn/app/id1195908226?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -- 稍后再说的响应事件
- (void)btnClick {
    self.hidden = !self.hidden;
    // 获得时间对象
    NSDate *date = [NSDate date];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [forMatter stringFromDate:date];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dateStr forKey:@"dateStr"];
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    
    contentLabel.attributedText = [self getAttributedStringWithString:contentString lineSpace:8];
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
