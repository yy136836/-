//
//  WQdemaadnforHairview.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQdemaadnforHairview.h"
#import "WQpublishViewController.h"
#import "WQImageCollectionViewCell.h"
#import "WQTextField.h"
#import "WQPhotoBrowser.h"

static NSString *cellid = @"cellid";

@interface WQdemaadnforHairview () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineViewTwo;
@property (nonatomic, strong) UIView *separatedLineView;
@property (nonatomic, strong) UIView *separatedBottomLineView;
@property (nonatomic, strong) UIButton *recommendedBtn;
@property (nonatomic, strong) UIButton *consultingBtn;
@property (nonatomic, strong) UIImageView *writingImageView;
@property (nonatomic, strong) UIImageView *writingTwoImageView;

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *jiedanrenplaceholderLabel;

@end

@implementation WQdemaadnforHairview {
    NSArray <UIButton *>*_btnArray;
    NSArray <UIButton *>*_imageBtnArray;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupUI];
//        self.backgroundColor = [UIColor colorWithHex:0xededed];
//    }
//    return self;
//}


- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleString = titleString;
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 背景白色View
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(50);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:0];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WQImageCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    
    UILabel *placeholderLabel = [UILabel labelWithText:@"请在此输入需要发布内容" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    self.placeholderLabel = placeholderLabel;
    placeholderLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:14];
    
    UILabel *jiedanrenplaceholderLabel = [UILabel labelWithText:@"对接需求者的资质要求" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    self.jiedanrenplaceholderLabel = jiedanrenplaceholderLabel;
    jiedanrenplaceholderLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:14];
    
    // 帮忙
    if ([self.titleString isEqualToString:@"帮忙 "]) {
        //标题输入框
        UILabel *headlineLabel = [[UILabel alloc] init];
        headlineLabel.text = @"【帮忙】";
        headlineLabel.textColor = [UIColor colorWithHex:0X333333];
        headlineLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:headlineLabel];
        [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.left.equalTo(self).offset(ghSpacingOfshiwu-8);
            make.width.offset(62);
        }];
        
        WQTextField *headlineTextField = [[WQTextField alloc] initWithTitleType:bangzhu];
        self.headlineTextField = headlineTextField;
        headlineTextField.placeholder = @"请勿超过16个字";
        [headlineTextField setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [headlineTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        headlineTextField.delegate = self;
        [self addSubview:headlineTextField];
        headlineTextField.backgroundColor = [UIColor whiteColor];
        [headlineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self).offset(0.5);
            make.height.offset(44);
            make.left.equalTo(headlineLabel.mas_right);
        }];
        
        
        self.lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headlineTextField.mas_bottom);
            make.right.equalTo(self);
            make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
            make.height.offset(0.5);
        }];
        
        // 选填的约定时间
        UITextField *timeTextFieid = [[UITextField alloc] init];
        timeTextFieid.backgroundColor = [UIColor whiteColor];
        self.timeTextFieid = timeTextFieid;
        timeTextFieid.placeholder = @"约定时间 (选填)";
        [timeTextFieid setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        [timeTextFieid setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:timeTextFieid];
        [timeTextFieid mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(44);
            make.top.equalTo(self.lineView.mas_bottom);
            make.right.equalTo(self);
            make.left.mas_equalTo(ghSpacingOfshiwu);
        }];
        
        self.lineViewTwo.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [self addSubview:self.lineViewTwo];
        [self.lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeTextFieid.mas_bottom);
            make.right.equalTo(self);
            make.left.mas_equalTo(ghSpacingOfshiwu);
            make.height.offset(0.5);
        }];
        
        // 选填的约定地点
        UITextField *placeTextField = [[UITextField alloc] init];
        self.placeTextField = placeTextField;
        placeTextField.backgroundColor = [UIColor whiteColor];
        placeTextField.placeholder = @"约定地点 (选填)";
        [placeTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        [placeTextField setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:placeTextField];
        [placeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineViewTwo.mas_bottom);
            make.height.offset(44);
            make.right.equalTo(self);
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
        }];
        
        self.separatedLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedLineView];
        [self.separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(placeTextField.mas_bottom);
            make.height.offset(ghStatusCellMargin);
        }];
        
        //输入内容的text
        UITextView *contentTextView = [[UITextView alloc]init];
        contentTextView.delegate = self;
        self.contentTextView = contentTextView;
        contentTextView.placeholderColor = [UIColor colorWithHex:0x999999];
        contentTextView.placeholder = @"请输入需求描述（请尽量详细的描述您的需求，能够增大他人帮助您的几率）";
        [contentTextView setFont:[UIFont systemFontOfSize:15]];
        contentTextView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentTextView];
        contentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0,0);//设置页边距
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self).offset(ghStatusCellMargin);
            make.top.equalTo(self.separatedLineView.mas_bottom).offset(13);
            make.height.offset(120);
        }];
        
