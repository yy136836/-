//
//  WQUploadIdentificationController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUploadIdentificationController.h"
#import "WQUploadIdentificationView.h"
#import "BDImagePicker.h"
@interface WQUploadIdentificationController ()
@property (nonatomic, retain) WQUploadIdentificationView * mainView;

/**
 图片的 id
 */
@property (nonatomic, retain) NSArray * idAtrray;

/**
 身份证号
 */
@property (nonatomic, copy) NSString * creditId;
@end

@implementation WQUploadIdentificationController
#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"身份证明";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveOnClick)];
    
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
    [self setupUI];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}




#pragma mark - UI

- (void)setupUI {
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WQUploadIdentificationView" owner:nil options:nil];
    
    WQUploadIdentificationView *v = [views lastObject];
    
    [self.view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    [v.addPhotoButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    _mainView = v;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v.identityNumberField becomeFirstResponder];
    });
}



#pragma mark - action

- (void)addImage {
    [self.view endEditing:YES];
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:NO finishAction:^(UIImage *image) {
        if (!image) {
            return;
        }
        
        NSString *urlString = @"file/upload";
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        
        UIImage *jinyongyuwanquanzhuce = [UIImage imageNamed:@"jinyongyuwanquanzhuce"];
        UIImage *image1 = image;
        UIImage *image2 = jinyongyuwanquanzhuce;
        UIGraphicsBeginImageContext(image1.size);
        
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        
        [image2 drawInRect:CGRectMake(0, 0, image1.size.width , image1.size.height)];
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString * fileName = [NSUUID UUID].UUIDString;
            if (image == nil) {
                return ;
            }
            

            
            
            NSData *data = UIImageJPEGRepresentation(resultingImage,0.7);
            
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            [SVProgressHUD showWithStatus:responseObject[@"message"]];
            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"success : %@", responseObject);

            [_mainView.addPhotoButton setImage:resultingImage forState:UIControlStateNormal];
            
            _idAtrray = @[responseObject[@"fileID"]];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showWithStatus:@"上传失败请重试"];
            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"error : %@", error);
        }];
    }];
}

- (void)saveOnClick {
    [self.view endEditing:YES];
    
    if (![self validateIdentityCard:_mainView.identityNumberField.text]) {
        [WQAlert showAlertWithTitle:nil message:@"请检查身份证号" duration:1.5];
        return;
    }
    if (!_idAtrray) {
        [WQAlert showAlertWithTitle:nil message:@"请上传证件照" duration:1.5];
        return;
    }
    _creditId = _mainView.identityNumberField.text;
    
    if (self.savInfo) {
        self.savInfo(_idAtrray, _creditId);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
