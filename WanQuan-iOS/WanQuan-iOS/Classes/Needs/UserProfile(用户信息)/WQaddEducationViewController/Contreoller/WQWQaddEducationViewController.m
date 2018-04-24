//
//  WQWQaddEducationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQWQaddEducationViewController.h"
#import "WQaddEducationTableViewCell.h"
#import "CuiPickerView.h"
#import "WQSelectViewController.h"
#import "MBProgressHUD.h"

static NSString *cellid = @"cellid";

@interface WQWQaddEducationViewController ()<UITableViewDelegate,UITableViewDataSource,WQaddEducationTableViewCellDelegate,WQSelectViewControllerDelegate>
@property (nonatomic, strong) WQaddEducationTableViewCell *cell;
@property (nonatomic, strong) NSArray *titleLabelArray;
@property (nonatomic, strong) NSMutableDictionary *userDetailInfoDictM;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *educationArray;
@property (nonatomic, strong) NSArray *responseArray;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void (^jieshuStringBlock)(NSString *jieshuString);

@end

@implementation WQWQaddEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"学习经历";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClike)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma make - 初始化UI
- (void)setupUI
{
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerNib:[UINib nibWithNibName:@"WQaddEducationTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    [self.view addSubview:self.addBtn];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    _addBtn.hidden = YES;
}

#pragma make - 请求数据
- (void)loadData {
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            self.responseArray = response[@"education"];
        }
    }];
}

#pragma make - 点击事件
- (void)addBtnClike
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
        
    if (! [_userDetailInfoDictM[@"education_school"] length]) {
//        hud.labelText = @"请填写学校名称";
        [WQAlert showAlertWithTitle:nil message:@"请填写学校名称" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_start_time"] length] ) {
        [WQAlert showAlertWithTitle:nil message:@"请填写开始时间" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_end_time"] length] ) {
        [WQAlert showAlertWithTitle:nil message:@"请填写结束时间" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_major"] length]) {
        [WQAlert showAlertWithTitle:nil message:@"请填写专业名称" duration:1];
        return;
    }
    
    if (![_userDetailInfoDictM[@"education_degree"] length]) {
        [WQAlert showAlertWithTitle:nil message:@"请填写学位名称" duration:1];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.responseArray.count; i++) {
            [array addObject:self.responseArray[i]];
        }
        [array addObject:self.userDetailInfoDictM];
        NSString *urlString = @"api/user/update";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _params[@"education"] = jsonString;
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
                //通知loaData
                [[NSNotificationCenter defaultCenter] postNotificationName:WQmodifyWork object:self];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }else
            {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
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

#pragma mark - CuiPickViewDelegate
- (void)hiddenPickerView
{
    self.addBtn.hidden = NO;
}
- (void)delayMethod
{
    self.addBtn.hidden = NO;
}

#pragma make - WQaddEducationTableViewCellDelegate
- (void)wqkaishishijianBtnClikeDelegate:(WQaddEducationTableViewCell *)kaishiDelegate
{
    //self.addBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
}
- (void)wqbiyeshijianBtnClikeDelegate:(WQaddEducationTableViewCell *)jieshuDelegate
{
    self.addBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

// 时间选择器
- (void)theTimeSelector:(BOOL)isWhetherToday
{
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *str) {
                WQaddEducationTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.index];
                __weak typeof(self) weakSelf = self;
                if (self.index.row == 0) {
                    cell.enteringSchool.text = str;
                }else if(self.index.row == 1)
                {
                    cell.graduate.text = str;
                    if (weakSelf.jieshuStringBlock) {
                        weakSelf.jieshuStringBlock(str);
                    }
                }
    }  isToday:isWhetherToday];
    [datePickerView show];
    [datePickerView setHindBlock:^{
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
    }];
}

#pragma make - WQSelectViewControllerDelegate
- (void)wqSelectViewControllerWithvc:(WQSelectViewController *)vc index:(NSIndexPath *)index
{
    switch (index.row) {
        case 0:
            self.userDetailInfoDictM[@"education_degree"] = @(1).description;
            self.cell.aDegreeInLabel.text = @"中学及以下";
            break;
        case 1:
            self.userDetailInfoDictM[@"education_degree"] = @(2).description;
            self.cell.aDegreeInLabel.text = @"大专";
            break;
        case 2:
            self.userDetailInfoDictM[@"education_degree"] = @(3).description;
            self.cell.aDegreeInLabel.text = @"本科";
            break;
        case 3:
            self.userDetailInfoDictM[@"education_degree"] = @(4).description;
            self.cell.aDegreeInLabel.text = @"硕士";
            break;
        case 4:
            self.userDetailInfoDictM[@"education_degree"] = @(5).description;
            self.cell.aDegreeInLabel.text = @"博士";
            break;
        default:
            [self.tableView reloadData];
            break;
    }
}

#pragma make - TableViewDataSource
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
    WQaddEducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    self.cell = cell;
    cell.delegate = self;
    [self setJieshuStringBlock:^(NSString *jieshushijian) {
        cell.graduate.text = jieshushijian;
    }];
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setContentBlock:^(NSString *contentStr) {
        
        

        
        [weakSelf.userDetailInfoDictM setObject:weakCell.schoolTextField.text forKey:@"education_school"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.enteringSchool.text forKey:@"education_start_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.graduate.text forKey:@"education_end_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.specialtyTextField.text forKey:@"education_major"];
        //[weakSelf.userDetailInfoDictM setObject:weakCell.degreesTextField.text forKey:@"education_degree"];
    }];
    WQSelectViewController *vc = [[WQSelectViewController alloc] init];
    vc.delegate = self;
    [cell setAddAdegreeInBtnClikeBlock:^{
        [self.navigationController pushViewController:vc animated:YES];
    }];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma make - 懒加载
- (NSMutableDictionary *)userDetailInfoDictM
{
    if (!_userDetailInfoDictM) {
        _userDetailInfoDictM = [[NSMutableDictionary alloc]init];
    }
    return _userDetailInfoDictM;
}
- (UIButton *)addBtn
{
    if(!_addBtn) {
            _addBtn = [[UIButton alloc]init];
            [_addBtn setBackgroundColor:[UIColor colorWithHex:0x5d2a89]];
            [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
            _addBtn.layer.cornerRadius = 5;
            _addBtn.layer.masksToBounds = YES;
            [_addBtn addTarget:self action:@selector(addBtnClike) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return _addBtn;
}
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)educationArray
{
    if (!_educationArray) {
        _educationArray = [[NSMutableArray alloc]init];
    }
    return _educationArray;
}

- (NSArray *)responseArray
{
    if (!_responseArray) {
        _responseArray = [[NSArray alloc]init];
    }
    return _responseArray;
}

@end
