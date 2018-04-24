//
//  WQUploadDocumentsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/2/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUploadDocumentsViewController.h"
#import "WQlogonnRootViewController.h"

@interface WQUploadDocumentsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIButton *frontBtn;
@property (nonatomic, strong) UIButton *reverseSideBtn;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *certificatePhotoArrayM;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, assign) NSInteger integrr;
@end

@implementation WQUploadDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self setupUI];
}

#pragma mark - 初始化UI
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *frontLabel = [[UILabel alloc]init];
    frontLabel.text = @"身份证正面照片";
    UILabel *reverseSideLabel = [[UILabel alloc]init];
    reverseSideLabel.text = @"身份证反面照片";
    
    [self.view addSubview:frontLabel];
    [self.view addSubview:reverseSideLabel];
    
    [frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ghNavigationBarHeight + 20);
        make.left.equalTo(self.view).offset(20);
    }];
    [reverseSideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frontLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    UIButton *frontBtn = [[UIButton alloc]init];
    self.frontBtn = frontBtn;
    [frontBtn setImage:[UIImage imageNamed:@"documentsAdd"] forState:0];
    [frontBtn addTarget:self action:@selector(frontBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:frontBtn];
    
    [frontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(frontLabel.mas_centerY);
        make.width.offset(35);
        make.height.offset(35);
    }];
    
    UIButton *reverseSideBtn = [[UIButton alloc]init];
    self.reverseSideBtn = reverseSideBtn;
    [reverseSideBtn setImage:[UIImage imageNamed:@"documentsAdd"] forState:0];
    [reverseSideBtn addTarget:self action:@selector(reverseSideBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reverseSideBtn];
    
    [reverseSideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(reverseSideLabel.mas_centerY);
        make.right.equalTo(self.view).offset(-30);
        make.width.offset(35);
        make.height.offset(35);
    }];
    
    UIButton *nextBtn = [[UIButton alloc]init];
    [nextBtn addTarget:self action:@selector(nextBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"上传" forState:0];
    nextBtn.backgroundColor = [UIColor colorWithHex:0Xa550d6];
    [nextBtn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reverseSideBtn.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
}

#pragma mark - 点击事件
- (void)frontBtnClike
{
    self.integrr = 1;
    NSLog(@"正面");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing=true;
    imagePicker.delegate=self;
    self.imagePicker=imagePicker;
    UIAlertController *setImageVc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *pictur=[UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *comera=[UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            [SVProgressHUD showErrorWithStatus:@"模拟器不能拍照"];
            NSLog(@"没有摄像头");
            return ;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [setImageVc addAction:pictur];
    [setImageVc addAction:comera];
    [setImageVc addAction:cancel];
    [self presentViewController:setImageVc animated:YES completion:nil];
}

- (void)reverseSideBtnCliek
{
    self.integrr = 2;
    NSLog(@"反面");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    self.imagePicker=imagePicker;
    UIAlertController *setImageVc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *pictur=[UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *comera=[UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            [SVProgressHUD showErrorWithStatus:@"模拟器不能拍照"];
            NSLog(@"没有摄像头");
            return ;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [setImageVc addAction:pictur];
    [setImageVc addAction:comera];
    [setImageVc addAction:cancel];
    [self presentViewController:setImageVc animated:YES completion:nil];
}

- (void)nextBtnClike
{
    dispatch_group_t group = dispatch_group_create();
    for (id image in self.picArray) {
        dispatch_group_enter(group);
        
        NSString *fileName;
        if (_integrr == 1) {
            fileName = @"front";
        }else {
            fileName = @"reverseSide";
        }
        
        NSData *data = UIImageJPEGRepresentation(image,0.1);
        NSString *urlString = @"file/upload";
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success : %@", responseObject);
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            [self.certificatePhotoArrayM addObject:responseObject[@"fileID"]];
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(WQUploadDocumentsVCDelegate:picId:)]) {
            [self.delegate WQUploadDocumentsVCDelegate:self picId:self.certificatePhotoArrayM];
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (_integrr == 1) {
        NSLog(@"%@",[info[@"UIImagePickerControllerReferenceURL"] class]);
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
            NSData *data = UIImageJPEGRepresentation(image, .1);
            [data writeToFile:[@"iconView" appendCachePath] atomically:YES];
            self.image = [UIImage imageWithData:data];
            [self.picArray addObject:self.image];
            [self.frontBtn setImage:self.image forState:0];
        }];
    }else if (_integrr == 2)
    {
        NSLog(@"%@",[info[@"UIImagePickerControllerReferenceURL"] class]);
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
            NSData *data = UIImageJPEGRepresentation(image, .1);
            [data writeToFile:[@"iconView" appendCachePath] atomically:YES];
            self.image = [UIImage imageWithData:data];
            [self.picArray addObject:self.image];
            [self.reverseSideBtn setImage:self.image forState:0];
        }];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)certificatePhotoArrayM
{
    if (!_certificatePhotoArrayM) {
        _certificatePhotoArrayM = [[NSMutableArray alloc]init];
    }
    return _certificatePhotoArrayM;
}
- (NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = [[NSMutableArray alloc]init];
    }
    return _picArray;
}

@end
