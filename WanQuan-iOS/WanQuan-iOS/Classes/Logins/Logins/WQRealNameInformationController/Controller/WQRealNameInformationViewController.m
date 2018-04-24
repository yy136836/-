//
//  WQRealNameInformationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRealNameInformationViewController.h"
#import "WQloginModel.h"
#import "WQBottomPopupWindowView.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface WQRealNameInformationViewController () <WQBottomPopupWindowViewDelegate>
@property (nonatomic, strong) WQBottomPopupWindowView *bottomPopupWindowView;
// 真实头像id
@property (nonatomic, copy) NSString *pic_truenamefileID;
// 身份证图片Id  因为后天要的是array格式
@property (nonatomic, strong) NSMutableArray *idArray;
@end

@implementation WQRealNameInformationViewController {
    UILabel *hasBeenRegisteredLabel;
    // 头像
    UIImageView *headportraitImageView;
    // 真实姓名的输入框
    UITextField *realNameTextField;
    // 身份证号的输入框
    UITextField *idNumberTextField;
    // 证件照
    UIImageView *profilePicture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadData];
    [self obtainSecretkey];
}

// 初始化view
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registeredbeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 欢迎来到万圈
    UILabel *tagLabel = [UILabel labelWithText:@"补 充 实 名 信 息" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:30];
    tagLabel.font = [UIFont fontWithName:@".PingFangSC-Thin" size:30];
    [backgroundImageView addSubview:tagLabel];
    // 5的话字体为26
    if (iPhone5) {
        tagLabel.font = [UIFont systemFontOfSize:26];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view).offset(kScaleX(40));
        }];
    }else {
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view).offset(kScaleX(112));
        }];
    }
    
    // 多少人已经注册
    hasBeenRegisteredLabel = [UILabel labelWithText:@"名清华校友已实名认证" andTextColor:[UIColor colorWithHex:0x535353] andFontSize:17];
    [self.view addSubview:hasBeenRegisteredLabel];
    [hasBeenRegisteredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(tagLabel.mas_bottom).offset(ghSpacingOfshiwu);
    }];

    // 背景图
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengluzhucebeijing"]];
    backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hasBeenRegisteredLabel.mas_bottom).offset(kScaleX(35));
        make.height.offset(kScaleX(343));
        make.left.equalTo(self.view).offset(kScaleY(45));
        make.right.equalTo(self.view).offset(kScaleY(-45));
    }];
    
    // 头像
    headportraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglushoujizhucetouxiang"]];
    headportraitImageView.userInteractionEnabled = YES;
    headportraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    headportraitImageView.layer.cornerRadius = 30;
    headportraitImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headportraitImageViewClick)];
    [headportraitImageView addGestureRecognizer:tap];
    [backgroundView addSubview:headportraitImageView];
    [headportraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(60), kScaleX(60)));
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-ghDistanceershi));
        make.top.equalTo(backgroundView.mas_top).offset(kScaleX(-ghSpacingOfshiwu));
    }];
    
    // 上传真实头像
    UILabel *headportraitLabel = [UILabel labelWithText:@"上传真实头像" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:16];
    [self.view addSubview:headportraitLabel];
    [headportraitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_top).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghDistanceershi));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(ghDistanceershi);
        make.right.equalTo(backgroundView).offset(-ghDistanceershi);
        make.top.equalTo(headportraitImageView.mas_bottom).offset(kScaleX(12));
        make.height.offset(0.5);
    }];
    
    // 真实姓名
    UILabel *realNameLabel = [UILabel labelWithText:@"真实姓名" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:16];
    [self.view addSubview:realNameLabel];
    [realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghDistanceershi));
        make.width.offset(kScaleY(70));
    }];
    
    // 真实姓名的输入框
    realNameTextField = [[UITextField alloc] init];
    realNameTextField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:realNameTextField];
    [realNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-5);
        make.left.equalTo(realNameLabel.mas_right).offset(5);
        make.centerY.equalTo(realNameLabel.mas_centerY);
    }];
    
    // 分割线
    UIView *twoLineView = [[UIView alloc] init];
    twoLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:twoLineView];
    [twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(ghDistanceershi);
        make.right.equalTo(backgroundView).offset(-ghDistanceershi);
        make.top.equalTo(realNameLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.height.offset(0.5);
    }];
    
    // 身份证号
    UILabel *idNumber = [UILabel labelWithText:@"身份证号" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:16];
    [self.view addSubview:idNumber];
    [idNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghDistanceershi));
        make.width.offset(kScaleY(70));
    }];
    
    // 身份证号的输入框
    idNumberTextField = [[UITextField alloc] init];
    idNumberTextField.textAlignment = NSTextAlignmentRight;
    idNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:idNumberTextField];
    [idNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-5);
        make.left.equalTo(idNumber.mas_right).offset(5);
        make.centerY.equalTo(idNumber.mas_centerY);
    }];
    
    // 身份证号下的分割线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(kScaleY(ghDistanceershi));
        make.right.equalTo(backgroundView).offset(kScaleY(-ghDistanceershi));
        make.top.equalTo(idNumber.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.height.offset(0.5);
    }];
    
    // 证件照
    profilePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglushangchuanzhengjianzhaopian"]];
    profilePicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *profilePicturetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profilePictureClick)];
    [profilePicture addGestureRecognizer:profilePicturetap];
    [self.view addSubview:profilePicture];
    [profilePicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(64), kScaleX(64)));
        make.top.equalTo(bottomLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-ghDistanceershi));
    }];
    
    // 证件照边上的提示文案
    UILabel *promptLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"上传证件照片"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"  (以下均可)\n身份证、驾驶证、居住证、\n社保卡、英语四六级证书"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999]}]];
    promptLabel.attributedText = str;
    promptLabel.numberOfLines = 3;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(profilePicture.mas_top);
        make.right.equalTo(profilePicture.mas_left).offset(kScaleY(-ghStatusCellMargin));
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghDistanceershi));
    }];
    
    // 提交的按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom).offset(kScaleX(-30));
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-ghDistanceershi));
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghDistanceershi));
        make.height.offset(kScaleX(45));
    }];
    
    // 底部的label
    UILabel *bottomLabel = [UILabel labelWithText:@"实名注册可获得更多的使用权限、更高的信用分数。\n您的信息仅用于验证和保护会员身份，不会被泄漏。" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    bottomLabel.numberOfLines = 2;
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 以后再说下边的三角
    UIButton *laterBnt = [[UIButton alloc] init];
    [laterBnt setImage:[UIImage imageNamed:@"denglujiantouxia"] forState:UIControlStateNormal];
    [laterBnt addTarget:self action:@selector(laterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:laterBnt];
    [laterBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kScaleX(ghSpacingOfshiwu));
    }];
    
    // 以后再说的按钮
    UIButton *visitorsLoginBtn = [[UIButton alloc] init];
    visitorsLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [visitorsLoginBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [visitorsLoginBtn addTarget:self action:@selector(laterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [visitorsLoginBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.view addSubview:visitorsLoginBtn];
    [visitorsLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(laterBnt.mas_top).offset(kScaleX(5));
    }];
    // 弹窗
    WQBottomPopupWindowView *bottomPopupWindowView = [[WQBottomPopupWindowView alloc] init];
    bottomPopupWindowView.delegate = self;
    self.bottomPopupWindowView = bottomPopupWindowView;
    bottomPopupWindowView.hidden = YES;
    [self.view addSubview:bottomPopupWindowView];
    [bottomPopupWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -- 获取secretkey
- (void)obtainSecretkey {
    NSString *urlString = @"api/user/login";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.phoneString;
    params[@"password"] = [self.passwordString md5String];
    //params[@"cellphone"] = @"15901458105";
    //params[@"password"] = [@"123456" md5String];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请检查手机号" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               });
            }];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        [WQDataSource sharedTool].secretkey = response[@"secretkey"] ;
    }];
}

