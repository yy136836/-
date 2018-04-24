//
//  WQindividualViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQindividualViewController.h"
#import "WQindividualTopView.h"
#import "WQworkExperienceTableViewCell.h"
#import "WQUserProfileModel.h"
#import "WQindividualTopTableViewCell.h"
#import "WQindividualTopTableViewTwoCell.h"
#import "WQTwoUserProfileModel.h"
#import "WQmodifyWorkViewController.h"
#import "WQmodifyEducationViewController.h"
#import "WQaddWorkViewController.h"
#import "WQWQaddEducationViewController.h"

#define cUrrentCellHeight 72

static NSString *cellid = @"cellid";

@interface WQindividualViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WQUserProfileModel *userModel;
@property (nonatomic, strong) WQworkExperienceTableViewCell *cell;
@property (nonatomic, strong) WQindividualTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *avatarImageViewDict;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *fileID;

@end

@implementation WQindividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQmodifyWork object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"我的信息";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma make - 初始化UI
- (void)setupUI
{
    WQindividualTopView *topView = [[WQindividualTopView alloc]initWithFrame:CGRectMake(0, 0, 0, 162)];
    [topView setPickerClikeBlock:^{
        [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        
            NSString *urlString = @"file/upload";
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"头像更换中…"];
            NSData *data = UIImagePNGRepresentation(image);
            [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:data name:@"file" fileName:@"wanquantupian" mimeType:@"application/octet-stream"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                }
                NSLog(@"success : %@", responseObject);
                
                BOOL successbool = [responseObject[@"success"] boolValue];
                if (successbool) {
                    self.fileID = responseObject[@"fileID"];
                    [SVProgressHUD dismiss];
                    self.avatarImage = image;
                    [self avatarImageView];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error : %@", error);
                
                [SVProgressHUD dismiss];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }];
        }];
    }];
    self.topView = topView;
    
    [self.view addSubview:self.tableView];

    self.tableView.tableHeaderView = topView;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)avatarImageView
{
    NSString *urlString = @"api/user/update";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.avatarImageViewDict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _avatarImageViewDict[@"pic_truename"] = self.fileID;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_avatarImageViewDict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [self loadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:WQpic_truename object:self];
        }
    }];
}

#pragma make - 获取数据
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
            self.topView.avatarImageView.image = self.avatarImage;
            _userModel = [WQUserProfileModel yy_modelWithJSON:response];
            _topView.model = _userModel;
            self.topView.touxiangImageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",_userModel.pic_truename]];
            [_topView.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.topView.touxiangImageUrl] options:0];
            [_tableView reloadData];
        }
    }];
}

#pragma make - 点击事件
- (void)addWorkBtnClike
{
    WQaddWorkViewController *vc = [[WQaddWorkViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addEducationBtnClike
{
    WQWQaddEducationViewController *vc = [[WQWQaddEducationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma make - TableViewDataSource
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    UILabel *jiaoyu = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"教育经历";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHex:0X99999a];
        label;
    });
    UILabel *gongzuo = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"工作经历";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHex:0X99999a];
        label;
    });
    
    return section == 1 ? jiaoyu.text : gongzuo.text;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *addExperience = [[UIView alloc]init];
    UIView *addEducationView = [[UIView alloc]init];
    UIButton *addWorkBtn = [[UIButton alloc ]init];
    [addWorkBtn setTitle:@"添加工作经历" forState:0];
    addWorkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addWorkBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:0];
    [addWorkBtn addTarget:self action:@selector(addWorkBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [addExperience addSubview:addWorkBtn];
    [addWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addExperience.mas_centerX);
    }];
    UIButton *addEducationBtn = [[UIButton alloc]init];
    [addEducationBtn setTitle:@"添加学历经历" forState:0];
    addEducationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addEducationBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:0];
    [addEducationBtn addTarget:self action:@selector(addEducationBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [addEducationView addSubview:addEducationBtn];
    [addEducationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addEducationView.mas_centerX);
    }];
    return section == 1 ? addEducationView : addExperience;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _userModel.work_experience.count;
    }else {
        return _userModel.education.count;
    };
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQworkExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        cell.model = _userModel.work_experience[indexPath.row];
        [cell setModifyBtnClikeBlock:^{
            WQworkExperienceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *type = cell.model.type ? : cell.model.type;
            WQTwoUserProfileModel *model = _userModel.work_experience[indexPath.row];
            WQmodifyWorkViewController *modifyWorkVc = [[WQmodifyWorkViewController alloc]init];
//                                                        WithType:type modelArray:model];
            [weakSelf.navigationController pushViewController:modifyWorkVc animated:YES];
        }];
    }else
    {
        [cell setModifyBtnClikeBlock:^{
            WQworkExperienceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *type = cell.model.type ? : cell.model.type;
            WQTwoUserProfileModel *model = _userModel.education[indexPath.row];
            WQmodifyEducationViewController *modifyEducationVc = [[WQmodifyEducationViewController alloc]initWithType:type model:model];
            [weakSelf.navigationController pushViewController:modifyEducationVc animated:YES];
        }];
        cell.model = _userModel.education[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cUrrentCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ghCellHeight;
}
#pragma make - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerNib:[UINib nibWithNibName:@"WQworkExperienceTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _tableView;
}
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)avatarImageViewDict
{
    if (!_avatarImageViewDict) {
        _avatarImageViewDict = [[NSMutableDictionary alloc]init];
    }
    return _avatarImageViewDict;
}

#pragma make - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
