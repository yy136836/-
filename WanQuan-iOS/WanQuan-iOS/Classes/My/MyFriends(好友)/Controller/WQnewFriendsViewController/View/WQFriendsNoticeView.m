//
//  WQFriendsNoticeView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFriendsNoticeView.h"
#import "WQFriendsNoticeTableViewCell.h"
#import "WQUserProfileModel.h"

static NSString *cellid = @"cellidq";

@interface WQFriendsNoticeView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation WQFriendsNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor whiteColor];
    self.tableview = tableview;
    [tableview registerClass:[WQFriendsNoticeTableViewCell class] forCellReuseIdentifier:cellid];
    [self addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
    }];
    tableview.dataSource = self;
    tableview.delegate = self;
}

- (void)setAUsernameMessageArray:(NSMutableArray *)aUsernameMessageArray {
    _aUsernameMessageArray = aUsernameMessageArray;
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.headerViewHigthBlock) {
        self.headerViewHigthBlock(self.aUsernameMessageArray.count * 60);
    }
    return self.aUsernameMessageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQFriendsNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.model = self.aUsernameMessageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAgreedToBtnClikeBlock:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *aUsernameArray = [userDefaults objectForKey:@"aUsername"];
        NSString *userName = aUsernameArray[indexPath.row];
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:userName];
        if (!error) {
            NSLog(@"发送同意成功");
            [self.aUsernameMessageArray removeObjectAtIndex:indexPath.row];
            [self.tableview reloadData];
            NSString *urlString = @"api/friend/set";
            NSArray *friendArray = @[userName];
            NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:friendArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *labelTagString = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
            self.params[@"friends"] = labelTagString;
            [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                    return ;
                }
                if ([response isKindOfClass:[NSData class]]) {
                    response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                }
                NSLog(@"%@",response);
                [userDefaults removeObjectForKey:@"aUsername"];
                [self.tableview reloadData];
            }];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

@end
