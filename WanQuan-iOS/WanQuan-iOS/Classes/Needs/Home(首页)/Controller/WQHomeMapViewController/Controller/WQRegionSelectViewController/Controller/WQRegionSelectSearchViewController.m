//
//  WQRegionSelectSearchViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQRegionSelectSearchViewController.h"
#import "WQTabBarController.h"

static NSString *cellid = @"cellid";

@interface WQRegionSelectSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSDictionary *cityListData;

@property(nonatomic,strong)NSArray *arrAy;

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation WQRegionSelectSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cityListData = [self loadCityListData];
    self.arrAy = [NSArray array];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (! [tabBarVC isKindOfClass:[WQTabBarController class]]) {
        return;
    }
    tabBarVC.tabBar.hidden = NO;
}

- (void)setupUI {
    
    
    UIView *sunshadeView = [[UIView alloc]init];
    sunshadeView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:sunshadeView];
    [sunshadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView *navView = [UIView new];
    navView.backgroundColor = [UIColor colorWithHex:0Xa550d6];
    [sunshadeView addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(sunshadeView);
        make.height.mas_offset(64);
    }];
    
    UISearchBar *SearchBar = [UISearchBar new];
    SearchBar.delegate = self;
    SearchBar.showsCancelButton = YES;
    SearchBar.tintColor = [UIColor whiteColor];
    UITextField *textField = [SearchBar valueForKey:@"_searchField"];
    textField.textColor = [UIColor whiteColor];
    SearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [navView addSubview:SearchBar];
    [SearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).mas_offset(15);
        make.bottom.mas_equalTo(navView.mas_bottom).mas_offset(-5);
        make.right.mas_equalTo(navView.mas_right).mas_offset(-15);
    }];
    [SearchBar becomeFirstResponder];
    
    UITableView *tableview = [[UITableView alloc]init];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
    [sunshadeView addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.bottom.mas_equalTo(sunshadeView);
    }];
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.dataSource = self;
    tableview.delegate = self;
    self.tableview = tableview;
//    [tableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF LIKE[c] '*%@*'", searchText]];
    NSArray *result;
    BOOL cityName = [self validateName:searchText];
    if (cityName) {
        result = [[_cityListData allValues] filteredArrayUsingPredicate:predicate];
        NSMutableArray *cityM = [NSMutableArray array];
        for (NSString *cityPY in result) {
            [cityM addObjectsFromArray:[_cityListData allKeysForObject:cityPY]];
        }
        result = cityM.copy;
    }else{
        result = [[_cityListData allKeys] filteredArrayUsingPredicate:predicate];
    }
    self.arrAy = result;
    [self.tableview reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrAy.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    NSString* cityName = self.arrAy[indexPath.row];
    
    cell.textLabel.text = cityName;
    return cell;
}

// 解析城市数据
- (NSDictionary *)loadCityListData
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"cityList.plist" withExtension:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    NSArray *cityArray = [dict allValues];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSArray *tempArray in cityArray) {
        for (NSString *city in tempArray) {
            [dictM setObject:city.pinYin forKey:city];
        }
    }
    
    return dictM.copy;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:WQCityDidChangeNotifacation object:nil userInfo:@{WQCityNameKey : cell.textLabel.text}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateName:(NSString *)cityName {
    NSString *regex = @"[a-zA-Z]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:cityName];
}

//- (void)onTap {
//    [self.view endEditing:YES];
//}


@end
