//
//  WQSocialScienceInformationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSocialScienceInformationViewController.h"
#import "WQHasBeenRegisteredHeadPortraitCollectionViewCell.h"
#import "WQTsinghuaMBAView.h"
#import "WQAreNotView.h"
#import "WQSchoolOfSocialSciencesView.h"
#import "WQAddBasicInformationViewController.h"
#import "WQLoginClassListView.h"
#import "WQADegreeInListView.h"
#import "WQHasBeenRegisteredView.h"
#import "WQClassModel.h"
#import "WQHasJoinedWanQuanModel.h"
#import "WQNoneOfTheAboveModel.h"

static NSString *identifier = @"identifier";

@interface WQSocialScienceInformationViewController () <UICollectionViewDelegate,UICollectionViewDataSource,WQTsinghuaMBAViewDelegate,WQLoginClassListViewDelegate,WQSchoolOfSocialSciencesViewDelegate,WQADegreeInListViewDelegate,WQAreNotViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

/**
 小头像的数组
 */
@property (nonatomic, strong) NSArray *picArray;

/**
 班级id
 */
@property (nonatomic, copy) NSString *classIdString;

/**
 班级列表的view
 */
@property (nonatomic, strong) WQLoginClassListView *classListView;

/**
 我是清华MBA校友的view
 */
@property (nonatomic, strong) WQTsinghuaMBAView *tsinghuaMBAView;

/**
 社科学院的view
 */
@property (nonatomic, strong) WQSchoolOfSocialSciencesView *schoolOfSocialSciencesView;

/**
 学位的列表view
 */
@property (nonatomic, strong) WQADegreeInListView *aDegreeInListView;

/**
 当前注册人的view
 */
@property (nonatomic, strong) WQHasBeenRegisteredView *hasBeenRegisteredView;

/**
 以上都不是的view
 */
@property (nonatomic, strong) WQAreNotView *areNotView;

@end

@implementation WQSocialScienceInformationViewController {
    UILabel *hasBeenRegisteredLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self loadADegreeInList];
    [self loadHasJoinedListData];
}

