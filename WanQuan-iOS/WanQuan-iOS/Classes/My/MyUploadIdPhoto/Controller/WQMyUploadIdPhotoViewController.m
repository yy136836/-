//
//  WQMyUploadIdPhotoViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyUploadIdPhotoViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController+WQCircleCrop.h"

@interface WQMyUploadIdPhotoViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
/**
 图片在相册中的 id
 */
@property (nonatomic, copy) NSString *imageId;

/**
 头像的id
 */
@property (nonatomic, copy) NSString *pic_truenamefileID;
/**
 证件照的id 后台要数组
 */
@property (nonatomic, strong) NSMutableArray *passportidArray;
@end

@implementation WQMyUploadIdPhotoViewController {
    // 头像的按钮
    UIButton *headPortraitBtn;
    // 上传证件照的按钮
    UIButton *certificateBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.navigationItem.title = @"上传证件照片";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor =  UIColor.clearColor;
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark -- 初始化View
- (void)setupView {
    UILabel *textLabel = [UILabel labelWithText:@"上传以下证件均可" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    textLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:16];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ghNavigationBarHeight + kScaleX(ghDistanceershi));
        make.left.equalTo(self.view).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    UILabel *textTwoLabel = [UILabel labelWithText:@"身份证、驾驶证、居住证、社保卡、英语四六级证书;请上传证件带有照片和姓名的一面" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
    textTwoLabel.numberOfLines = 2;
    [self.view addSubview:textTwoLabel];
    [textTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textLabel.mas_left);
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(5));
        make.right.equalTo(self.view).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 头像的按钮
    headPortraitBtn = [[UIButton alloc] init];
    headPortraitBtn.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitBtn.layer.cornerRadius = 30;
    headPortraitBtn.layer.masksToBounds = YES;
    [headPortraitBtn addTarget:self action:@selector(headPortraitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headPortraitBtn setImage:self.user_picImage forState:UIControlStateNormal];
    [self.view addSubview:headPortraitBtn];
    [headPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textTwoLabel.mas_bottom).offset(kScaleX(30));
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
    // 上传证件照的按钮
    certificateBtn = [[UIButton alloc] init];
    certificateBtn.contentMode = UIViewContentModeScaleAspectFill;
    [certificateBtn addTarget:self action:@selector(certificateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [certificateBtn setImage:[UIImage imageNamed:@"zhuceshangchuanzhengjianzhao"] forState:UIControlStateNormal];
    [self.view addSubview:certificateBtn];
    [certificateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headPortraitLabel.mas_bottom).offset(kScaleY(ghDistanceershi));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(140)));
    }];
    
    UILabel *tagLabel = [UILabel labelWithText:@"您的信息仅用于验证和保护会员身份,绝不会被泄漏" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:13];
    [self.view addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(kScaleX(-60));
        make.centerX.equalTo(self.view);
    }];
    
    // 提交的按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    submitBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(45)));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(tagLabel.mas_top).offset(kScaleX(-12));
    }];
}

#pragma mark -- 提交的响应事件
- (void)submitBtnClick {
    UIImage *image = [UIImage imageNamed:@"zhuceshangchuanzhengjianzhao"];
    NSData *data1 = UIImagePNGRepresentation(certificateBtn.imageView.image);
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqual:data1]) {
        UIAlertController *alertVC = [UIAlertController
                                      alertControllerWithTitle:@"提示!" message:@"请上传证件照" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    // 真实头像
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"上传中…"];
    [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImageJPEGRepresentation(headPortraitBtn.imageView.image, 0.1);
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        NSLog(@"success : %@", responseObject);
        
        self.pic_truenamefileID = responseObject[@"fileID"];
        [self uploadCertificate];
        [SVProgressHUD dismissWithDelay:0.3];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [SVProgressHUD dismissWithDelay:0.2];
    }];
}

- (void)uploadCertificate {
    [[WQNetworkTools sharedTools] POST:@"file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImageJPEGRepresentation(certificateBtn.imageView.image, 0.1);
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
    NSString *urlString = @"api/user/verifytruename";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pic_truename"] = self.pic_truenamefileID;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:self.passportidArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"提交成功,正在等待审核,审核成功后会通过短信提醒您"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"知道了"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark -- 证件照的按钮响应事件
- (void)certificateBtnClick {
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image == nil) {
            return ;
        }
        [certificateBtn setImage:image forState:UIControlStateNormal];
    }];
}

#pragma mark -- 头像的响应事件
- (void)headPortraitBtnClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
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

#pragma mark -- 懒加载
- (NSMutableArray *)passportidArray {
    if (!_passportidArray) {
        _passportidArray = [NSMutableArray array];
    }
    return _passportidArray;
}

- (UIImage *)user_picImage {
    if (!_user_picImage) {
        _user_picImage = [[UIImage alloc] init];
    }
    return _user_picImage;
}

@end
