//
//  WQLearningexperienceViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/19.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQLearningexperienceViewController.h"

@interface WQLearningexperienceViewController ()

@end

@implementation WQLearningexperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)setupUI
{
    UILabel *biographicalLabel = [UILabel new];
    biographicalLabel.text = @"简历";
    [self.view addSubview:biographicalLabel];
    biographicalLabel.font = [UIFont systemFontOfSize:13];
    biographicalLabel.textColor = [UIColor colorWithHex:0X7b7b7b];
    [biographicalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view.mas_left).offset(17);
    }];
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor colorWithHex:0Xffffff];
    leftView.layer.borderWidth= 1.0f;
    leftView.layer.borderColor= [UIColor colorWithHex:0Xdcdcdc].CGColor;
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.right.equalTo(self.view).offset(-17);
        make.width.offset(1);
        make.top.equalTo(biographicalLabel.mas_bottom).offset(10);
        make.height.offset(180);
    }];
    
    UIView *oneview = [UIView new];
    oneview.backgroundColor = [UIColor colorWithHex:0Xdcdcdc];
    [self.view addSubview:oneview];
    [oneview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(leftView.mas_top).offset(45);
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
    }];
    
    UIView *towview = [UIView new];
    towview.backgroundColor = [UIColor colorWithHex:0Xdcdcdc];
    [self.view addSubview:towview];
    [towview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(oneview.mas_bottom).offset(45);
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
    }];
    
    UIView *threeview = [UIView new];
    threeview.backgroundColor = [UIColor colorWithHex:0Xdcdcdc];
    [self.view addSubview:threeview];
    [threeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(towview.mas_bottom).offset(45);
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
    }];
    
    //编辑
    UIButton *editBtn = [UIButton new];
    //编辑
    UIButton *onceditBtn = [UIButton new];
    //编辑
    UIButton *twoeditBtn = [UIButton new];
    //学历
    UIButton *recordBtn = [UIButton new];
    //工作经验
    UIButton *workBtn = [UIButton new];
    
    [editBtn setTitle:@"编辑" forState:0];
    [onceditBtn setTitle:@"编辑" forState:0];
    [twoeditBtn setTitle:@"编辑" forState:0];
    [recordBtn setTitle:@"添加学历" forState:0];
    [workBtn setTitle:@"添加工作经验" forState:0];
    
    [editBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    [onceditBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    [twoeditBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    [workBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    onceditBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    twoeditBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    workBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    [leftView addSubview:editBtn];
    [leftView addSubview:recordBtn];
    [leftView addSubview:workBtn];
    [leftView addSubview:onceditBtn];
    [leftView addSubview:twoeditBtn];

    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView.mas_top).offset(12);
        make.right.equalTo(leftView.mas_right).offset(-15);
        make.width.offset(30);
    }];
    [onceditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneview.mas_top).offset(12);
        make.right.equalTo(leftView.mas_right).offset(-15);
        make.width.offset(30);
    }];
    [twoeditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(towview.mas_top).offset(12);
        make.right.equalTo(leftView.mas_right).offset(-15);
        make.width.offset(30);
    }];
    
    [workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_left).offset(40);
        make.top.equalTo(threeview.mas_bottom).offset(10);
    }];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeview.mas_bottom).offset(10);
        make.right.equalTo(leftView.mas_right).offset(-30);
    }];
    
    //学历1
    UILabel *onclabel = [UILabel new];
    onclabel.text = @"学校";
    onclabel.textColor = [UIColor colorWithHex:0Xa550d6];
    onclabel.font = [UIFont systemFontOfSize:13];
    [leftView addSubview:onclabel];
    [onclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView.mas_top).offset(14);
        make.left.equalTo(leftView.mas_left).offset(15);
    }];
    
    //学历2
    UILabel *twoLabel = [UILabel new];
    twoLabel.text = @"学位";
    twoLabel.textColor = [UIColor colorWithHex:0Xa550d6];
    twoLabel.font = [UIFont systemFontOfSize:13];
    [leftView addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneview.mas_top).offset(14);
        make.left.equalTo(leftView.mas_left).offset(15);
    }];
    
    //工作经验
    UILabel *runningLabel = [UILabel new];
    runningLabel.text = @"专业";
    runningLabel.textColor = [UIColor colorWithHex:0Xa550d6];
    runningLabel.font = [UIFont systemFontOfSize:13];
    [leftView addSubview:runningLabel];
    [runningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(towview.mas_top).offset(14);
        make.left.equalTo(leftView.mas_left).offset(15);
    }];
    
    //下一步
    UIButton *denglu = [UIButton new];
    denglu.backgroundColor = [UIColor colorWithHex:0Xa550d6];
    [denglu setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:denglu];
    [denglu addTarget:self action:@selector(xybbtnClike) forControlEvents:UIControlEventTouchUpInside];
    [denglu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(45);
        make.top.equalTo(leftView.mas_bottom).offset(17);
    }];
    //提示
    UILabel *perfectLabel = [[UILabel alloc]init];
    [self.view addSubview:perfectLabel];
    perfectLabel.font = [UIFont systemFontOfSize:13];
    perfectLabel.text = @"提示: 更完善的信息使您获得更高的信用分数和更精确的服务";
    [perfectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(denglu.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)xybbtnClike
{
    
}

@end