//        [contentTextView addSubview:self.writingImageView];
//        [self.writingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(17, 17));
//            make.left.equalTo(contentTextView).offset(6);
//            make.top.equalTo(contentTextView.mas_top).offset(ghStatusCellMargin);
//        }];
//
//        [contentTextView addSubview:placeholderLabel];
//        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.writingImageView.mas_bottom);
//            make.left.equalTo(self.writingImageView.mas_right).offset(2);
//        }];
        
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentTextView.mas_right).offset(-25);
            make.bottom.equalTo(contentTextView.mas_bottom).offset(kScaleX(30));
            //make.width.offset(20);
            //make.height.offset(17);
        }];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addImage.mas_bottom).offset(5);
            make.right.equalTo(addImage.mas_left).offset(-10);
            make.height.offset(37);
            make.width.offset(98);
        }];
        
        self.separatedBottomLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedBottomLineView];
        [self.separatedBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
        }];
    }
    // BBS
    if ([self.titleString isEqualToString:@"BBS "]) {
        
        UIImageView *fontBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gulibeijing"]];
        fontBackground.backgroundColor = [UIColor whiteColor];
        [self addSubview:fontBackground];
        [fontBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.left.right.top.equalTo(self);
        }];
        
        UILabel *fontLabel = [UILabel labelWithText:@"用户发需求时可选择红包人数；用户阅读此订单超过5秒，则有权领取您设定的红包" andTextColor:[UIColor colorWithHex:0x75a8eb] andFontSize:13];
        fontLabel.numberOfLines = 2;
        [self addSubview:fontLabel];
        [fontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.height.mas_equalTo(60);
        }];
        
        UIView *separatedView = [[UIView alloc] init];
        separatedView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:separatedView];
        [separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            make.left.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
        }];
        
        //标题输入框
        UILabel *headlineLabel = [[UILabel alloc] init];
        headlineLabel.text = @"【BBS】";
        headlineLabel.textColor = [UIColor colorWithHex:0X333333];
        headlineLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:headlineLabel];
        [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(separatedView.mas_bottom).offset(12);
            make.left.equalTo(self).offset(ghSpacingOfshiwu-8);
            make.width.offset(60);
        }];
        
        WQTextField *headlineTextField = [[WQTextField alloc] initWithTitleType:BBS];
        self.headlineTextField = headlineTextField;
        headlineTextField.placeholder = @"请勿超过16个字";
        [headlineTextField setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [headlineTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        headlineTextField.delegate = self;
        [self addSubview:headlineTextField];
        headlineTextField.backgroundColor = [UIColor whiteColor];
        [headlineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(headlineLabel.mas_centerY).offset(2);
            make.height.offset(44);
            make.left.equalTo(headlineLabel.mas_right);
        }];
        
        self.separatedLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedLineView];
        [self.separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ghStatusCellMargin);
            make.left.right.equalTo(self);
            make.top.equalTo(headlineTextField.mas_bottom).offset(-3);
        }];
        
        //输入内容的text
        UITextView *contentTextView = [[UITextView alloc]init];
        contentTextView.delegate = self;
        self.contentTextView = contentTextView;
        contentTextView.placeholder = @"请输入需求描述（请尽量详细的描述您的需求，能够增大他人帮助您的几率）";
        contentTextView.placeholderColor = UIColorWithHex16_(0x999999);
        [contentTextView setFont:[UIFont systemFontOfSize:15]];
        contentTextView.backgroundColor = [UIColor whiteColor];
        contentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0,0);//设置页边距
        [self addSubview:contentTextView];
        
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self).offset(ghStatusCellMargin);
            make.top.equalTo(self.separatedLineView.mas_bottom).offset(13);
            make.height.offset(120);
        }];
        
        
