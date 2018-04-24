//
//  WQForeignInformationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQForeignInformationViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController+WQCircleCrop.h"
#import "WQLogInController.h"
#import "WQBottomPopupWindowView.h"

@interface WQForeignInformationViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,WQBottomPopupWindowViewDelegate>
/**
 图片在相册中的 id
 */
@property (nonatomic, copy) NSString *imageId;

/**
 头像id
 */
@property (nonatomic, copy) NSString *pic_truenamefileID;

/**
 证件照的id 后台要数组
 */
@property (nonatomic, strong) NSMutableArray *passportidArray;

@property (nonatomic, strong) WQBottomPopupWindowView *bottomPopupWindowView;
@end

@implementation WQForeignInformationViewController {
    // 头像
    UIButton *headPortraitBtn;
    // 证件照
    UIButton *passportBtn;
    // 姓名的输入框
    UITextField *nameTextField;
    // 国籍的输入框
    UITextField *nationalityTextField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
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
    
    UILabel *textLabel = [UILabel labelWithText:@"非大陆用户基本信息" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:21];
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
    headPortraitBtn = [[UIButton alloc] init];
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
    nameTextField.textAlignment = NSTextAlignmentRight;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
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
    
    // 国籍
    UILabel *nationalityLabel = [UILabel labelWithText:@"国籍 " andTextColor:[UIColor colorWithHex:0xb2b2b2] andFontSize:16];
    nationalityTextField = [[UITextField alloc] init];
    nationalityTextField.leftView = nationalityLabel;
    nationalityTextField.textAlignment = NSTextAlignmentRight;
    nationalityTextField.leftViewMode = UITextFieldViewModeAlways;
    nationalityTextField.placeholder = @"输入国籍";
    nationalityTextField.userInteractionEnabled = YES;
    nationalityTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self.view addSubview:nationalityTextField];
    [nationalityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameBottomLineView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.right.equalTo(nameTextField);
        make.height.offset(kScaleX(55));
    }];
    
    // 国籍下的分割线
    UIView *nationalityBottomLineView = [[UIView alloc] init];
    nationalityBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:nationalityBottomLineView];
    [nationalityBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nationalityTextField.mas_bottom);
        make.left.right.equalTo(nameBottomLineView);
        make.height.offset(0.5);
    }];
    
    // 护照
    UILabel *passportLabel = [UILabel labelWithText:@"上传护照首页照片" andTextColor:[UIColor colorWithHex:0xb2b2b2] andFontSize:16];
    [self.view addSubview:passportLabel];
    [passportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nationalityBottomLineView.mas_left);
        make.top.equalTo(nationalityBottomLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
    }];
    
    passportBtn = [[UIButton alloc] init];
    [passportBtn addTarget:self action:@selector(passportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [passportBtn setImage:[UIImage imageNamed:@"zhuceshangchuanzhengjianzhaopian"] forState:UIControlStateNormal];
    [self.view addSubview:passportBtn];
    [passportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passportLabel.mas_centerY);
        make.right.equalTo(nationalityBottomLineView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScaleY(45), kScaleX(45)));
    }];
    
    // 护照下的分割线
    UIView *passportBottomLineView = [[UIView alloc] init];
    passportBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:passportBottomLineView];
    [passportBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(nationalityBottomLineView);
        make.height.offset(0.5);
        make.top.equalTo(passportLabel.mas_bottom).offset(kScaleX(18));
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

#pragma mark -- WQBottomPopupWindowViewDelegate
- (void)wqFinishAction:(WQBottomPopupWindowView *)bottomPopupWindowView image:(UIImage *)image {
    self.bottomPopupWindowView.hidden = YES;
    
    [headPortraitBtn setImage:image forState:UIControlStateNormal];
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

#pragma mark -- 护照的响应事件
- (void)passportBtnClick {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image == nil) {
            return ;
        }
        [passportBtn setImage:image forState:UIControlStateNormal];
    }];
}

#pragma mark -- 头像和相机的响应事件
- (void)headPortraitBtnClick {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
//    [sheet showInView:self.view];
    self.bottomPopupWindowView.hidden = NO;
}

#pragma mark -- 完成的响应事件
- (void)completeBtnClick {
    UIImage *headPortraitBtnImage = [UIImage imageNamed:@"denglushoujizhucetouxiang"];
    NSData *data1 = UIImagePNGRepresentation(headPortraitBtn.imageView.image);
    NSData *data = UIImagePNGRepresentation(headPortraitBtnImage);
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
    UIImage *passportBtnImage = [UIImage imageNamed:@"zhuceshangchuanzhengjianzhaopian"];
    NSData *passportBtndata = UIImagePNGRepresentation(passportBtn.imageView.image);
    NSData *passportdata = UIImagePNGRepresentation(passportBtnImage);
    if ([passportdata isEqual:passportBtndata]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请上传证件照" preferredStyle:UIAlertControllerStyleAlert];
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
    if (![nationalityTextField.text isVisibleString]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请输入国籍" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD showWithStatus:@"上传中…"];
//    [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        NSData * data = UIImageJPEGRepresentation(headPortraitBtn.imageView.image, 0.1);
//        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject isKindOfClass:[NSData class]]) {
//            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        }
//        NSLog(@"success : %@", responseObject);
//
//        self.pic_truenamefileID = responseObject[@"fileID"];
//        [self upDataPassport];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error : %@", error);
//        [SVProgressHUD dismissWithDelay:0.2];
//    }];
    [self upDataPassport];
}

#pragma mark -- 上传证件照
- (void)upDataPassport {
    [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImageJPEGRepresentation(passportBtn.imageView.image, 0.1);
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        NSLog(@"success : %@", responseObject);
        
        [self.passportidArray addObject:responseObject[@"fileID"]];
        [self upload];
        [SVProgressHUD dismissWithDelay:0.3];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [SVProgressHUD dismissWithDelay:0.2];
    }];
}

- (void)upload {
    NSString *urlString = @"api/user/register2/s2truenameforeign";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pic_truename"] = self.pic_truenamefileID;
    params[@"true_name"] = nameTextField.text;
    params[@"nation"] = nationalityTextField.text;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"plugin_alumnus_class_id"] = self.class_idString;
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:self.passportidArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"passport_pic"] = idcardStr;
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
            [WQDataSource sharedTool].isHiddenVisitorsToLoginPopupWindowView = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"提交成功,正在等待审核,审核成功后会通过短信提醒您。"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"知道了"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [[NSNotificationCenter defaultCenter]  postNotificationName:@"rootvcdisms" object:self];
                                                                 }];
            
            [alertController addAction:cancelButton];
            [self presentViewController:alertController animated:YES completion:nil];
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
                    [headPortraitBtn setImage:cropImage forState:UIControlStateNormal];
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
        [headPortraitBtn setImage:cropImage forState:UIControlStateNormal];
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

- (NSMutableArray *)passportidArray {
    if (!_passportidArray) {
        _passportidArray = [NSMutableArray array];
    }
    return _passportidArray;
}

@end
