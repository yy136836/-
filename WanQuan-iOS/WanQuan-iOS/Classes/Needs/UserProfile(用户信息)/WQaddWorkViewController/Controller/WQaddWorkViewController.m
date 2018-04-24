//
//  WQaddWorkViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQaddWorkViewController.h"
#import "WQaddWorkTableViewCell.h"

static NSString *cellid = @"cellid";

@interface WQaddWorkViewController ()<UITableViewDelegate,UITableViewDataSource,WQaddWorkTableViewCellDelegate>
@property (nonatomic, strong) WQaddWorkTableViewCell *cell;
@property (nonatomic, strong) NSArray *titleLabelArray;
@property (nonatomic, strong) NSMutableDictionary *userDetailInfoDictM;



/**
 添加经历的按钮暂时隐藏,以防 UI 再次修改
 */
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSArray *responseArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, assign) int inteager;
@property (nonatomic, copy) NSString *jieshuString;
@property (nonatomic, copy) void (^jieshuStringBlock)(NSString *jieshuString);
@end

@implementation WQaddWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    self.inteager = 0;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenPickerView) name:WQhiddenPickerView object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"添加工作经历";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClike)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
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
    [tableView registerNib:[UINib nibWithNibName:@"WQaddWorkTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.dataSource = self;
    tableView.delegate = self;
    
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
- (void)loadData
{
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
            self.responseArray = response[@"work_experience"];
        }
    }];
}

#pragma make - 点击事件
- (void)addBtnClike {
//    work_enterprise
//    work_start_time
//    work_end_time
//    work_position
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
    if (! [_userDetailInfoDictM[@"work_enterprise"] length] ) {
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
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.responseArray.count; i++) {
            [array addObject:self.responseArray[i]];
        }
        [array addObject:self.userDetailInfoDictM];
        
        NSString *urlString = @"api/user/update";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
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
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        if (self.isReleaseNeeds) {
                            if (self.addSuccessfulBlock) {
                                self.addSuccessfulBlock();
                            }
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            } else {
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

- (void)hiddenPickerView
{
    self.addBtn.hidden = NO;
}
- (void)delayMethod
{
    self.addBtn.hidden = NO;
}

#pragma make - WQaddWorkTableViewCellDelegate
- (void)wqkaishishijianBtnClikeDelegate:(WQaddWorkTableViewCell *)kaishiDelegate
{
    self.addBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
}
- (void)wqjieshushijianBtnClikeDelegate:(WQaddWorkTableViewCell *)jieshuDelegate
{
    self.addBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

// 时间选择器
- (void)theTimeSelector:(BOOL)isWhetherToday
{
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *str) {
        WQaddWorkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.index];
        __weak typeof(self) weakSelf = self;
        if (self.index.row == 0) {
            cell.kaishishijian.text = str;
        }else if(self.index.row == 1)
        {
            cell.jiesushijian.text = str;
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
    WQaddWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.delegate = self;
    [self setJieshuStringBlock:^(NSString *jieshushijian) {
        cell.jiesushijian.text = jieshushijian;
    }];
    self.cell = cell;
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setContentBlock:^(NSString *contentStr) {
        [weakSelf.userDetailInfoDictM setObject:weakCell.gongsimingcheng.text forKey:@"work_enterprise"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.kaishishijian.text forKey:@"work_start_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.jiesushijian.text forKey:@"work_end_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.zhiweimingcheng.text forKey:@"work_position"];
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}


- (void)back {
    [self.navigationController popViewControllerAnimated: YES];
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
    if (!_addBtn) {
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

- (NSArray *)responseArray
{
    if (!_responseArray) {
        _responseArray = [[NSArray alloc]init];
    }
    return _responseArray;
}



@end
