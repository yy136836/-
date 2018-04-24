//
//  WQiCareCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQiCareCollectionViewCell.h"
#import "WQiCareTableViewCell.h"
#import "WQFocusOnModel.h"
#import "WQEmptICareCollectionView.h"

static NSString *identifier = @"identifier";

@interface WQiCareCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

/**
 空页面
 */
@property (nonatomic, strong) WQEmptICareCollectionView *emptICareCollectionView;

@end

@implementation WQiCareCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setUpContentView];
    return self;
}

#pragma mark -- 初始化contentView
- (void)setUpContentView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableView.frame = self.contentView.bounds;
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 取消滚动条
    tableView.showsVerticalScrollIndicator = NO;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerClass:[WQiCareTableViewCell class] forCellReuseIdentifier:identifier];
    [self.contentView addSubview:tableView];
    
    // 空页面
    WQEmptICareCollectionView *emptICareCollectionView = [[WQEmptICareCollectionView alloc] init];
    self.emptICareCollectionView = emptICareCollectionView;
    emptICareCollectionView.hidden = YES;
    [self.contentView addSubview:emptICareCollectionView];
    [emptICareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setIsMyFocusOn:(BOOL)isMyFocusOn {
    _isMyFocusOn = isMyFocusOn;
    if (self.isMyFocusOn) {
        self.emptICareCollectionView.status = IFocusOn;
    }else {
        self.emptICareCollectionView.status = PayAttentionToMy;
    }
    [self loadList];
}

- (void)loadList {
    NSString *urlString;
    if (self.isMyFocusOn) {
        urlString = @"api/user/follow/getfollowedlist";
    }else {
        urlString = @"api/user/follow/getfollowerlist";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismissWithDelay:0.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.3];
        if (self.isMyFocusOn) {
            self.dataArray = [NSArray yy_modelArrayWithClass:[WQFocusOnModel class] json:response[@"followeds"]];
        }else {
            self.dataArray = [NSArray yy_modelArrayWithClass:[WQFocusOnModel class] json:response[@"followers"]];
        }
        if (!self.dataArray.count) {
            self.emptICareCollectionView.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQiCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

@end
