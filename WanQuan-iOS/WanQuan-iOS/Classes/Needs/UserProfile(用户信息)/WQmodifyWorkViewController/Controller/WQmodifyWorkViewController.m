//
//  WQmodifyWorkViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmodifyWorkViewController.h"
#import "WQmodifyWorkTableViewCell.h"
#import "WQTwoUserProfileModel.h"

static NSString *cellid = @"cellid";

@interface WQmodifyWorkViewController ()<UITableViewDataSource,UITableViewDelegate,WQmodifyWorkTableViewCellDelegate>
@property (nonatomic, strong) WQTwoUserProfileModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) NSArray *titleLabelArray;
@property (nonatomic, strong) NSMutableDictionary *userDetailInfoDictM;
@property (nonatomic, strong) NSArray *paramsArray;                    //工作经历参数
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *informationParams;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) void (^jieshuTimeBlock)(NSString *);
/**
 所有工作经历的列表
 */
@property (nonatomic, strong) NSMutableArray *modelArray;




@property (nonatomic, copy) NSString *type;

@end

@implementation WQmodifyWorkViewController




- (instancetype)initWithType:(NSString *)type modelArray:(NSArray *)modelArray andCurrentIndex:(NSUInteger)index {
    if (self = [super init]) {
        self.type = type;
        self.modelArray = modelArray.mutableCopy;
        self.model = modelArray[index];
        _selectedIndex = index;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDetailInfoDictM = @{}.mutableCopy;
    [self setupUI];
    
    
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanchu"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClicked)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"更改信息";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanchu"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClicked)];
  
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - 初始化UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.modifyBtn];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
}

#pragma mark - 修改btn点击事件

- (void)deleteItemClicked {
    
    //    WQmodifyWorkTableViewCell * cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除该项信息"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton =
    [UIAlertAction actionWithTitle:@"删除"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * _Nonnull action) {
                               [self.modelArray removeObject:self.model];
                               NSMutableArray *array = @[].mutableCopy;
                               for (WQTwoUserProfileModel * model in self.modelArray) {
                                   NSMutableDictionary * dic = @{}.mutableCopy;
                                   [dic setObject:model.work_enterprise forKey:@"work_enterprise"];
                                   [dic setObject:model.work_start_time forKey:@"work_start_time"];
                                   [dic setObject:model.work_end_time   forKey:@"work_end_time"];
                                   [dic setObject:model.work_position   forKey:@"work_position"];
                                   [array addObject:dic];
                               }
                               
                               
                               NSString *urlString = @"api/user/update";
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                               
                               
                               _work = _work.mutableCopy;
                               
                               [_work removeObjectAtIndex:_selectedIndex];
                               
                               self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                               
                               NSData *data = [NSJSONSerialization dataWithJSONObject:_work options:NSJSONWritingPrettyPrinted error:nil];
                               NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               
                               _params[@"work_experience"] = json;
                               [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
                                   if (error) {
                                       NSLog(@"%@",error);
                                       return ;
                                   }
                                   if ([response isKindOfClass:[NSData class]]) {
                                       response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                                   }
                                   NSLog(@"%@",response);
                                   if ([response[@"success"] boolValue]) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:WQmodifyWork object:self];
                                       UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示~" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                                       
                                       [self presentViewController:alertVC animated:YES completion:^{
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [alertVC dismissViewControllerAnimated:YES completion:nil];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });
                                       }];
                                   }
                               }];
                           }];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
    //    [self.modelArray removeObject:self.model];
    //    NSMutableArray *array = @[].mutableCopy;
    //    for (WQTwoUserProfileModel * model in self.modelArray) {
    //        NSMutableDictionary * dic = @{}.mutableCopy;
    //        [dic setObject:model.work_enterprise forKey:@"work_enterprise"];
    //        [dic setObject:model.work_start_time forKey:@"work_start_time"];
    //        [dic setObject:model.work_end_time   forKey:@"work_end_time"];
    //        [dic setObject:model.work_position   forKey:@"work_position"];
    //        [array addObject:dic];
    //    }
    

    
}