#pragma mark -- 背景图的响应事件
- (void)backgroundImageViewClick {
    [self.view endEditing:YES];
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registeredbeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backgroundImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundImageViewClick)];
    [backgroundImageView addGestureRecognizer:backgroundImageViewTap];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"请选择您的MBA年级和班级" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:20];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.type == MBA) {
            make.top.equalTo(self.view).offset(kScaleX(165));
        }else if (self.type == SocialScience || self.type == AreNot) {
            make.top.equalTo(self.view).offset(kScaleX(100));
            textLabel.text = @"请选择您在社科学院的年级和班级";
        }
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    if (self.type == AreNot) {
        textLabel.text = @"添加最高教育经历";
    }
    
    // 多少人已经注册
    hasBeenRegisteredLabel = [UILabel labelWithText :@"名清华校友已实名认证" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.view addSubview:hasBeenRegisteredLabel];
    [hasBeenRegisteredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(ghDistanceershi));
    }];
    
    // 已注册人数头像
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    UITapGestureRecognizer *collectionViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewClick)];
    [collectionView addGestureRecognizer:collectionViewTap];
    collectionView.backgroundColor = [UIColor clearColor];
    // 禁止滑动
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WQHasBeenRegisteredHeadPortraitCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(hasBeenRegisteredLabel.mas_bottom).offset(kScaleX(12));
        make.size.mas_equalTo(CGSizeMake(kScaleY(120), kScaleX(25)));
    }];
    
    UIButton *nextStepBtn = [[UIButton alloc] init];
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    nextStepBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    nextStepBtn.layer.cornerRadius = 5;
    nextStepBtn.layer.masksToBounds = YES;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(45)));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(kScaleX(-80));
    }];
    
    if (self.type == MBA) {
        [WQDataSource sharedTool].isAreNot = NO;
        WQTsinghuaMBAView *tsinghuaMBAView = [[WQTsinghuaMBAView alloc] init];
        self.tsinghuaMBAView = tsinghuaMBAView;
        tsinghuaMBAView.userInteractionEnabled = YES;
        tsinghuaMBAView.delegate = self;
        [self.view addSubview:tsinghuaMBAView];
        [tsinghuaMBAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(collectionView.mas_bottom).offset(kScaleX(70));
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(nextStepBtn.mas_top);
        }];
    }else if (self.type == SocialScience) {
        [WQDataSource sharedTool].isAreNot = NO;
        WQSchoolOfSocialSciencesView *schoolOfSocialSciencesView = [[WQSchoolOfSocialSciencesView alloc] init];
        self.schoolOfSocialSciencesView = schoolOfSocialSciencesView;
        schoolOfSocialSciencesView.delegate = self;
        [self.view addSubview:schoolOfSocialSciencesView];
        [schoolOfSocialSciencesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(collectionView.mas_bottom).offset(kScaleX(70));
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(nextStepBtn.mas_top);
        }];
    }else if (self.type == AreNot) {
        [WQDataSource sharedTool].isAreNot = YES;
        WQAreNotView *areNotView = [[WQAreNotView alloc] init];
        self.areNotView = areNotView;
        [self.view addSubview:areNotView];
        [areNotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(collectionView.mas_bottom).offset(kScaleX(70));
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(nextStepBtn.mas_top);
        }];
        
        [areNotView setAreNotViewSelectedADegreeInBtnClickBlock:^{
            self.aDegreeInListView.hidden = !self.aDegreeInListView.hidden;
        }];
    }
    // 选择班级的列表
    WQLoginClassListView *classListView = [[WQLoginClassListView alloc] init];
    classListView.delegate = self;
    classListView.userInteractionEnabled = YES;
    self.classListView = classListView;
    classListView.hidden = YES;
    [self.view addSubview:classListView];
    [classListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScreenHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    // 选择学位的列表
    WQADegreeInListView *aDegreeInListView = [[WQADegreeInListView alloc] init];
    aDegreeInListView.delegate = self;
    self.aDegreeInListView = aDegreeInListView;
    aDegreeInListView.userInteractionEnabled = YES;
    aDegreeInListView.hidden = YES;
    [self.view addSubview:aDegreeInListView];
    [aDegreeInListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScreenHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    // 当前注册人的view
    WQHasBeenRegisteredView *hasBeenRegisteredView = [[WQHasBeenRegisteredView alloc] init];
    if (self.type == MBA) {
        hasBeenRegisteredView.type = MBAs;
    }else if (self.type == SocialScience) {
        hasBeenRegisteredView.type = SocialSciences;
    }else {
        hasBeenRegisteredView.type = AreNots;
    }

    self.hasBeenRegisteredView = hasBeenRegisteredView;
    hasBeenRegisteredView.hidden = YES;
    [self.view addSubview:hasBeenRegisteredView];
    [hasBeenRegisteredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(kScreenHeight);
    }];
}

#pragma mark -- 当前已注册人数的点击事件
- (void)collectionViewClick {
    self.hasBeenRegisteredView.hidden = !self.hasBeenRegisteredView.hidden;
}

#pragma mark -- WQTsinghuaMBAViewDelegate
// MBA校友的班级响应事件
- (void)wqSerialNumberBtnClick:(WQTsinghuaMBAView *)mbaView {
    self.classListView.hidden = !self.classListView.hidden;
}
// 开始时间和截止时间都有
- (void)wqMBADetermineTime:(WQTsinghuaMBAView *)mbaView {
    [self loadClassList:@""];
}

