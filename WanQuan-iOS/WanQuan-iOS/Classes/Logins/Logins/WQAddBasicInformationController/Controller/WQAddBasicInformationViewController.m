//
//  WQAddBasicInformationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddBasicInformationViewController.h"
#import "WQForeignInformationViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController+WQCircleCrop.h"
#import "WQloginModel.h"
#import "WQBottomPopupWindowView.h"
#import "WQAddressBookFriendsViewController.h"

@interface WQAddBasicInformationViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,WQBottomPopupWindowViewDelegate>

/**
 图片在相册中的 id
 */
@property (nonatomic, copy) NSString *imageId;

/**
 头像的按钮
 */
@property (nonatomic, strong) UIButton *headPortraitBtn;

/**
 头像上传成功后的id
 */
@property (nonatomic, copy) NSString *pic_truenamefileID;

@property (nonatomic, strong) WQBottomPopupWindowView *bottomPopupWindowView;
@end

@implementation WQAddBasicInformationViewController {
    // 姓名的输入框
    UITextField *nameTextField;
    // 证件号的输入框
    UITextField *idNumberTextField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    if (!self.isInviteCode) {
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)backgroundImageViewClick {
    [self.view endEditing:YES];
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registeredbeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backgroundImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundImageViewClick)];
    [backgroundImageView addGestureRecognizer:backgroundImageViewTap];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"最后一步: 补充基本信息" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:21];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kScaleX(100));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *tagLabel = [UILabel labelWithText:@"您的信息仅用于验证和保护会员身份,\n绝不会被泄漏" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    tagLabel.numberOfLines = 0;
    [self.view addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    // 头像
    UIButton *headPortraitBtn = [[UIButton alloc] init];
    self.headPortraitBtn = headPortraitBtn;
    headPortraitBtn.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitBtn.layer.cornerRadius = 30;
    headPortraitBtn.layer.masksToBounds = YES;
    [headPortraitBtn addTarget:self action:@selector(headPortraitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headPortraitBtn setImage:[UIImage imageNamed:@"denglushoujizhucetouxiang"] forState:UIControlStateNormal];
    [self.view addSubview:headPortraitBtn];
    [headPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLabel.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    // 头像下边的相机
    UIButton *cameraBtn = [[UIButton alloc] init];
    [cameraBtn addTarget:self action:@selector(headPortraitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setImage:[UIImage imageNamed:@"zhucezhaoxiangji"] forState:UIControlStateNormal];
    [self.view addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(headPortraitBtn);
    }];
    
    // 头像Label
    UILabel *headPortraitLabel = [UILabel labelWithText:@"真实头像" andTextColor:[UIColor colorWithHex:0xb2b2b2] andFontSize:14];
    [self.view addSubview:headPortraitLabel];
    [headPortraitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(headPortraitBtn.mas_bottom).offset(kScaleX(ghStatusCellMargin));
    }];
    
    // 姓名
    UILabel *nameLabel = [UILabel labelWithText:@"真实姓名 " andTextColor:[UIColor colorWithHex:0xb2b2b2] andFontSize:16];
    nameTextField = [[UITextField alloc] init];
    nameTextField.leftView = nameLabel;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    nameTextField.textAlignment = NSTextAlignmentRight;
    nameTextField.placeholder = @"输入真实名称";
    nameTextField.userInteractionEnabled = YES;
    nameTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self.view addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headPortraitLabel.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view).offset(kScaleY(65));
        make.right.equalTo(self.view).offset(kScaleY(-65));
        make.height.offset(kScaleX(55));
    }];
    
    // 姓名下的分割线
    UIView *nameBottomLineView = [[UIView alloc] init];
    nameBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:nameBottomLineView];
    [nameBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.equalTo(nameTextField);
        make.top.equalTo(nameTextField.mas_bottom);
    }];
    
    // 身份证号
    UILabel *idNumberLabel = [UILabel labelWithText:@"身份证号 " andTextColor:[UIColor colorWithHex:0xb2b2b2] andFontSize:16];
    idNumberTextField = [[UITextField alloc] init];
    idNumberTextField.leftView = idNumberLabel;
    idNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    idNumberTextField.textAlignment = NSTextAlignmentRight;
    idNumberTextField.placeholder = @"输入证件号码";
    idNumberTextField.userInteractionEnabled = YES;
    idNumberTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self.view addSubview:idNumberTextField];
    [idNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameBottomLineView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.right.equalTo(nameTextField);
        make.height.offset(kScaleX(55));
    }];
    
    // 证件号下的分割线
    UIView *idNumberBottomLineView = [[UIView alloc] init];
    idNumberBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:idNumberBottomLineView];
    [idNumberBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.equalTo(nameBottomLineView);
        make.top.equalTo(idNumberTextField.mas_bottom);
    }];
    
    UIButton *thereIsNoBtn = [[UIButton alloc] init];
    thereIsNoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [thereIsNoBtn addTarget:self action:@selector(thereIsNoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [thereIsNoBtn setTitle:@"没有中国大陆身份证?" forState:UIControlStateNormal];
    [thereIsNoBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.view addSubview:thereIsNoBtn];
    [thereIsNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idNumberBottomLineView.mas_bottom).offset(kScaleX(ghStatusCellMargin));
        make.right.equalTo(idNumberBottomLineView.mas_right);
    }];
    
    // 完成的按钮
    UIButton *completeBtn = [[UIButton alloc] init];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    completeBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.masksToBounds = YES;
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(45)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(kScaleX(-80));
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

