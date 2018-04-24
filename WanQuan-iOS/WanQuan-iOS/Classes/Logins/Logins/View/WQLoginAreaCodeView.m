//
//  WQLoginAreaCodeView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginAreaCodeView.h"
#import "WQLoginAreaCodeTableViewCell.h"
#import "WQLoginAreaCodeHeadView.h"
#import "WQAreaCodeModel.h"
#import "WQAreaCodeListModel.h"

static NSString *identifier = @"Identifier";

@interface WQLoginAreaCodeView () <UITableViewDelegate,UITableViewDataSource,WQLoginAreaCodeHeadViewDelegate>

@end

@implementation WQLoginAreaCodeView {
    UITableView *ghtableView;
    NSMutableArray *dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        dataArray = [NSMutableArray array];
        [self setupView];
        [self loadList];
    }
    return self;
}

#pragma mark -- 加载数据
- (void)loadList {
    NSString *urlString = @"api/user/countrycodelist";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response [@"success"] boolValue]) {
            dataArray = [NSArray yy_modelArrayWithClass:[WQAreaCodeModel class] json:response[@"country_code_list"]].mutableCopy;
            [ghtableView reloadData];
        }
    }];
}

#pragma mark - 初始化View
- (void)setupView {
    ghtableView = [[UITableView alloc] init];
    ghtableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    ghtableView.dataSource = self;
    ghtableView.delegate = self;
    ghtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghtableView.showsVerticalScrollIndicator = NO;
    [ghtableView registerClass:[WQLoginAreaCodeTableViewCell class] forCellReuseIdentifier:identifier];
    [self addSubview:ghtableView];
    [ghtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(kScaleX(375));
    }];
    
    WQLoginAreaCodeHeadView *headView = [[WQLoginAreaCodeHeadView alloc] init];
    headView.delegate = self;
    [self addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(ghtableView.mas_top);
        make.height.offset(kScaleX(55));
    }];
    
    self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
}

#pragma mark -- WQLoginAreaCodeHeadViewDelegate
- (void)wqShutDownBtnClick:(WQLoginAreaCodeHeadView *)headView {
    if ([self.delagate respondsToSelector:@selector(wqDidSelectRowAtIndexPath:areaCode:)]) {
        [self.delagate wqDidSelectRowAtIndexPath:self areaCode:@""];
    }
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQLoginAreaCodeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delagate respondsToSelector:@selector(wqDidSelectRowAtIndexPath:areaCode:)]) {
        [self.delagate wqDidSelectRowAtIndexPath:self areaCode:cell.model.code];
    }
    NSDictionary *dict = @{@"code" : cell.model.code};
    [[NSNotificationCenter defaultCenter] postNotificationName:WQdidSelectAreaCodeClick object:self userInfo:dict];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WQAreaCodeModel *model = dataArray[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQLoginAreaCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    WQAreaCodeModel *model = dataArray[indexPath.section];
    cell.model = model.list[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    WQAreaCodeModel *model = dataArray[section];
    return model.first_spell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [UITableViewHeaderFooterView new];
    view.textLabel.font = [UIFont systemFontOfSize:15];
    view.textLabel.textColor = HEX(0x999999);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}


@end