#pragma mark -- WQBottomPopupWindowViewDelegate
- (void)wqFinishAction:(WQBottomPopupWindowView *)bottomPopupWindowView image:(UIImage *)image {
    self.bottomPopupWindowView.hidden = YES;
    
    // 是证件照
    if (self.bottomPopupWindowView.isIdcard_pic) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"上传中…"];
        UIImage *jinyongyuwanquanzhuce = [UIImage imageNamed:@"jinyongyuwanquanzhuce"];
        
        UIImage *image1 = image;
        UIImage *image2 = jinyongyuwanquanzhuce;
        
        UIGraphicsBeginImageContext(image1.size);
        
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        
        [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        profilePicture.image = resultingImage;
        [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData * data = UIImageJPEGRepresentation(resultingImage, 0.1);
            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            [self.idArray addObject:responseObject[@"fileID"]];
            [SVProgressHUD dismissWithDelay:0.3];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismissWithDelay:0.2];
        }];
    }else {
        // 真实头像
        headportraitImageView.image = image;
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"上传中…"];
        [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData * data = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            NSString *pic_truenamefileID = responseObject[@"fileID"];
            self.pic_truenamefileID = pic_truenamefileID;
            [SVProgressHUD dismissWithDelay:0.3];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismissWithDelay:0.2];
        }];
    }
}
- (void)wqDeleteBtnClick:(WQBottomPopupWindowView *)bottomPopupWindowView {
    bottomPopupWindowView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [idNumberTextField endEditing:YES];
    [realNameTextField endEditing:YES];
}