#pragma mark -- 头像的响应事件
- (void)headPortraitBtnClick {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
//    [sheet showInView:self.view];
    self.bottomPopupWindowView.hidden = NO;
}

#pragma mark -- WQBottomPopupWindowViewDelegate
- (void)wqFinishAction:(WQBottomPopupWindowView *)bottomPopupWindowView image:(UIImage *)image {
    self.bottomPopupWindowView.hidden = YES;
    
    [self.headPortraitBtn setImage:image forState:UIControlStateNormal];
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
        
        self.pic_truenamefileID = responseObject[@"fileID"];
        [SVProgressHUD dismissWithDelay:0.3];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [SVProgressHUD dismissWithDelay:0.2];
    }];
}

- (void)wqDeleteBtnClick:(WQBottomPopupWindowView *)bottomPopupWindowView {
    self.bottomPopupWindowView.hidden = YES;
}

#pragma mark -- 完成的响应事件
- (void)completeBtnClick {
    UIImage *image = [UIImage imageNamed:@"denglushoujizhucetouxiang"];
    NSData *data1 = UIImagePNGRepresentation(self.headPortraitBtn.imageView.image);
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqual:data1]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请上传头像" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if (![nameTextField.text isVisibleString]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请输入真实姓名" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (![idNumberTextField.text isVisibleString]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请输入身份证号" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if (![self validateIdentityCard:idNumberTextField.text]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请输入正确的身份证号" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    [self upDataImageId:self.pic_truenamefileID];
}

