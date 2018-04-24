//
//  WQNewGroupViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewGroupViewController.h"
#import "WQNewGroupView.h"
#import "WQTextField.h"
#import "WQPrivateCircleView.h"

@interface WQNewGroupViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) WQNewGroupView *wqNewGroupView;
@property (nonatomic, strong) UIBarButtonItem *submitBarItem;

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) WQPrivateCircleView *privateCircleView;

@end

@implementation WQNewGroupViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"新建圈";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *submitBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBarItemCliek)];
    [submitBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    // uitextattributetextcolor替代方法
    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    self.submitBarItem.enabled = YES;
    self.submitBarItem = submitBarItem;
    self.navigationItem.rightBarButtonItem = submitBarItem;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    [self setupNewGroupView];
}

#pragma mark - 初始化UI
- (void)setupNewGroupView {
    WQNewGroupView *newGroupView = [[WQNewGroupView alloc] init];
    self.wqNewGroupView = newGroupView;
    [self.view addSubview:newGroupView];
    [newGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.height.offset(kScaleX(305));
    }];
    
    WQPrivateCircleView *privateCircleView = [[WQPrivateCircleView alloc] init];
    self.privateCircleView = privateCircleView;
    privateCircleView.isNewGroup = YES;
    [self.view addSubview:privateCircleView];
    [privateCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(140));
        make.right.left.equalTo(self.view);
        make.top.equalTo(newGroupView.mas_bottom).offset(kScaleX(ghStatusCellMargin));
    }];
}

// 提交的按钮响应事件
- (void)submitBarItemCliek {
    // 判断有没有群头像
    UIImage *image = [UIImage imageNamed:@"gerenjinglitouxiang"];
    NSData *data1 = UIImagePNGRepresentation(self.wqNewGroupView.headImageView.image);
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqual:data1]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示" message:@"上传一张图片来更好的展现群吧" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.submitBarItem.enabled = YES;
            });
        }];
        return;
    }
    
    // 判断群名是否超过14个字
    if (self.wqNewGroupView.nameInputBoxTextField.text.length > 14) {
        [SVProgressHUD dismiss];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈名称请勿输入超14个字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.submitBarItem.enabled = YES;
            });
        }];
        return;
        
    }
    // 判断是否有输入群名
    NSString *nameString = [self.wqNewGroupView.nameInputBoxTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([nameString length] == 0) {
        [SVProgressHUD dismiss];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"给自己的圈子起个好名字吧" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.submitBarItem.enabled = YES;
            });
        }];
        return;
    }
    // 判断是否输入群介绍
    NSString *contentString = [self.wqNewGroupView.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([contentString length] == 0) {
        [SVProgressHUD dismiss];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"详细的圈介绍，能吸引更多适合的用户加入呢" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.submitBarItem.enabled = YES;
            });
        }];
        return;
    }
    // 判断群介绍是否超过256个字符
    if (self.wqNewGroupView.contentTextView.text.length > 256) {
        [SVProgressHUD dismiss];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈介绍请控制在256个字符以内" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.submitBarItem.enabled = YES;
            });
        }];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"圈子名称创建后不可更改"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.submitBarItem.enabled = NO;
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在创建中,请稍后..."];
        
        NSString *urlString = @"file/upload";
        
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData * data = UIImageJPEGRepresentation(self.wqNewGroupView.headImageView.image, 0.7);
            [formData appendPartWithFileData:data name:@"file" fileName:@"群组头像" mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            BOOL successbool = [responseObject[@"success"] boolValue];
            if (successbool) {
                NSString *imageId = responseObject[@"fileID"];
                [self uploadaddImageId:imageId];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
            self.submitBarItem.enabled = YES;
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈图像上传不成功，请重试" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }];
    }];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)uploadaddImageId:(NSString *)imageId {
    
    NSString *urlString = @"api/group/creategroup";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _params[@"pic"] = imageId;
    _params[@"name"] = self.wqNewGroupView.nameInputBoxTextField.text;
    _params[@"description"] = self.wqNewGroupView.contentTextView.text;
    if (self.privateCircleView.wqSwitch.on) {
        _params[@"privacy"] = @"true";
    }else {
        _params[@"privacy"] = @"false";
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD dismiss];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"提交成功，请等待审核" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
            self.submitBarItem.enabled = YES;
        }else {
            [SVProgressHUD dismiss];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            self.submitBarItem.enabled = YES;
        }
    }];
}

- (void)back {
    // 判断有没有群头像,是否有输入群名,是否输入群介绍
    UIImage *image = [UIImage imageNamed:@"gerenjinglitouxiang"];
    NSData *data1 = UIImagePNGRepresentation(self.wqNewGroupView.headImageView.image);
    NSData *data = UIImagePNGRepresentation(image);
    NSString *nameString = [self.wqNewGroupView.nameInputBoxTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contentString = [self.wqNewGroupView.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([data isEqual:data1] && [nameString length] == 0 && [contentString length] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃已编辑内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:cancle];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -- 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

@end