- (void)modifyBtnClike {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
    
    if (!_userDetailInfoDictM.count) {
        ALERT(nil, @"您并未修改任何信息")
        return;
    }
    
    if (! [_userDetailInfoDictM[@"work_enterprise"] length]) {
        //        hud.labelText = @"请填写学校名称";
        [WQAlert showAlertWithTitle:nil message:@"请填写公司名称" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"work_start_time"] length] ) {
        [WQAlert showAlertWithTitle:nil message:@"请填写开始时间" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"work_end_time"] length]) {
        [WQAlert showAlertWithTitle:nil message:@"请填写结束时间" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"work_end_time"] length]) {
        [WQAlert showAlertWithTitle:nil message:@"请填写职位名称" duration:1];
        return;
    }
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
        
        NSMutableArray *exparienceArray = @[].mutableCopy;
        for (WQTwoUserProfileModel * model in self.modelArray) {
            NSMutableDictionary * dic = @{}.mutableCopy;
            [dic setObject:model.work_enterprise forKey:@"work_enterprise"];
            [dic setObject:model.work_start_time forKey:@"work_start_time"];
            [dic setObject:model.work_end_time   forKey:@"work_end_time"];
            [dic setObject:model.work_position   forKey:@"work_position"];
            [exparienceArray addObject:dic];
            
        }
        
        NSMutableDictionary * dic = @{}.mutableCopy;
        
        WQTwoUserProfileModel * model = self.modelArray[_selectedIndex];
        dic[@"work_enterprise"] = model.work_enterprise;
        dic[@"work_start_time"] = model.work_start_time;
        dic[@"work_end_time"] = model.work_end_time;
        dic[@"work_position"] = model.work_position;
        if (![_work isKindOfClass:[NSMutableDictionary class]]) {
            _work = _work.mutableCopy;
        }
        self.userDetailInfoDictM[@"type"] = model.type;
        _work[_selectedIndex] = self.userDetailInfoDictM;
        
        
        
        
        //        [exparienceArray replaceObjectAtIndex:_selectedIndex withObject:self.userDetailInfoDictM];
        
        NSString *urlString = @"api/user/update";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:_work options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        _params[@"work_experience"] = json;
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WQmodifyWork object:self];
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示~" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }
        }];
    });
}

- (void)wqkaishishijianBtnClikeDelegate:(WQmodifyWorkTableViewCell *)kaishiDelegate {
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
}
- (void)wqjieshushijianBtlClikeDelegata:(WQmodifyWorkTableViewCell *)jieshuDelegata {
    self.modifyBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

// 时间选择器
- (void)theTimeSelector:(BOOL)isWhetherToday {
    __weak typeof(self) weakSelf = self;
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *str) {
        WQmodifyWorkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.index];
        if (weakSelf.index.row == 0) {
            cell.kaishiTimeLabel.text = str;
        }else if(weakSelf.index.row == 1) {
            if (self.jieshuTimeBlock) {
                self.jieshuTimeBlock(str);
            }
        }
    }  isToday:isWhetherToday];
    [datePickerView show];
    [datePickerView setHindBlock:^{
        [weakSelf performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
    }];
}

#pragma mark - CuiPickViewDelegate
- (void)hiddenPickerView {
    self.modifyBtn.hidden = NO;
}
- (void)delayMethod {
    self.modifyBtn.hidden = NO;
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQmodifyWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.delegate = self;
    [self setJieshuTimeBlock:^(NSString *str) {
        cell.jieshuTimeLabel.text = str;
    }];
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.gongsimingcheng.text = self.model.work_enterprise;
    cell.kaishiTimeLabel.text = self.model.work_start_time;
    cell.jieshuTimeLabel.text = self.model.work_end_time;
    cell.zhiweimingcheng.text = self.model.work_position;
    
    cell.contentBlock = ^(NSString *contentStr) {
        [weakSelf.userDetailInfoDictM setObject:weakCell.gongsimingcheng.text forKey:@"work_enterprise"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.kaishiTimeLabel.text forKey:@"work_start_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.jieshuTimeLabel.text forKey:@"work_end_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.zhiweimingcheng.text forKey:@"work_position"];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 * 4;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]init];
        [_tableView registerNib:[UINib nibWithNibName:@"WQmodifyWorkTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (void)setModel:(WQTwoUserProfileModel *)model {
    _model = model;
}
- (UIButton *)modifyBtn
{
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc]init];
        [_modifyBtn setBackgroundColor:[UIColor colorWithHex:0x5d2a89]];
        [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        _modifyBtn.layer.cornerRadius = 5;
        _modifyBtn.layer.masksToBounds = YES;
        [_modifyBtn addTarget:self action:@selector(modifyBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}
- (NSArray *)titleLabelArray
{
    if (!_titleLabelArray) {
        _titleLabelArray = @[@"公司名称",@"工作开始时间",@"工作结束时间",@"职位名称"];
    }
    return _titleLabelArray;
}

- (NSArray *)paramsArray {
    if (!_paramsArray) {
        _paramsArray = @[@"work_enterprise",@"work_start_time",@"work_end_time",@"work_position",@"type"];
    }
    return _paramsArray;
}
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)informationParams
{
    if (!_informationParams) {
        _informationParams = [[NSMutableDictionary alloc]init];
    }
    return _informationParams;
}
- (NSArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = @[].mutableCopy;
    }
    return _modelArray;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