- (void)upDataImageId:(NSString *)ImageId {
    NSString *urlString = @"api/user/register2/s2truenamecn";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pic_truename"] = ImageId;
    params[@"true_name"] = nameTextField.text;
    params[@"idcard"] = idNumberTextField.text;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"plugin_alumnus_class_id"] = self.class_idString;
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
            [WQDataSource sharedTool].join_alumnus_group_match = [response[@"join_alumnus_group_match"] boolValue];
            [WQDataSource sharedTool].isHiddenVisitorsToLoginPopupWindowView = YES;
            [WQDataSource sharedTool].join_alumnus_group_success = [response[@"join_alumnus_group_success"] boolValue];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 没有加入成功的圈id   圈名称   圈头像
            [userDefaults setObject:response[@"join_alumnus_recommend_group_id"] forKey:@"join_alumnus_recommend_group_id"];
            [userDefaults setObject:response[@"join_alumnus_recommend_group_name"] forKey:@"join_alumnus_recommend_group_name"];
            [userDefaults setObject:response[@"join_alumnus_recommend_group_pic"] forKey:@"join_alumnus_recommend_group_pic"];
            [self login];
        }else {
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

- (void)login {
    NSString *urlString = @"api/user/login";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = [WQDataSource sharedTool].cellphone;
    params[@"password"] = [WQDataSource sharedTool].password;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
//        NSString *im_namelogin = response[@"im_namelogin"];
//        NSString *im_password = response[@"im_password"];
//        [JPUSHService setAlias:im_namelogin
//              callbackSelector:nil
//                        object:nil];
//        
//        [WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
        
        if ([response[@"success"] boolValue]) {

            NSString *im_namelogin = response[@"im_namelogin"];
            NSString *im_password = response[@"im_password"];
            [JPUSHService setAlias:im_namelogin
                  callbackSelector:nil
                            object:nil];
            
            // [WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
            WQloginModel *model = [WQloginModel new];
            model.access_token = response[@"secretkey"];
            NSString *secretkey = response[@"secretkey"];
            [WQSingleton sharedManager].userIMId = im_namelogin;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
            [WQDataSource sharedTool].secretkey = response[@"secretkey"] ;
            [self loadBasicInfo:[WQDataSource sharedTool].secretkey];
            //[WQDataSource sharedTool].join_alumnus_group_success = YES;
            [userDefaults setObject:response[@"im_namelogin"] forKey:@"im_namelogin"];
            [userDefaults setObject:response[@"im_password"] forKey:@"im_password"];
            [userDefaults setObject:response[@"role_id"] forKey:@"role_id"];
            // 转换为可识别的时间
            NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[response[@"expiredtime"] doubleValue] / 1000];
            model.expiredtime = timeDate;
            [[WQSingleton sharedManager]saveAccount:model];
            //[WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
            [[EMClient sharedClient] loginWithUsername:im_namelogin password:im_password completion:^(NSString *aUsername, EMError *aError) {
                if (aError) {
                    NSLog(@"_____环信登录失败____原因 %@",aError.errorDescription);
                } else {
                    NSLog(@"_____环信登录成功");
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
            }];
            BOOL successbool = [response[@"success"] boolValue];
            if (successbool) {
                //[UIApplication sharedApplication].keyWindow.rootViewController = vc;
                WQAddressBookFriendsViewController *vc = [[WQAddressBookFriendsViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
//                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (void)loadBasicInfo:(NSString *)secretKey {
    NSString *urlString = @"api/user/getbasicinfo";
    //NSDictionary *dict = @{@"secretkey":secretKey};
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = secretKey;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        
        NSLog(@"%@",response);
        WQUserProfileModel *model = [WQUserProfileModel yy_modelWithJSON:response];
        
        [WQDataSource sharedTool].loginStatus = response[@"idcard_status"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:model.true_name forKey:@"true_name"];
        [userDefaults setObject:model.pic_truename forKey:@"pic_truename"];
        [userDefaults setObject:model.flower_name forKey:@"flower_name"];
        [userDefaults setObject:model.pic_flowername forKey:@"pic_flowername"];
        [userDefaults synchronize];
    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        if (!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined)) {
            if (![[WQAuthorityManager manger] haveCameraAuthority]) {
                
                [[WQAuthorityManager manger] showAlertForCameraAuthority];
                return;
            }
        }
        
        if (!([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined)) {
            if (![[WQAuthorityManager manger] haveAlbumAuthority]) {
                
                [[WQAuthorityManager manger] showAlertForAlbumAuthority];
                return;
            }
        }
        
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
        }];
    }else if ([title isEqualToString:@"相册"]) {
        if (![[WQAuthorityManager manger] haveAlbumAuthority]) {
            [[WQAuthorityManager manger] showAlertForAlbumAuthority];
            return;
        }
        //    使用第三方的相册选择照片
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        picker.allowTakePicture = NO;
        picker.isStatusBarDefault = YES;
        picker.allowPickingGif = NO;
        picker.allowPickingVideo = NO;
        
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
        picker.automaticallyAdjustsScrollViewInsets = NO;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak typeof(self)  weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        //        现将图片保存到相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:info[UIImagePickerControllerOriginalImage]];
            weakself.imageId =  req.placeholderForCreatedAsset.localIdentifier;
            
            NSLog(@"%@",weakself.imageId);
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            __block PHAsset *imageAsset = nil;

            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[weakself.imageId] options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                //                然后进入裁剪页面
                TZImagePickerController * picker1 = [[TZImagePickerController alloc] WQinitCropTypeWithAsset:imageAsset photo:info[UIImagePickerControllerOriginalImage] completion:^(UIImage *cropImage, id asset) {
                    //                    裁剪成功回传图片
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(wqFinishAction:image:)]) {
//                        [self.delegate wqFinishAction:self image:cropImage];
//                    }
                    [self.headPortraitBtn setImage:cropImage forState:UIControlStateNormal];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:picker1 animated:YES completion:nil];
                });
                
            }];
        }];
    }];
    
}


#pragma mark -TZimagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    __weak typeof(self) weakself = self;
    
    TZImagePickerController * picker1 = [[TZImagePickerController alloc] WQinitCropTypeWithAsset:assets[0] photo:photos[0] completion:^(UIImage *cropImage, id asset) {
        //        回传图片
//        if (self.delegate && [self.delegate respondsToSelector:@selector(wqFinishAction:image:)]) {
//            [self.delegate wqFinishAction:self image:cropImage];
//        }
        [self.headPortraitBtn setImage:cropImage forState:UIControlStateNormal];
    }];
    picker1.isStatusBarDefault = YES;
    picker1.allowPickingGif = NO;
    picker1.allowPickingVideo = NO;
    
    picker1.navigationBar.tintColor = [UIColor whiteColor];
    [picker1.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker1.automaticallyAdjustsScrollViewInsets = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:picker1 animated:YES completion:nil];
    });
    
}

#pragma mark -- 没有中国大陆身份证响应事件
- (void)thereIsNoBtnClick {
    WQForeignInformationViewController *vc = [[WQForeignInformationViewController alloc] init];
    vc.class_idString = self.class_idString;
    [self.navigationController pushViewController:vc animated:YES];
}

//判断身份证号15-18位数字
- (BOOL)validateIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

@end
