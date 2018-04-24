//
//  WQpublishViewTwoController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQpublishViewTwoController.h"
#import "WQpublishTwoTextView.h"
#import "WQimageConCollectionView.h"
#import "TZImagePickerController.h"

@interface WQpublishViewTwoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate, UIScrollViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) WQimageConCollectionView *imageConview;
@property (nonatomic, strong) WQpublishTwoTextView *publishTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *imagebtn;
@property (nonatomic, strong) NSMutableDictionary *params;             //发布状态参数
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@property (nonatomic, assign) NSInteger uploadCount;
@end

@implementation WQpublishViewTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //[self setupUI];
    _uploadCount = 0;
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(0, self.publishTextView.bounds.size.height + self.imageConview.bounds.size.height);
}

- (void)setupView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WQpublishTwoTextView *publishTextView = [[WQpublishTwoTextView alloc] init];
    self.publishTextView = publishTextView;
    WQimageConCollectionView *imageConview = [[WQimageConCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    imageConview.backgroundColor = [UIColor whiteColor];
    self.imageConview = imageConview;
    __weak typeof(self) wealSelf = self;
    [imageConview setAddImageBlock:^{
        [wealSelf selectPicture];
    }];
    [imageConview setDeleteBlock:^{
        if (wealSelf.imageConview.imageArray.count == 0) {
            wealSelf.imagebtn.hidden = NO;
        }else {
            wealSelf.imagebtn.hidden = YES;
        }
    }];
    [imageConview setCellhiddenBlock:^(NSInteger idx) {
        if (idx == 0) {
            wealSelf.imagebtn.hidden = NO;
        }else {
            wealSelf.imagebtn.hidden = YES;
        }
    }];
    
    [scrollView addSubview:publishTextView];
    [scrollView addSubview:imageConview];
    [publishTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(scrollView);
        make.height.offset(120);
    }];
    [imageConview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishTextView.mas_bottom);
        make.left.equalTo(scrollView).offset(ghSpacingOfshiwu);
        make.right.bottom.equalTo(scrollView).offset(-ghSpacingOfshiwu);
        make.height.offset(500);
    }];
    
    UIButton *imagebtn = [[UIButton alloc]init];
    self.imagebtn = imagebtn;
    [imagebtn addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
    [imagebtn setImage:[UIImage imageNamed:@"add"] forState:0];
    [scrollView addSubview:imagebtn];
    [imagebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishTextView.mas_bottom);
        make.left.equalTo(scrollView).offset(16);
    }];
}

#pragma mark - 初始化UI
- (void)setupUI {
    self.navigationItem.title = @"发布主题";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    // 取消返回文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
//    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(issuenumberClick:)];
    rightBarItem.enabled = YES;
    self.rightBarItem = rightBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WQpublishTwoTextView *publishTextView = [[WQpublishTwoTextView alloc] init];
    self.publishTextView = publishTextView;
    WQimageConCollectionView *imageConview = [[WQimageConCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    imageConview.backgroundColor = [UIColor whiteColor];
    self.imageConview = imageConview;
    __weak typeof(self) wealSelf = self;
    [imageConview setAddImageBlock:^{
        [wealSelf selectPicture];
    }];
    [imageConview setDeleteBlock:^{
        if (wealSelf.imageConview.imageArray.count == 0) {
            wealSelf.imagebtn.hidden = NO;
        }else {
            wealSelf.imagebtn.hidden = YES;
        }
    }];
    [imageConview setCellhiddenBlock:^(NSInteger idx) {
        if (idx == 0) {
            wealSelf.imagebtn.hidden = NO;
        }else {
            wealSelf.imagebtn.hidden = YES;
        }
    }];
    
    [scrollView addSubview:publishTextView];
    [scrollView addSubview:imageConview];
    
    [publishTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.height.offset(500);
        make.top.equalTo(scrollView);
    }];
    [imageConview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishTextView.mas_bottom);
        make.left.equalTo(scrollView).offset(ghSpacingOfshiwu);
        make.right.bottom.equalTo(scrollView).offset(-ghSpacingOfshiwu);
        make.height.offset(0);
    }];
    
    UIButton *imagebtn = [[UIButton alloc]init];
    self.imagebtn = imagebtn;
    [imagebtn addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
    [imagebtn setImage:[UIImage imageNamed:@"add"] forState:0];
    [scrollView addSubview:imagebtn];
    [imagebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishTextView.mas_bottom);
        make.left.equalTo(scrollView).offset(ghSpacingOfshiwu);
    }];
}

#pragma mark - 发布按钮点击事件
- (void)issuenumberClick:(UIBarButtonItem *)sender {
    self.rightBarItem.enabled = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"图片上传中…"];
    
    [self checkImagesToUpload];
}




- (void)uploadImage:(UIImage *)image {
    
    NSString *urlString = @"file/upload";

    [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            NSData * data = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:data name:@"file" fileName:@"wanquantupian" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        NSLog(@"success : %@", responseObject);
        
        BOOL successbool = [responseObject[@"success"] boolValue];
        if (successbool) {
            [self.imageIdArray addObject:responseObject[@"fileID"]];
        }
        _uploadCount ++;
        [self checkImagesToUpload];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [self.imageIdArray removeAllObjects];
        [SVProgressHUD dismiss];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];

}



- (void)checkImagesToUpload {
    
    if (_uploadCount < self.imageConview.imageArray.count) {
        [self uploadImage:self.imageConview.imageArray[_uploadCount]];
    } else {
        [self publish];
    }

}


- (void)publish {
    NSString *urlString = @"api/moment/status/createstatus";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:self.imageIdArray options:NSJSONWritingPrettyPrinted error:nil];
    //[self.imageConview.imageArray removeAllObjects];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    self.params[@"pic"] = idcardStr;
    self.params[@"content"] = self.publishTextView.inputBoxTextView.text;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [SVProgressHUD showWithStatus:@"图片发布中…"];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        [SVProgressHUD dismiss];
        BOOL successbool = [response[@"success"] boolValue];
        if (successbool) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"发布成功!" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    if (self.releaseSuccessBlock) {
                        self.releaseSuccessBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

#pragma mark - ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageConview addImageWithImgae:[image scaleToWidth:600]];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)selectPicture {
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    [self presentViewController:imagePickerController animated:true completion:nil];
    
    [[WQAuthorityManager manger] showAlertForAlbumAuthority];
    [[WQAuthorityManager manger] showAlertForCameraAuthority];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.automaticallyAdjustsScrollViewInsets = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (NSInteger i = 0; i < photos.count; i++) {
            [self.imageConview addImageWithImgae:photos[i]];
//            [self.imageConview mas_updateConstraints:^(MASConstraintMaker *make) {
//                if (self.imageConview.imageArray.count <= 3) {
//                    make.height.offset(80);
//                }else if (self.imageConview.imageArray.count <= 6 && self.imageConview.imageArray.count > 3) {
//                    make.height.offset(200);
//                }else {
//                    make.height.offset(500);
//                }
//            }];
//            self.scrollView.contentSize = CGSizeMake(0, self.publishTextView.bounds.size.height + self.imageConview.bounds.size.height);
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)imageIdArray {
    if (!_imageIdArray) {
        _imageIdArray = [NSMutableArray array];
    }
    return _imageIdArray;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

@end