//        [contentTextView addSubview:self.writingImageView];
//        [self.writingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(17, 17));
//            make.left.equalTo(contentTextView.mas_left).offset(6);
//            make.top.equalTo(contentTextView.mas_top).offset(ghStatusCellMargin);
//        }];
//
//
//        [contentTextView addSubview:placeholderLabel];
//        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.writingImageView.mas_bottom);
//            make.left.equalTo(self.writingImageView.mas_right).offset(2);
//        }];
        
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentTextView.mas_right).offset(-25);
            make.bottom.equalTo(contentTextView.mas_bottom).offset(kScaleX(30));
            //make.width.offset(20);
            //make.height.offset(17);
        }];

        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addImage.mas_bottom).offset(5);
            make.right.equalTo(addImage.mas_left).offset(-10);
            make.height.offset(37);
            make.width.offset(98);
        }];
        
        self.separatedBottomLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedBottomLineView];
        [self.separatedBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
        }];
    }
    
    // 问事
    if ([self.titleString isEqualToString:@"问事 "]) {
        
        // 背景view
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.offset(47);
        }];
        
        //标题输入框
        UILabel *headlineLabel = [[UILabel alloc] init];
        headlineLabel.text = @"【问事】";
        headlineLabel.textColor = [UIColor colorWithHex:0X333333];
        headlineLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:headlineLabel];
        [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(ghSpacingOfshiwu-8);
            make.width.offset(62);
        }];
        
        // 求推荐
        UIButton *recommendedBtn = [UIButton setNormalTitle:@"求推荐" andNormalColor:[UIColor whiteColor] andFont:12];
        self.recommendedBtn = recommendedBtn;
        recommendedBtn.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        recommendedBtn.layer.cornerRadius = 10;
        recommendedBtn.layer.masksToBounds = YES;
        [recommendedBtn setBackgroundColor:WQ_LIGHT_PURPLE];
        [view addSubview:recommendedBtn];
        // 咨询
        UIButton *consultingBtn = [UIButton setNormalTitle:@"咨询" andNormalColor:[UIColor colorWithHex:0x777777] andFont:12];
        self.consultingBtn = consultingBtn;
        consultingBtn.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        consultingBtn.layer.cornerRadius = 10;
        consultingBtn.layer.masksToBounds = YES;
        [consultingBtn setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
        [view addSubview:consultingBtn];
        
        NSArray *btnArray = @[recommendedBtn,consultingBtn];
        //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
        [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(33) leadSpacing:kScaleX(85) tailSpacing:kScaleX(85)
         ];
        [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headlineLabel.mas_centerY);
            make.width.offset(68);
        }];
        
        self.lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [view addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom);
            make.right.equalTo(self);
            make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
            make.height.offset(0.5);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.text = @"求推荐";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ghSpacingOfshiwu);
            make.top.equalTo(self.lineView.mas_bottom).offset(13);
            make.width.offset(50);
        }];
        
        WQTextField *headlineTextField = [[WQTextField alloc] initWithTitleType:wenshi];
        self.headlineTextField = headlineTextField;
        headlineTextField.delegate = self;
        headlineTextField.placeholder = @"请勿超过13个字";
        headlineTextField.backgroundColor = [UIColor whiteColor];
        [headlineTextField setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [headlineTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:headlineTextField];
        [headlineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.height.offset(44);
            make.top.equalTo(self.lineView.mas_bottom);
            make.left.equalTo(label.mas_right);
        }];
        
        __weak typeof(recommendedBtn) weakRecommendedBtn = recommendedBtn;
        __weak typeof(consultingBtn) weakConsultingBtn = consultingBtn;
        [recommendedBtn addClickAction:^(UIButton * _Nullable sender) {
            [weakRecommendedBtn setBackgroundColor:WQ_LIGHT_PURPLE];
            [weakRecommendedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [consultingBtn setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
            [consultingBtn setTitleColor:[UIColor colorWithHex:0x777777] forState:UIControlStateNormal];
            //headlineTextField.text = @"求推荐";
            label.text = @"求推荐";
            headlineTextField.placeholder = @"请勿超过13个字";
        }];
    
        [weakConsultingBtn addClickAction:^(UIButton * _Nullable sender) {
            [weakRecommendedBtn setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
            [weakRecommendedBtn setTitleColor:[UIColor colorWithHex:0x777777] forState:UIControlStateNormal];
            [weakConsultingBtn setBackgroundColor:[UIColor colorWithHex:0x9767D0]];
            [weakConsultingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //headlineTextField.text = @"咨询";
            label.text = @"咨询";
            headlineTextField.placeholder = @"请勿超过14个字";
        }];
        
        self.separatedLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedLineView];
        [self.separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
            make.top.equalTo(headlineTextField.mas_bottom);
        }];

        //输入内容的text
        UITextView *contentTextView = [[UITextView alloc]init];
        contentTextView.delegate = self;
        self.contentTextView = contentTextView;
        [contentTextView setFont:[UIFont systemFontOfSize:15]];
        contentTextView.placeholder = @"请输入需求描述（请尽量详细的描述您的需求，能够增大他人帮助您的几率）";
        contentTextView.placeholderColor = UIColorWithHex16_(0x999999);
        contentTextView.backgroundColor = [UIColor whiteColor];
        contentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0,0);//设置页边距
        [self addSubview:contentTextView];
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self);
            make.top.equalTo(self.separatedLineView.mas_bottom).offset(13);
            make.height.offset(120);
        }];
        
        
