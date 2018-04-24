//
//  WQComfimController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQComfimController.h"
#import "WQConfimCell.h"
#import "WQConfimInfoCell.h"
#import "BDImagePicker.h"
#import "WQUploadIdentificationController.h"
#import "WQConfimModel.h"
#import "WQUserProfileTableFooterView.h"

#define TITLES @[@"头像",@"真实姓名",@"身份证明",@"登录账号"]


@interface WQComfimController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, retain) WQConfimModel * model;
@end

@implementation WQComfimController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commit)];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _model = [[WQConfimModel alloc] init];
    [self setUpUI];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - UI
- (void)setUpUI {
    
    UITableView * table = [[UITableView alloc] init];
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view);
    }];
    table.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [table registerNib:[UINib nibWithNibName:@"WQConfimCell" bundle:nil] forCellReuseIdentifier:@"confimCell"];
    [table registerNib:[UINib nibWithNibName:@"WQConfimInfoCell" bundle:nil] forCellReuseIdentifier:@"confimInfoCell"];
    table.tableFooterView = [UIView new];
    
    NSArray  *viewArray = [[NSBundle mainBundle]loadNibNamed:@"WQUserProfileTableFooterView" owner:nil options:nil];
    WQUserProfileTableFooterView *footer = [viewArray firstObject];
    //加载视图
    footer.titleLabel.textColor = [UIColor colorWithHex:0xf19119];
    footer.conttentLabel.textColor = [UIColor colorWithHex:0xf19119];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 60);
    table.tableFooterView = footer;
    
    table.tableHeaderView = [UIView new];
    table.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 56;
    } else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TITLES.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.row) {
        WQConfimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"confimCell"];
        
        cell.titleLabel.text = TITLES[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        WQConfimInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"confimInfoCell"];
        
        cell.titleLabel.text = TITLES[indexPath.row];
        
        if ([TITLES[indexPath.row] isEqualToString:@"登录账号"]) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.nameField.hidden = YES;
            cell.numberLabel.text = self.phoneNumber;
        } else if([TITLES[indexPath.row] isEqualToString:@"身份证明"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.nameField.hidden = YES;
        } else if([TITLES[indexPath.row] isEqualToString:@"真实姓名"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.nameField.hidden = NO;
            cell.nameField.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [self.view endEditing:YES];
    switch (row) {
        case 0:{
            [self.view endEditing:YES];
            
            
            __weak typeof(self) weakSelf = self;
            
            [BDImagePicker showImagePickerFromViewController:self allowsEditing:NO finishAction:^(UIImage *image) {
                
                if (!image) {
                    return ;
                }
                
                NSData *data = UIImageJPEGRepresentation(image,0.7);
                NSString *urlString = @"file/upload";
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD showWithStatus:@"图片上传中…"];
                [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString * fileName = [NSUUID UUID].UUIDString;
                    
                    
                    [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {

                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    
                    
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    }
                    
                    

                    
                    if (!responseObject[@"success"]) {
                        return;
                    }
                    if (responseObject[@"message"]) {
                        [SVProgressHUD showWithStatus:responseObject[@"message"]];
                    } else {
                        [SVProgressHUD showWithStatus:@"上传成功"];
                    }
                    
                    [SVProgressHUD dismissWithDelay:1];
                    NSLog(@"success : %@", responseObject);
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    }
                    WQConfimCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.avatar.image = image;
                    
                    _model.pic_truename = responseObject[@"fileID"];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD showWithStatus:@"上传失败请重试"];
                    [SVProgressHUD dismissWithDelay:1];
                    NSLog(@"error : %@", error);
                }];
            }];
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            WQUploadIdentificationController * vc = [[WQUploadIdentificationController alloc] init];
            
            vc.savInfo = ^(NSArray *criditPhotoIDs, NSString *criditNumber) {
                _model.idcard_pic = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:criditPhotoIDs options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                _model.idcard = criditNumber;
                
                WQConfimInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                
                cell.numberLabel.text = criditNumber;
                
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
    
    
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    _model.true_name = textField.text;
}


#pragma mark - Actions
- (void)commit {
    if ((!_model.true_name.length)||
        (!_model.idcard.length)||
        (!_model.pic_truename.length)||
        (!_model.idcard_pic.length)) {
        
        [WQAlert showAttributedAlertWith:@"请将信息补充完整" titleColor:[UIColor colorWithHex:0x5d2a89] titleFont:nil message:nil messageColor:nil messageFont:nil  duration:1.5];
        return;
    }
    
    
    

    
    
    
    UIAlertController * alert =
    [UIAlertController alertControllerWithTitle:nil message:@"填写内容保存成功后不可更改" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitle
    //                                                          style:UIAlertActionStyleDefault
    //                                                        handler:actions[i]];
    //
    //        if ([action valueForKey:@"titleTextColor"]) {
    //            [action setValue:colors[i] forKey:@"titleTextColor"];
    //        }

    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    
    UIAlertAction * upload = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * params = [[_model yy_modelToJSONObject] mutableCopy];
        
        NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
        if (!secreteKey.length) {
            return;
        }
        
        params[@"secretkey"] = secreteKey;
        
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:@"api/user/verifytruename" parameters:params completion:^(id response, NSError *error) {
            if (error || ![response[@"success"] boolValue]) {
                
                if ([response[@"message"] length]) {
                    
                    [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.5];
                    
                } else {
                    [WQAlert showAlertWithTitle:nil message:@"网络异常,请重试" duration:1.5];
                    return;
                }
                
                
                
                
            } else {
                
                if ([response[@"message"] length]) {
                    
                    [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.5];
                    
                } else {
                    [WQAlert showAlertWithTitle:nil message:@"申请提交成功，请等待审核" duration:1.5];
                }
 
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1.6 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(),
                               ^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               });
            }
        }];
        
    }];
    
    [alert addAction:upload];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
