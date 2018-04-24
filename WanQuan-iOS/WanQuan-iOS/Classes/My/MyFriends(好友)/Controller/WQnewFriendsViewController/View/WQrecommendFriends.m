//
//  WQrecommendFriends.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQrecommendFriends.h"
#import "WQfriendsModel.h"
#import "WQrecommendFriendsTwoTableViewCell.h"
#import "WQaddFriendsController.h"
#import "WQfriend_listModel.h"
#import "WQrecommendFriendsTwoTableViewCell.h"

static NSString *cellid = @"cellid";

@interface WQrecommendFriends() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation WQrecommendFriends

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self requestData];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor whiteColor];
    self.tableview = tableview;
    [tableview registerClass:[WQrecommendFriendsTwoTableViewCell class] forCellReuseIdentifier:cellid];
    [self addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    tableview.dataSource = self;
    tableview.delegate = self;
}


- (void)requestData {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    dict[@"degree"] = @(2).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.modelArray = [NSMutableArray yy_modelArrayWithClass:[WQfriendsModel class] json:response[@"friends"]];
        [self.tableview reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WQfriendsModel *model = self.modelArray[section];
    if (self.bottomViewBlock) {
        self.bottomViewBlock(model.friend_list.count * 60);
    }
    return model.friend_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQrecommendFriendsTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQfriendsModel *model = self.modelArray[indexPath.section];
    cell.model = model.friend_list[indexPath.row];
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setFriendsAddBtnClikeBlock:^{
        NSString *huanxinId = weakCell.model.user_id;
        WQaddFriendsController *vc = [[WQaddFriendsController alloc] initWithIMId:huanxinId];
        vc.type = @"添加好友";
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

#pragma mark - 懒加载
- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc] init];
    }
    return _modelArray;
}

@end