//        [contentTextView addSubview:self.writingImageView];
//        [self.writingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(17, 17));
//            make.left.equalTo(contentTextView.mas_left).offset(6);
//            make.top.equalTo(contentTextView.mas_top).offset(ghStatusCellMargin);
//        }];
//
        
        
        
        
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentTextView.mas_right).offset(-25);
            make.bottom.equalTo(contentTextView.mas_bottom).offset(kScaleX(30));
            //make.width.offset(20);
            //make.height.offset(17);
        }];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addImage.mas_bottom).offset(5);
            make.right.equalTo(addImage.mas_left).offset(-10);
            make.height.offset(37);
            make.width.offset(98);
        }];
        
//        [contentTextView addSubview:placeholderLabel];
//        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.writingImageView.mas_bottom);
//            make.left.equalTo(self.writingImageView.mas_right).offset(2);
//        }];
        self.separatedBottomLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedBottomLineView];
        [self.separatedBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
            make.top.equalTo(self.collectionView.mas_bottom).offset(kScaleX(12));
        }];
        
        // 资质要求
        UITextView *qualificationTextView = [[UITextView alloc] init];
        self.qualificationTextView = qualificationTextView;
        qualificationTextView.delegate = self;
        qualificationTextView.placeholderColor = [UIColor colorWithHex:0x999999];
        [qualificationTextView setFont:[UIFont systemFontOfSize:14]];
        qualificationTextView.backgroundColor = [UIColor whiteColor];
        [self addSubview:qualificationTextView];
        
        

        [qualificationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
            make.right.equalTo(self);
            make.left.equalTo(self).offset(ghStatusCellMargin+1);
            make.top.equalTo(self.separatedBottomLineView.mas_bottom);
        }];
        
        UIImageView *writingTwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
        self.writingTwoImageView = writingTwoImageView;
        [qualificationTextView addSubview:writingTwoImageView];
        [writingTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 17));
            make.left.equalTo(qualificationTextView.mas_left).offset(6);
            make.top.equalTo(qualificationTextView.mas_top).offset(ghStatusCellMargin);
        }];
        
        [qualificationTextView addSubview:self.jiedanrenplaceholderLabel];
        [self.jiedanrenplaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(writingTwoImageView.mas_right).offset(2);
            make.bottom.equalTo(writingTwoImageView.mas_bottom);
        }];
        
        
        
        
        
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ghStatusCellMargin);
            make.left.right.equalTo(self);
            make.top.equalTo(qualificationTextView.mas_bottom);
        }];
    }
    
    if ([self.titleString isEqualToString:@"找人 "]) {
        //标题输入框
        UILabel *headlineLabel = [[UILabel alloc] init];
        headlineLabel.text = @"【找人】";
        headlineLabel.textColor = [UIColor colorWithHex:0X333333];
        headlineLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:headlineLabel];
        [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu-8);
            make.width.offset(62);
            make.height.offset(44);
        }];
        
        UILabel *introduceLabel = [UILabel labelWithText:@"求介绍" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
        [self addSubview:introduceLabel];
        introduceLabel.backgroundColor = [UIColor whiteColor];
        [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headlineLabel.mas_centerY);
            make.left.equalTo(headlineLabel.mas_right).offset(ghStatusCellMargin);
            make.height.offset(44);

        }];
        
        WQTextField *headlineTextField = [[WQTextField alloc] initWithTitleType:zhaoren];
        self.headlineTextField = headlineTextField;
        headlineTextField.placeholder = @"请勿超过13个字";
        [headlineTextField setValue:[UIFont fontWithName:@".PingFangSC-Regular" size:14] forKeyPath:@"_placeholderLabel.font"];
        [headlineTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
        headlineTextField.delegate = self;

        [self addSubview:headlineTextField];
        headlineTextField.backgroundColor = [UIColor whiteColor];
        [headlineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(introduceLabel.mas_right).offset(ghStatusCellMargin);
            make.right.equalTo(self);
            make.centerY.equalTo(headlineLabel.mas_centerY);
            make.height.offset(44);
        }];
        
        self.separatedLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedLineView];
        [self.separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ghStatusCellMargin);
            make.left.right.equalTo(self);
            make.top.equalTo(headlineTextField.mas_bottom).offset(5);
        }];

        //输入内容的text
        UITextView *contentTextView = [[UITextView alloc]init];
        contentTextView.delegate = self;
        self.contentTextView = contentTextView;
        contentTextView.placeholder = @"请输入需求描述（请尽量详细的描述您的需求，能够增大他人帮助您的几率）";
        contentTextView.placeholderColor = UIColorWithHex16_(0x999999);
        [contentTextView setFont:[UIFont systemFontOfSize:15]];
        contentTextView.backgroundColor = [UIColor whiteColor];
        contentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0,0);//设置页边距

        [self addSubview:contentTextView];
                
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self).offset(ghStatusCellMargin);
            make.top.equalTo(self.separatedLineView.mas_bottom).offset(13);
            make.height.offset(120);
        }];
        
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentTextView.mas_right).offset(-25);
            make.bottom.equalTo(contentTextView.mas_bottom).offset(kScaleX(30));
            //make.width.offset(20);
            //make.height.offset(17);
        }];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addImage.mas_bottom).offset(5);
            make.right.equalTo(addImage.mas_left).offset(-10);
            make.height.offset(37);
            make.width.offset(98);
        }];
        
        self.separatedBottomLineView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:self.separatedBottomLineView];
        [self.separatedBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
            make.top.equalTo(self.collectionView.mas_bottom).offset(kScaleX(12));
        }];
        
        UILabel *tagLabel = [UILabel labelWithText:@"接单者完成要求 (可多选)" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
        [self addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
            make.top.equalTo(self.separatedBottomLineView.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        UIButton *contactBtn = [UIButton setNormalTitle:@"提供联系方式" andNormalColor:[UIColor colorWithHex:0x777777] andFont:12];
        self.contactBtn = contactBtn;
        contactBtn.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        contactBtn.layer.cornerRadius = 10;
        contactBtn.layer.masksToBounds = YES;
        [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [contactBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0xf9f9f9]] forState:UIControlStateNormal];
        [contactBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0x9767d0]] forState:UIControlStateSelected];
        [self addSubview:contactBtn];
        [contactBtn addClickAction:^(UIButton * _Nullable sender) {
            sender.selected = !sender.selected;
        }];
        
        UIButton *facilitateBtn = [UIButton setNormalTitle:@"帮助牵线" andNormalColor:[UIColor colorWithHex:0x777777] andFont:12];
        self.facilitateBtn = facilitateBtn;
        facilitateBtn.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        facilitateBtn.layer.cornerRadius = 10;
        facilitateBtn.layer.masksToBounds = YES;
        [facilitateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [facilitateBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0xf9f9f9]] forState:UIControlStateNormal];
        [facilitateBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0x9767d0]] forState:UIControlStateSelected];
        [self addSubview:facilitateBtn];
        [facilitateBtn addClickAction:^(UIButton * _Nullable sender) {
            sender.selected = !sender.selected;
        }];
        
        UIButton *arrangeBtn = [UIButton setNormalTitle:@"安排见面" andNormalColor:[UIColor colorWithHex:0x777777] andFont:12];
        self.arrangeBtn = arrangeBtn;
        arrangeBtn.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        arrangeBtn.layer.cornerRadius = 10;
        arrangeBtn.layer.masksToBounds = YES;
        [arrangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [arrangeBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0xf9f9f9]] forState:UIControlStateNormal];
        [arrangeBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0x9767d0]] forState:UIControlStateSelected];
        [self addSubview:arrangeBtn];
        [arrangeBtn addClickAction:^(UIButton * _Nullable sender) {
            sender.selected = !sender.selected;
        }];
        
        NSArray *btnArray = @[contactBtn,facilitateBtn,arrangeBtn];
        //两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
        [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(ghStatusCellMargin) leadSpacing:kScaleX(ghStatusCellMargin) tailSpacing:kScaleX(ghStatusCellMargin)
         ];
        [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tagLabel.mas_bottom).offset(ghStatusCellMargin);
            make.height.offset(26);
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(ghStatusCellMargin);
            make.top.equalTo(arrangeBtn.mas_bottom).offset(17);
        }];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.headlineTextField.text.length -1 == 18) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"标题最多可以输入18个字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return NO;
    }else{
        return YES;
    }
}*/

