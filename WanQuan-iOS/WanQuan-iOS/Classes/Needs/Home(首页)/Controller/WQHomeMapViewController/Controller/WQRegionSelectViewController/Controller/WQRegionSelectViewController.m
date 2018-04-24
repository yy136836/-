//
//  WQRegionSelectViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQRegionSelectViewController.h"
#import "WQRegionSelectSearchViewController.h"

static NSString* cellid = @"city_cell";

@interface WQRegionSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary* cityListData;

@property (nonatomic, strong) NSArray* cityKeys;

@end

@implementation WQRegionSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.cityListData = [self loadCityListData];
    self.cityKeys = [[self.cityListData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    UIView *navView = [[UIView alloc]init];
    navView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(64);
        make.left.right.top.mas_equalTo(self.view);
    }];
    
    UIButton *dissmissBtn = [[UIButton alloc]init];
    [navView addSubview:dissmissBtn];
    dissmissBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [dissmissBtn setTitle:@"关闭" forState:0];
    [dissmissBtn setTitleColor:[UIColor colorWithHex:0x585858] forState:0];
    [dissmissBtn addTarget:self action:@selector(dissmissBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [dissmissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_top).mas_offset(32);
        make.left.mas_equalTo(navView.mas_left).mas_offset(16);
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [navView addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"sarch_location-1"] forState:0];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_top).mas_offset(25);
        make.right.mas_equalTo(navView.mas_right).mas_offset(-15);
    }];
    [searchBtn addTarget:self action:@selector(searchBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
    }];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void)searchBtnClike
{
    WQRegionSelectSearchViewController *vc = [WQRegionSelectSearchViewController new];    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)dissmissBtnClike
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 解析城市数据
- (NSDictionary*)loadCityListData
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"cityList.plist" withExtension:nil];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

#pragma mark - tablviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.cityKeys.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = self.cityKeys[section];
    NSArray* cities = self.cityListData[key];
    return cities.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSString* key = self.cityKeys[indexPath.section];
    NSArray* cities = self.cityListData[key];
    NSString* cityName = cities[indexPath.row];
    cell.textLabel.text = cityName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WQCityDidChangeNotifacation object:nil userInfo:@{WQCityNameKey : cell.textLabel.text}];
    
    [WQDataSource sharedTool].mapSelectedCity = cell.textLabel.text;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cityKeys[section];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.cityKeys;
}

@end

