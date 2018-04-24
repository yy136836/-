//
//  WQEssenceSharePopController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssenceSharePopController.h"

@interface WQEssenceSharePopController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableView;
@end

@implementation WQEssenceSharePopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.superview.layer.cornerRadius = 0;
    self.view.superview.clipsToBounds = NO;
    //    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
    }
    cell.textLabel.text = self.shareToTitles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //万圈好友
    if (indexPath.row == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(essenceSharePopShareToThird)]) {
            [self.delegate essenceSharePopShareToThird];
        }
    }
    //第三方
    if (indexPath.row == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(essenceSharePopShareToCircle)]) {
            [self.delegate essenceSharePopShareToCircle];
        }
    }
//    //    分享邀请码
//    if (indexPath.row == 2) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(groupShareControllerShareInvitationCode)]) {
//            [self.delegate groupShareControllerShareInvitationCode];
//        }
//    }
}

- (CGSize)preferredContentSize {
    
    return CGSizeMake(120, 90);
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

@end
