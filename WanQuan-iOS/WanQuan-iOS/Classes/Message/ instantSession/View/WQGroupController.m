//
//  WQGroupController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupController.h"
#import "WQGroupListCell.h"

@interface WQGroupController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic, retain) UITableView * mainTable;
@end

static NSString * cellID = @"groupListCell";
@implementation WQGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
}

- (void)setupUI {
    _searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.showsCancelButton = YES;


    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];

    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithHex:0xededed]];
    _mainTable = [[UITableView alloc] init];
    [self.view addSubview:_mainTable];
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_searchBar.mas_bottom);
    }];
    _mainTable.backgroundColor = [UIColor yellowColor];
    _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.tableFooterView = [UIView new];
    _mainTable.tableHeaderView = [UIView new];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQGroupListCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}


#pragma mark - searchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}



#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
