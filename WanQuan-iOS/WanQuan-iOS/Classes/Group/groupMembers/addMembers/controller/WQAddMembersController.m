//
//  WQAddMembersController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddMembersController.h"
#import "WQfriendsModel.h"
#import "WQGroupMemberModel.h"
#import "WQAddGroupMemberCell.h"

@interface WQAddMembersController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSMutableArray * modelArray;
@property (nonatomic, retain) NSMutableArray * selectedIds;


@end

@implementation WQAddMembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_deleteType) {
        self.navigationItem.title = @"删除成员";
    } else {
        self.navigationItem.title = @"添加联系人";
    }
    [self setupUI];
    _selectedIds = @[].mutableCopy;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    if (!_deleteType) {
        [self requestData];
    }
    
}


#pragma mark - 初始化UI
- (void)setupUI {
    self.navigationItem.title = @"好友";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(handleMember)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;

    UITableView *tableView = [[UITableView alloc]init];

    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"WQAddGroupMemberCell" bundle:nil] forCellReuseIdentifier:@"WQAddGroupMemberCell"];
    [self.view addSubview:tableView];
    
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    tableView.tableFooterView = [UIView new];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.editing = YES;
    
    //tableView.sectionIndexBackgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor colorWithHex:0x000000]];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    if (_deleteType) {
        return 1;
    }
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_deleteType) {
        return _currentMembes.count;
    }
    
    WQfriendsModel *model = self.modelArray[section];
    return model.friend_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQAddGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQAddGroupMemberCell"];
    
    
    if (!_deleteType) {
        WQfriendsModel *model = self.modelArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.model = model.friend_list[indexPath.row];
    } else {
        cell.groupMemberModel = _currentMembes[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * titles = @[].mutableCopy;
    for (WQfriendsModel * model in self.modelArray) {
        [titles addObject:model.first_spell];
    }
    return titles;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    if (_deleteType) {
        return nil;
    }
    WQfriendsModel *model = self.modelArray[section];
    return model.first_spell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQAddGroupMemberCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!_deleteType) {
        WQfriend_listModel * model = cell.model;
        [_selectedIds addObject:model.user_id];
    } else {
        WQGroupMemberModel * model = cell.groupMemberModel;
        [_selectedIds addObject:model.user_id];
    }
    
    NSLog(@"%@",_selectedIds);

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQAddGroupMemberCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!_deleteType) {
        WQfriend_listModel * model = cell.model;
        [_selectedIds removeObject:model.user_id];
    } else {
        WQGroupMemberModel * model = cell.groupMemberModel;
        [_selectedIds removeObject:model.user_id];
    }
    NSLog(@"%@",_selectedIds);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)requestData {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    dict[@"degree"] = @(1).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.modelArray = [NSMutableArray yy_modelArrayWithClass:[WQfriendsModel class] json:response[@"friends"]].mutableCopy;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void)handleMember {
    
    NSString * strURL;
    if (_deleteType) {
        
        strURL = @"api/group/removegroupmember";
    } else {
        
        strURL = @"api/group/addgroupmember";
    }
//    secretkey true string
//    gid true string 群组的ID
//    uid true string jsonarray格式，每个元素为用户的32位ID

    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"gid"] = self.gid;
    
    if (_selectedIds.count) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:_selectedIds options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        param[@"uid"] = str;
    } else {
        [WQAlert showAlertWithTitle:nil message:@"还未选择!" duration:1.3];
        return;
    }
    
    
    
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [WQAlert showAlertWithTitle:nil message:error.localizedDescription duration:1.3];
            return ;
        }
        
        if (![response[@"success"] boolValue]) {
            [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
        } else {
            [WQAlert showAlertWithTitle:nil message:@"操作成功" duration:1.3];
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];

}


@end
