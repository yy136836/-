//
//  WQTopicStickOrDeleteController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicStickOrDeleteController.h"

#define TITLES @[@"置顶",@"删除"]
#define TITLES_CANCLE @[@"取消置顶",@"删除"]
#define IMAGE_NAMES @[@"quanzizhiding",@"quanzishanchu"]
#define IMAGE_NAMES_CANCLE @[@"quanziquxiaozhiding",@"quanzishanchu"]

@interface WQTopicStickOrDeleteController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableView;
@end

@implementation WQTopicStickOrDeleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 90)];
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
    cell.textLabel.text =self.isSticked ? TITLES_CANCLE[indexPath.row] :TITLES[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize: 15];
    
    NSString * imageName = self.isSticked ? IMAGE_NAMES_CANCLE[indexPath.row] : IMAGE_NAMES[indexPath.row];
    cell.imageView.image = [UIImage imageNamed: imageName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    置顶或取消置顶
    if (indexPath.row == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WQTopicStickOrDeleteControllerDelegateStickTopic)]) {
            [self.delegate WQTopicStickOrDeleteControllerDelegateStickTopic];
        }
    }
//    删除话题
    if (indexPath.row == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WQTopicStickOrDeleteControllerDelegateDeleteTopic)]) {
            [self.delegate WQTopicStickOrDeleteControllerDelegateDeleteTopic];
        }
    }
}

- (CGSize)preferredContentSize {
    return CGSizeMake(140, 90);
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

@end