#pragma mark -- 头像的响应事件
- (void)headportraitImageViewClick {
    self.bottomPopupWindowView.hidden = NO;
    self.bottomPopupWindowView.isIdcard_pic = NO;
}

#pragma mark -- 证件照的响应事件
- (void)profilePictureClick {
    self.bottomPopupWindowView.hidden = NO;
    self.bottomPopupWindowView.isIdcard_pic = YES;
}

#pragma mark -- 提交的响应事件
- (void)submitBtnClick {
    
    NSString *urlString = @"api/user/verifytruename";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:self.idArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"true_name"] = realNameTextField.text;
    params[@"idcard"] = idNumberTextField.text;
    params[@"pic_truename"] = self.pic_truenamefileID;
    params[@"idcard_pic"] = idcardStr;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"您的信息已提交审核" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                                   [self laterBtnClick];
                               });
            }];
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               });
            }];
            [self laterBtnClick];
        }
    }];
    
}

#pragma mark -- 以后再说
- (void)laterBtnClick {
    // 相当于不实名认证,快速注册登录
    [self.view endEditing:YES];
    
    NSString *urlString = @"api/user/login";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.phoneString;
    params[@"password"] = [self.passwordString md5String];
    //params[@"cellphone"] = @"15901458105";
    //params[@"password"] = [@"123456" md5String];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请检查手机号" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               });
            }];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        NSString *im_namelogin = response[@"im_namelogin"];
        NSString *im_password = response[@"im_password"];
        [JPUSHService setAlias:im_namelogin
              callbackSelector:nil
                        object:nil];
        [[EMClient sharedClient] loginWithUsername:im_namelogin password:im_password completion:^(NSString *aUsername, EMError *aError) {
            if (aError) {
                NSLog(@"_____环信登录失败____原因 %@",aError.errorDescription);
            } else {
                NSLog(@"_____环信登录成功");
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }
        }];
        // [WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
        
        if (response[@"success"]) {
            WQTabBarController *vc = [WQTabBarController new];
            WQloginModel *model = [WQloginModel new];
            model.access_token = response[@"secretkey"];
            NSString *secretkey = response[@"secretkey"];
            //[self loadBasicInfo:secretkey];
            [WQSingleton sharedManager].userIMId = im_namelogin;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
            [WQDataSource sharedTool].secretkey = response[@"secretkey"] ;
            [userDefaults setObject:response[@"im_namelogin"] forKey:@"im_namelogin"];
            [userDefaults setObject:response[@"im_password"] forKey:@"im_password"];
            [userDefaults setObject:response[@"role_id"] forKey:@"role_id"];
            // 转换为可识别的时间
            NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[response[@"expiredtime"] doubleValue] / 1000];
            model.expiredtime = timeDate;
            [[WQSingleton sharedManager]saveAccount:model];
            BOOL successbool = [response[@"success"] boolValue];
            if (successbool) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            } else {
                
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC
                                   animated:YES completion:^{
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                                    (int64_t)(1 * NSEC_PER_SEC)),
                                                      dispatch_get_main_queue(), ^{
                                                          [alertVC dismissViewControllerAnimated:YES completion:nil];
                                                      });
                                   }];
                return;
            }
        }
    }];
}

#pragma mark -- 获取已注册人数
- (void)loadData {
    NSString *urlString = @"api/system/init";
    NSDictionary *params = [[NSDictionary alloc] init];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"user_count"]]
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x844dc5]}]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"名清华校友已实名注册"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x535353]}]];
            hasBeenRegisteredLabel.attributedText = str;
        }
    }];
}

#pragma mark -- 懒加载
- (NSString *)pic_truenamefileID {
    if (!_pic_truenamefileID) {
        _pic_truenamefileID = [[NSString alloc] init];
    }
    return _pic_truenamefileID;
}

- (NSMutableArray *)idArray {
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}

@end
