//
//  WQmodifyEducationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmodifyEducationViewController.h"
#import "WQmodifyEducationTableViewCell.h"
#import "WQTwoUserProfileModel.h"
#import "WQSelectViewController.h"

static NSString *cellid = @"cellid";

@interface WQmodifyEducationViewController ()<UITableViewDelegate,UITableViewDataSource,WQSelectViewControllerDelegate,WQmodifyEducationTableViewCellDelegate>
@property (nonatomic, strong) WQTwoUserProfileModel *model;
@property (nonatomic, strong) WQmodifyEducationTableViewCell *cell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleLabelArray;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) NSMutableDictionary *userDetailInfoDictM;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, retain) NSMutableArray * modifingArray;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) void (^jieshuStringBlock)(NSString *);

@end

@implementation WQmodifyEducationViewController

- (instancetype)initWithType:(NSString *)type model:(WQTwoUserProfileModel *)model
{
    if (self = [super init]) {
        self.type = type;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    //    self.model = _currentEducetionExperience[_modifingIndex];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.title = @"更改信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanchu"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}

#pragma mark - 初始化UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.modifyBtn];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];}

#pragma mark - 修改btn点击事件
- (void)modifyBtnClike
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
    
    
    if (!_userDetailInfoDictM.count) {
        ALERT(nil, @"您并未修改任何信息")
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_school"] length]) {
        //        hud.labelText = @"请填写学校名称";
        [WQAlert showAlertWithTitle:nil message:@"请填写学校名称" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_start_time"] length]) {
        [WQAlert showAlertWithTitle:nil message:@"请填写开始时间" duration:1];
        return;
    }
    
    if (! [_userDetailInfoDictM[@"education_end_time"] length]) {
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
        
        if (!self.type) {
            self.type = @"";
        }
        [self.modifingArray replaceObjectAtIndex:_modifingIndex withObject:_userDetailInfoDictM];
        [self.userDetailInfoDictM setObject:self.type forKey:@"type"];
        //        NSArray *array = @[self.userDetailInfoDictM];
        NSString *urlString = @"api/user/update";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        
        [_educetions replaceObjectAtIndex:_modifingIndex withObject:self.modifingArray[_modifingIndex]];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.modifingArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        _params[@"education"] = json;
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
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                
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

#pragma mark - WQSelectViewControllerDelegate
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



- (void)deleteItemClicked {
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
                               [_modifingArray removeObjectAtIndex:_modifingIndex];
                               if (!self.type) {
                                   self.type = @"";
                               }
                               [self.userDetailInfoDictM setObject:self.type forKey:@"type"];
                               //        NSArray *array = @[self.userDetailInfoDictM];
                               NSString *urlString = @"api/user/update";
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                               
                               [_educetions removeObjectAtIndex:_modifingIndex];
                               
                               NSData *data = [NSJSONSerialization dataWithJSONObject:_educetions options:NSJSONWritingPrettyPrinted error:nil];
                               NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               _params[@"education"] = json;
                               
//                               _params[@"education"] = json;
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
                                       UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                                       
                                       [self presentViewController:alertVC animated:YES completion:^{
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [alertVC dismissViewControllerAnimated:YES completion:nil];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });
                                       }];
                                   }
                               }];
                           }];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
    /*[_educetions removeObjectAtIndex:_modifingIndex];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:_educetions options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _params[@"education"] = json;
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
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
    }];*/

    
}

- (void)wqkaishishijianBtnClikeDelegate:(WQmodifyEducationTableViewCell *)kaishiDelegate {
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
}