#pragma mark -- WQSchoolOfSocialSciencesViewDelegate
// 社科学院班级的响应事件
- (void)wqSchoolOfSocialSciencesSerialNumberBtnClick:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView {
    self.classListView.hidden = !self.classListView.hidden;
}
// 社科学院学位的响应事件
- (void)wqSchoolOfSocialSciencesSelectedADegreeInBtnClick:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView {
    self.aDegreeInListView.hidden = !self.aDegreeInListView.hidden;
}
// 开始时间和截止时间都有
- (void)wqSchoolOfSocialDetermineTime:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView {
    if (![schoolOfSocialSciencesView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![schoolOfSocialSciencesView.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text isEqualToString:@"请选择"]) {
        [self loadClassList:schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text];
    }
}

#pragma mark -- WQAreNotViewDelegate
//- (void)wqAreNotViewSelectedADegreeInBtnClick:(WQAreNotView *)areNotView {
//
//}

#pragma mark -- WQADegreeInListViewDelegate
// 学位列表的响应事件
- (void)wqADegreeInListViewdidSelectRowAtClick:(WQADegreeInListView *)aDegreeInListView titleString:(NSString *)titleString {
    self.aDegreeInListView.hidden = !self.aDegreeInListView.hidden;
    [self.schoolOfSocialSciencesView.selectedADegreeInBtn setTitle:titleString forState:UIControlStateNormal];
    [self.schoolOfSocialSciencesView.selectedADegreeInBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [self.areNotView.selectedADegreeInBtn setTitle:titleString forState:UIControlStateNormal];
    [self.areNotView.selectedADegreeInBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    
    if (![self.schoolOfSocialSciencesView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![self.schoolOfSocialSciencesView.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![self.schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text isEqualToString:@"请选择"]) {
        self.schoolOfSocialSciencesView.serialNumberBtn.hidden = NO;
        self.schoolOfSocialSciencesView.serialNumbersanjiaoBtn.hidden = NO;
        self.schoolOfSocialSciencesView.bottomLineView.hidden = NO;
        self.schoolOfSocialSciencesView.banjiLabel.hidden = NO;
    }
    [self loadClassList:self.schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text];
}

#pragma mark -- WQLoginClassListViewDelegate
// 班级列表的响应事件
- (void)wqTableviewdidSelectRowAtClick:(WQLoginClassListView *)classListView titleString:(NSString *)titleString classIdString:(NSString *)classIdString {
    self.classListView.hidden = !self.classListView.hidden;
    
    if (self.type == MBA) {
        [self.tsinghuaMBAView.serialNumberBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [self.tsinghuaMBAView.serialNumberBtn setTitle:titleString forState:UIControlStateNormal];
        self.classIdString = classIdString;
    }else if (self.type == SocialScience) {
        self.classIdString = classIdString;
        [self.schoolOfSocialSciencesView.serialNumberBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [self.schoolOfSocialSciencesView.serialNumberBtn setTitle:titleString forState:UIControlStateNormal];
    }
}

#pragma mark -- 下一步的响应事件
- (void)nextStepBtnClick {
    if (self.type == AreNot) {
        // 没有输入学校
        if (![self.areNotView.schoolTextField.text isVisibleString]) {
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:@"请输入学校" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        // 没有专业
        if (![self.areNotView.professionalTextField.text isVisibleString]) {
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:@"请输入专业" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        // 没有学位
//        if (![self.areNotView.aDegreeinTextField.text isVisibleString]) {
//            UIAlertController *alertVC = [UIAlertController
//                                          alertControllerWithTitle:@"提示!" message:@"请输入学位" preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alertVC animated:YES completion:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                });
//            }];
//            return;
//        }
    }
    // 没有选择开始时间
    if ([self.tsinghuaMBAView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] || [self.areNotView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] || [self.schoolOfSocialSciencesView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请选择开始时间" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }

    // 没有选择结束时间
    if ([self.tsinghuaMBAView.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"] || [self.areNotView.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] || [self.schoolOfSocialSciencesView.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请选择结束时间" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    // 没有选择班级
    if ([self.tsinghuaMBAView.serialNumberBtn.titleLabel.text isEqualToString:@"请选择"] || [self.schoolOfSocialSciencesView.serialNumberBtn.titleLabel.text isEqualToString:@"请选择"]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请选择班级" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    // 如果是清华社科学院的需要选择学位
    if (self.type == SocialScience || self.type == AreNot) {
        if ([self.schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text isEqualToString:@"请选择"] || [self.areNotView.selectedADegreeInBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:@"请选择学位" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
    }
    

    NSString *urlString = @"api/user/education/save";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    if (self.type == MBA) {
        params[@"starttime"] = self.tsinghuaMBAView.startTimeBtn.titleLabel.text;
        params[@"endtime"] = self.tsinghuaMBAView.daoqiTimeBtn.titleLabel.text;
        params[@"major"] = @"工商管理";
        params[@"degree"] = @(4);
        params[@"schoolname"] = @"清华大学";
        params[@"force"] = @"true";
    }else if (self.type == SocialScience) {
        params[@"starttime"] = self.schoolOfSocialSciencesView.startTimeBtn.titleLabel.text;
        params[@"endtime"] = self.schoolOfSocialSciencesView.daoqiTimeBtn.titleLabel.text;
        params[@"major"] = self.schoolOfSocialSciencesView.serialNumberBtn.titleLabel.text;
        NSString *aDegreeInString = self.schoolOfSocialSciencesView.selectedADegreeInBtn.titleLabel.text;
        NSInteger degree = 0;
        if ([aDegreeInString isEqualToString:@"中学及以下"]) {
            degree = 1;
        } else if ([aDegreeInString isEqualToString:@"大专"]) {
            degree = 2;
        } else if ([aDegreeInString isEqualToString:@"本科"]) {
            degree = 3;
        } else if ([aDegreeInString isEqualToString:@"硕士"]) {
            degree = 4;
        } else if ([aDegreeInString isEqualToString:@"博士"]) {
            degree = 5;
        }
        params[@"degree"] = @(degree);
        params[@"schoolname"] = @"清华大学";
        params[@"force"] = @"true";
    }else {
        params[@"starttime"] = self.areNotView.startTimeBtn.titleLabel.text;
        params[@"endtime"] = self.areNotView.daoqiTimeBtn.titleLabel.text;
        params[@"major"] = self.areNotView.professionalTextField.text;
        NSString *aDegreeInString = self.areNotView.selectedADegreeInBtn.titleLabel.text;
        NSInteger degree = 0;
        if ([aDegreeInString isEqualToString:@"中学及以下"]) {
            degree = 1;
        } else if ([aDegreeInString isEqualToString:@"大专"]) {
            degree = 2;
        } else if ([aDegreeInString isEqualToString:@"本科"]) {
            degree = 3;
        } else if ([aDegreeInString isEqualToString:@"硕士"]) {
            degree = 4;
        } else if ([aDegreeInString isEqualToString:@"博士"]) {
            degree = 5;
        }
        params[@"degree"] = @(degree);
        params[@"schoolname"] = self.areNotView.schoolTextField.text;
        params[@"force"] = @"true";
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        WQAddBasicInformationViewController *vc = [[WQAddBasicInformationViewController alloc] init];
        vc.isInviteCode = NO;
        vc.class_idString = self.classIdString;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
//    WQAddBasicInformationViewController *vc = [[WQAddBasicInformationViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 获取已加入万圈数据
- (void)loadHasJoinedListData {
    NSString *urlString = @"api/plugin/alumnus/querystudentlist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type == MBA) {
        params[@"gid"] = @"cb5526d70ce744cda5d1cf4739f07728";
    }else {
        params[@"gid"] = @"77237a158f46420c90430350768bb754";
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
        
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"已有"
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x878787]}]];
        
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"student_count"]]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x844dc5]}]];
        if (self.type == MBA) {
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"名MBA同学加入万圈,其中有 :"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x878787]}]];
        }else if (self.type == SocialScience) {
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"名社科同学加入万圈,其中有 :"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x878787]}]];
        }else {
            [self loadData];
        }
        
        hasBeenRegisteredLabel.attributedText = str;
        
        self.hasBeenRegisteredView.presonCount = response[@"student_count"];
        
        self.hasBeenRegisteredView.modelDataArray = [NSArray yy_modelArrayWithClass:[WQHasJoinedWanQuanModel class] json:response[@"students"]];
        
        self.picArray = [self.hasBeenRegisteredView.modelDataArray subarrayWithRange:NSMakeRange(0, 5)];
        
        [self.collectionView reloadData];
    }];
}

