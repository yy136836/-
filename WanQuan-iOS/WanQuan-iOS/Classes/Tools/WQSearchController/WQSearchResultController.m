//
//  WQSearchResultController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSearchResultController.h"

@interface WQSearchResultController ()
@property (nonatomic, retain) UITableView * mainTable;

@end

@implementation WQSearchResultController

- (instancetype)init {
    if (self = [super init]) {
        
        _mainTable = [[UITableView alloc] init];
        [self.view addSubview:_mainTable];
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(@(64));
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRegistCellNameOrNibName:(NSString *)registCellNameOrNibName {
    _registCellNameOrNibName = registCellNameOrNibName;
    
    Class cellClass = NSClassFromString(registCellNameOrNibName);
    
    
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
}

- (void)setModelClass:(Class)modelClass {
    _modelClass = modelClass;
}

@end