- (void)wqjieshushijianBtlClikeDelegata:(WQmodifyEducationTableViewCell *)jieshuDelegata {
    self.modifyBtn.hidden = YES;
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

// 时间选择器
- (void)theTimeSelector:(BOOL)isWhetherToday {
    __weak typeof(self) weakSelf = self;
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *str) {
        WQmodifyEducationTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.index];
        if (weakSelf.index.row == 0) {
            cell.kaishiTimeLabel.text = str;
        }else if(weakSelf.index.row == 1) {
            //cell.graduate.text = str;
            //cell.jiesuTimeLabel.text = str;
//            if (weakSelf.jieshuStringBlock) {
//                weakSelf.jieshuStringBlock(str);
//            }
            if (weakSelf.jieshuStringBlock) {
                weakSelf.jieshuStringBlock(str);
            }
        }
    } isToday:isWhetherToday];
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
    WQmodifyEducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    self.cell = cell;
    cell.delegata = self;
    cell.schoolTextField.text = self.model.education_school;
    //cell.enteringSchoolTextField.text = self.model.education_start_time;
    cell.kaishiTimeLabel.text = self.model.education_start_time;
    //cell.graduateTextField.text = self.model.education_end_time;
    cell.jiesuTimeLabel.text = self.model.education_end_time;
    cell.specialtyTextField.text = self.model.education_major;
    
    [self setJieshuStringBlock:^(NSString *str) {
        cell.jiesuTimeLabel.text = str;
    }];
    
    int education_degree = [[NSString stringWithFormat:@"%zd",self.model.education_degree] intValue];
    switch (education_degree) {
        case 1:
            cell.aDegreeInLabel.text = @"小学";
            break;
        case 2:
            cell.aDegreeInLabel.text = @"中学";
            break;
        case 3:
            cell.aDegreeInLabel.text = @"本科";
            break;
        case 4:
            cell.aDegreeInLabel.text = @"硕士";
            break;
        case 5:
            cell.aDegreeInLabel.text = @"博士";
            break;
        default:
            break;
    }
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setContentBlock:^(NSString *contentStr) {
        [weakSelf.userDetailInfoDictM setObject:weakCell.schoolTextField.text forKey:@"education_school"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.kaishiTimeLabel.text forKey:@"education_start_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.jiesuTimeLabel.text forKey:@"education_end_time"];
        [weakSelf.userDetailInfoDictM setObject:weakCell.specialtyTextField.text forKey:@"education_major"];
        //[weakSelf.userDetailInfoDictM setObject:weakCell.degreesTextField.text forKey:@"education_degree"];
    }];
    WQSelectViewController *vc = [[WQSelectViewController alloc] init];
    vc.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setADegreeInBtnClikeBlock:^{
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]init];
        [_tableView registerNib:[UINib nibWithNibName:@"WQmodifyEducationTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}
- (NSArray *)titleLabelArray
{
    if (!_titleLabelArray) {
        _titleLabelArray = @[@"学校名称",@"入学时间",@"毕业时间",@"专业名称",@"学位名称"];
    }
    return _titleLabelArray;
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



- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)userDetailInfoDictM
{
    if (!_userDetailInfoDictM) {
        _userDetailInfoDictM = [[NSMutableDictionary alloc]init];
    }
    return _userDetailInfoDictM;
}

//education_school false string Tsinghua University 学校名称
//education_start_time false string 教育经历开始时间（yyyy-mm-dd）
//education_end_time false string 教育经历结束时间（yyyy-mm-dd）
//education_major false string Computer Science 专业
//education_degree false number 3 学位


- (void)setCurrentEducetionExperience:(NSArray *)currentEducetionExperience {
    _modifingArray = @[].mutableCopy;
    for (WQTwoUserProfileModel * model in currentEducetionExperience) {
        NSMutableDictionary * dic = @{}.mutableCopy;
        
        dic[@"education_school"] = model.education_school;
        dic[@"education_start_time"] = model.education_start_time;
        dic[@"education_end_time"] = model.education_end_time;
        dic[@"education_major"] = model.education_major;
        dic[@"education_degree"] = @(model.education_degree);
        dic[@"type"] = model.type;
        [_modifingArray addObject:dic];
    }
    
    //    NSDictionary * currentModi = _modifingArray[_modifingIndex];

    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
