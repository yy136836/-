//
//  WQGroupShareController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupShareController.h"

@interface WQGroupShareController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableView;
@end

@implementation WQGroupShareController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    if (self.shareToTitles.count == 2) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    } else if (self.shareToTitles.count == 3) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 135)];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Class UITransitionViewClass = NSClassFromString(@"UITransitionView");
    for (UIView * view in [UIApplication sharedApplication].delegate.window.subviews) {
        if ([view isKindOfClass:[UITransitionViewClass class]]) {
            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            view.userInteractionEnabled = YES;
        }
    }
    self.view.superview.layer.cornerRadius = 0;
    self.view.superview.clipsToBounds = NO;
//    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shareToTitles.count;
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(groupShareControllerShareToFriend)]) {
            [self.delegate groupShareControllerShareToFriend];
        }
    }
    //第三方
    if (indexPath.row == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(groupShareControllerShareToThird)]) {
            [self.delegate groupShareControllerShareToThird];
        }
    }
//    分享邀请码
    if (indexPath.row == 2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(groupShareControllerShareInvitationCode)]) {
            [self.delegate groupShareControllerShareInvitationCode];
        }
    }
}

- (CGSize)preferredContentSize {
    
    if (self.shareToTitles.count == 2) {
        return CGSizeMake(120, 90);
    } else if (self.shareToTitles.count == 3) {
        return CGSizeMake(120, 135);
    }
    
    
    return CGSizeMake(120, 90);
}



- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

@end