#pragma mark - 响应事件
- (void)addImage {
    if (self.imageArray.count >= 2) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请勿选超过2张图片" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    [BDImagePicker showImagePickerFromViewController:self.viewController allowsEditing:NO finishAction:^(UIImage *image) {
        if (image != nil) {
            [self.imageArray addObject:image];
            if (self.imageArray.count == 2) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(98);
                }];
            }else if (self.imageArray.count == 1) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(49);
                }];
            }else {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(0);
                }];
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.headlineTextField endEditing:YES];
    [self.contentTextView endEditing:YES];
}

#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    if (textView == self.contentTextView) {
        if (changedString.length != 0) {
            self.writingImageView.hidden = YES;
            self.placeholderLabel.hidden = YES;
        }else{
            self.writingImageView.hidden = NO;
            self.placeholderLabel.hidden = NO;
        }
    }else {
        if (changedString.length != 0) {
            self.writingTwoImageView.hidden = YES;
            //self.placeholderLabel.hidden = YES;
            self.jiedanrenplaceholderLabel.hidden = YES;
        }else{
            self.writingTwoImageView.hidden = NO;
            //self.placeholderLabel.hidden = NO;
            self.jiedanrenplaceholderLabel.hidden = NO;
        }
    }
    
    return YES;
}

#pragma mark - collectionViewdataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.imageView.image = self.imageArray[indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    
    [cell setImageClilcBlock:^{
        if (weakCell.viewController.navigationController) {
            WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
            browser .currentPhotoIndex = indexPath.row;
            browser.alwaysShowControls = NO;
            browser.displayActionButton = NO;
            browser.shouldTapBack = YES;
            browser.shouldHideNavBar = YES;
            [weakCell.viewController.navigationController pushViewController:browser animated:YES];
        }
    }];
    
    [cell setDeleteImageBlock:^{
        if (indexPath.item == 0) {
            [weakSelf.imageArray removeObjectAtIndex:0];
            if (self.imageArray.count == 2) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(98);
                }];
            }else if (self.imageArray.count == 1) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(49);
                }];
            }else {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(0);
                }];
            }
            [collectionView reloadData];
        }else{
            [weakSelf.imageArray removeObjectAtIndex:1];
            if (self.imageArray.count == 2) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(98);
                }];
            }else if (self.imageArray.count == 1) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(49);
                }];
            }else {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(0);
                }];
            }
            [collectionView reloadData];
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(44, 44);
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imageArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto * photo = [MWPhoto photoWithImage:self.imageArray[index]];
    
    return photo;
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField {
    _titlenil = textField.hasText;
    if (textField.text.length > 18) {
        _fontLength = NO;
    }else{
        _fontLength = YES;
    }
}

#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _contentnil = textView.hasText;
}

#pragma mark- 懒加载

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSString *)titleString {
    if (!_titleString) {
        _titleString = [[NSString alloc] init];
    }
    return _titleString;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (UIView *)lineViewTwo {
    if (!_lineViewTwo) {
        _lineViewTwo = [[UIView alloc] init];
    }
    return _lineViewTwo;
}

- (UIView *)separatedLineView {
    if (!_separatedLineView) {
        _separatedLineView = [[UIView alloc] init];
    }
    return _separatedLineView;
}

- (UIView *)separatedBottomLineView {
    if (!_separatedBottomLineView) {
        _separatedBottomLineView = [[UIView alloc] init];
    }
    return _separatedBottomLineView;
}

- (UIImageView *)writingImageView {
    if (!_writingImageView) {
        _writingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
    }
    return _writingImageView;
}

@end
