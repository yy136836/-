//
//  WQmyDynamicTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmyDynamicTableViewCell.h"
#import "WQdynamicUserInformationView.h"
#import "WQdynamicContentView.h"
#import "WQLinksContentView.h"
#import "WQdynamicToobarView.h"

@interface WQmyDynamicTableViewCell () <WQdynamicUserInformationViewDelegate,WQdynamicToobarViewDelegate>

/**
 外链的view
 */
@property (nonatomic, strong) WQLinksContentView *linksContentView;

/**
 底部栏
 */
@property (nonatomic, strong) WQdynamicToobarView *toobarView;

@end

@implementation WQmyDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 栅格化  屏幕滚动时绘制成一张图像
        self.layer.shouldRasterize = YES;
        // 指定分辨率  默认分别率 * 1
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        // 异步绘制  cell 复杂的时候用
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 用户信息的view
    WQdynamicUserInformationView *userInformationView = [[WQdynamicUserInformationView alloc] init];
    userInformationView.delegate = self;
    self.userInformationView = userInformationView;
    [self.contentView addSubview:userInformationView];
    [userInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.height.offset(65);
    }];
    
    // 动态的view
    WQdynamicContentView *dynamicContentView = [[WQdynamicContentView alloc] init];
    self.dynamicContentView = dynamicContentView;
    [self.contentView addSubview:dynamicContentView];
    [dynamicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userInformationView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 外链的view
    WQLinksContentView *linksContentView = [[WQLinksContentView alloc] init];
    self.linksContentView = linksContentView;
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
        make.top.equalTo(dynamicContentView.mas_bottom).offset(ghStatusCellMargin);
        make.height.offset(60);
    }];
    
    // 底部栏
    WQdynamicToobarView *toobarView = [[WQdynamicToobarView alloc] init];
    toobarView.delegate = self;
    self.toobarView = toobarView;
    [self.contentView addSubview:toobarView];
    [toobarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linksContentView.mas_bottom);
        make.height.offset(60);
        make.bottom.left.right.equalTo(self.contentView);
    }];
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick {
    
}

@end
