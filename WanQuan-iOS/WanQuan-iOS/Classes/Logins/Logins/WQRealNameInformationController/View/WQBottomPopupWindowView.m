//
//  WQBottomPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQBottomPopupWindowView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController+WQCircleCrop.h"
@interface WQBottomPopupWindowView () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>


/**
 图片在相册中的 id
 */
@property (nonatomic, copy) NSString * imageId;

/**
 头像上传后的文件的 ID
 */
@property (nonatomic, copy) NSString * fileID;
@end

@implementation WQBottomPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:.3];
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnClick)]];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(455));
        make.bottom.left.right.equalTo(self);
    }];
    
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(empty)]];
    
    
    // 上传头像的label
    UILabel *uploadHeadPortrait = [UILabel labelWithText:@"上传头像" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    uploadHeadPortrait.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self addSubview:uploadHeadPortrait];
    [uploadHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(backgroundView.mas_top).offset(kScaleX(ghDistanceershi));
    }];
    
    // 右上角的x
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setImage:[UIImage imageNamed:@"denglushanchu"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(uploadHeadPortrait.mas_centerY);
        make.right.equalTo(self.mas_right).offset(kScaleX(-ghDistanceershi));
    }];
    
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(0.5);
        make.top.equalTo(backgroundView.mas_top).offset(kScaleX(55));
    }];
    
    // 选择头像时请参考一下建议的label
    UILabel *tagLabel = [UILabel labelWithText:@"选择头像时请参考以下建议" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
    [self addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(lineView.mas_bottom).offset(kScaleX(25));
    }];
    
    // 三个头像
    UIImageView *oncHeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengluqingxitouxiang"]];
    UIImageView *twoHeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengludatouxiang"]];
    UIImageView *threeHeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglufengjingtouxiang"]];
    oncHeadPortraitImageView.layer.cornerRadius = kScaleY(42);
    oncHeadPortraitImageView.layer.masksToBounds = YES;
    twoHeadPortraitImageView.layer.cornerRadius = kScaleY(42);
    twoHeadPortraitImageView.layer.masksToBounds = YES;
    threeHeadPortraitImageView.layer.cornerRadius = kScaleY(42);
    threeHeadPortraitImageView.layer.masksToBounds = YES;
    [self addSubview:oncHeadPortraitImageView];
    [self addSubview:twoHeadPortraitImageView];
    [self addSubview:threeHeadPortraitImageView];
    NSArray *picArray = @[oncHeadPortraitImageView,twoHeadPortraitImageView,threeHeadPortraitImageView];
    // 两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距
    [picArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleY(38) leadSpacing:kScaleY(22) tailSpacing:kScaleY(22)];
    [picArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(84), kScaleX(84)));
        make.top.equalTo(tagLabel.mas_bottom).offset(kScaleX(35));
    }];
    
    // 三个小图
    UIImageView *oncExpression = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengluhaotu"]];
    [self addSubview:oncExpression];
    [oncExpression mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oncHeadPortraitImageView.mas_centerX);
        make.top.equalTo(oncHeadPortraitImageView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    UIImageView *twoExpression = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglubukaixin"]];
    [self addSubview:twoExpression];
    [twoExpression mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoHeadPortraitImageView.mas_centerX);
        make.top.equalTo(twoHeadPortraitImageView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    UIImageView *threeExpression = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglubukaixin"]];
    [self addSubview:threeExpression];
    [threeExpression mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(threeHeadPortraitImageView.mas_centerX);
        make.top.equalTo(threeHeadPortraitImageView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 三个Label
    UILabel *oncLabel = [UILabel labelWithText:@"清晰、人物大小合适的正面照片" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    oncLabel.numberOfLines = 2;
    [self addSubview:oncLabel];
    UILabel *twoLabel = [UILabel labelWithText:@"避免头部、脸部不完整" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    twoLabel.numberOfLines = 2;
    [self addSubview:twoLabel];
    UILabel *threeLabel = [UILabel labelWithText:@"请勿使用风景照或人物过小" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    threeLabel.numberOfLines = 2;
    [self addSubview:threeLabel];
    
    NSArray *labelArray = @[oncLabel,twoLabel,threeLabel];
    [labelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleY(ghSpacingOfshiwu) leadSpacing:kScaleY(ghSpacingOfshiwu) tailSpacing:kScaleY(ghSpacingOfshiwu)];
    [labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeExpression.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // label下的分割线
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.equalTo(self);
        make.top.equalTo(oncLabel.mas_bottom).offset(kScaleX(29));
    }];
    
    // 拍照的按钮
    UIButton *takingPicturesBtn = [[UIButton alloc] init];
    takingPicturesBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [takingPicturesBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [takingPicturesBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takingPicturesBtn addTarget:self action:@selector(takingPicturesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [takingPicturesBtn setBackgroundImage:[UIImage imageWithColor:WQ_BG_LIGHT_GRAY] forState:UIControlStateHighlighted];
    [self addSubview:takingPicturesBtn];
    [takingPicturesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(twoView.mas_bottom).offset(kScaleX(ghStatusCellMargin));
        make.height.offset(kScaleX(ghCellHeight));
    }];
    
    // 拍照下的分割线
    //    UIView *bottomLineView = [[UIView alloc] init];
    //    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    //    [self addSubview:bottomLineView];
    //    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.offset(0.5);
    //        make.right.left.equalTo(self);
    //        make.top.equalTo(takingPicturesBtn.mas_bottom).offset(kScaleX(ghStatusCellMargin));
    //    }];
    
    
    
    // 从相册选择按钮
    UIButton *photoAlbumBtn = [[UIButton alloc] init];
    photoAlbumBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [photoAlbumBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [photoAlbumBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
    [photoAlbumBtn setBackgroundImage:[UIImage imageWithColor:WQ_BG_LIGHT_GRAY] forState:UIControlStateHighlighted];

    [photoAlbumBtn addTarget:self action:@selector(photoAlbumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoAlbumBtn];
    [photoAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(kScaleX(-ghStatusCellMargin));
        make.left.right.equalTo(self);
        make.height.offset(kScaleX(ghCellHeight));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIView *bottomlineView = [[UIView alloc] init];
    bottomlineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(photoAlbumBtn.mas_top).offset(kScaleX(-5));
        make.right.left.equalTo(self);
    }];
}

- (void)setIsIdcard_pic:(BOOL)isIdcard_pic {
    _isIdcard_pic = isIdcard_pic;
}

#pragma mark -- deleteBtn
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDeleteBtnClick:)]) {
        [self.delegate wqDeleteBtnClick:self];
    }
}

#pragma mark -- 拍照的响应事件
- (void)takingPicturesBtnClick {

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
            [self.viewController presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }];
}

#pragma mark -- 从相册选择的响应事件
- (void)photoAlbumBtnClick {
    
    

    
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (!([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![[WQAuthorityManager manger] haveAlbumAuthority]) {
                    
                    [[WQAuthorityManager manger] showAlertForAlbumAuthority];
                    return;
                }
            });

        }
        
        if (status == PHAuthorizationStatusAuthorized) {
            
            TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            picker.allowTakePicture = NO;
            picker.isStatusBarDefault = YES;
            picker.allowPickingGif = NO;
            picker.allowPickingVideo = NO;
            
            picker.navigationBar.tintColor = [UIColor whiteColor];
            [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0)
                                                                                             green:(34/255.0)
                                                                                              blue:(34/255.0)
                                                                                             alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)]
                                       forBarMetrics:UIBarMetricsDefault];
            picker.automaticallyAdjustsScrollViewInsets = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController presentViewController:picker animated:YES completion:nil];
            });
            
        }
    }];
    
    
    
    
    
    

    
    
    
    //    使用第三方的相册选择照片
    
    
    
    
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
                    if (self.delegate && [self.delegate respondsToSelector:@selector(wqFinishAction:image:)]) {
                        [self.delegate wqFinishAction:self image:cropImage];
                    }
                    
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.viewController presentViewController:picker1 animated:YES completion:nil];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(wqFinishAction:image:)]) {
            [self.delegate wqFinishAction:self image:cropImage];
        }
    }];
    picker1.isStatusBarDefault = YES;
    picker1.allowPickingGif = NO;
    picker1.allowPickingVideo = NO;
    
    picker1.navigationBar.tintColor = [UIColor whiteColor];
    [picker1.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker1.automaticallyAdjustsScrollViewInsets = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.viewController presentViewController:picker1 animated:YES completion:nil];
    });
    
}


- (void)uploadImage:(UIImage *)image {
    NSString *urlString = @"file/upload";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在上传头像"];
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
            //            [self avatarImageView];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"头像上传成功.审核通过后将会显示,请您耐心等待" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        
        [SVProgressHUD dismiss];
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
    
}

- (void)empty {
    
}



@end