#pragma mark -- 获取班级列表数据
- (void)loadClassList:(NSString *)aDegreeInString {
    NSString *urlString = @"api/plugin/alumnus/queryclasslist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type == MBA) {
        params[@"gid"] = @"cb5526d70ce744cda5d1cf4739f07728";
        // 入学时间
        params[@"starttime"] = self.tsinghuaMBAView.startTimeBtn.titleLabel.text;
        // 截止时间
        params[@"endtime"] = self.tsinghuaMBAView.daoqiTimeBtn.titleLabel.text;
        params[@"auto_append_other_class"] = @"true";
    }else {
        params[@"gid"] = @"77237a158f46420c90430350768bb754";
        // 入学时间
        params[@"starttime"] = self.schoolOfSocialSciencesView.startTimeBtn.titleLabel.text;
        // 截止时间
        params[@"endtime"] = self.schoolOfSocialSciencesView.daoqiTimeBtn.titleLabel.text;
        params[@"auto_append_other_class"] = @"true";
        NSString *degree;
        if ([aDegreeInString isEqualToString:@"中学及以下"]) {
            //degree = @"中学及以下";
        } else if ([aDegreeInString isEqualToString:@"大专"]) {
            //degree = @"大专";
        } else if ([aDegreeInString isEqualToString:@"本科"]) {
            degree = @"本科";
        } else if ([aDegreeInString isEqualToString:@"硕士"]) {
            degree = @"硕士";
        } else if ([aDegreeInString isEqualToString:@"博士"]) {
            degree = @"博士";
        }
        params[@"degree"] = degree;
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        self.classListView.dataArray = [NSArray yy_modelArrayWithClass:[WQClassModel class] json:response[@"classes"]];
    }];
}

#pragma mark -- 获取学位列表数据
- (void)loadADegreeInList {
    NSString *urlString = @"api/plugin/alumnus/querydegreelist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gid"] = @"77237a158f46420c90430350768bb754";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        if (self.type == AreNot) {
            NSArray *array = @[@"本科",@"硕士",@"博士"];
            self.aDegreeInListView.ADegreeInDataArray = array;
        }else {
            self.aDegreeInListView.ADegreeInDataArray = response[@"degrees"];
        }
    }];
}

#pragma mark -- 获取注册人数
- (void)loadData {
    NSString *urlString = @"api/system/init";
    NSDictionary *params = [[NSDictionary alloc] init];
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
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
            
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"已有"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x878787]}]];
            
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"user_count"]]
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x844dc5]}]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"名校友加入万圈,其中有 :"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x878787]}]];
            
            hasBeenRegisteredLabel.attributedText = str;
            
            self.hasBeenRegisteredView.presonCount = response[@"user_count"];
            self.hasBeenRegisteredView.noneOfTheAboveArray = [NSArray yy_modelArrayWithClass:[WQNoneOfTheAboveModel class] json:response[@"user_list"]];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == AreNot) {
        return self.hasBeenRegisteredView.noneOfTheAboveArray.count;
    }else {
        return self.picArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQHasBeenRegisteredHeadPortraitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.type == AreNot) {
        cell.noneOfTheAboveModel = self.hasBeenRegisteredView.noneOfTheAboveArray[indexPath.item];
    }else {
        cell.model = self.picArray[indexPath.item];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScaleY(25), kScaleX(25));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kScaleY(-5);
}

@end
