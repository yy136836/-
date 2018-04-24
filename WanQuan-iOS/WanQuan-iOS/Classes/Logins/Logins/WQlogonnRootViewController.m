//
//  WQlogonnRootViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/17.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AFNetworking.h>
#import "WQlogonnRootViewController.h"
#import "NSString+WQSMScountdown.h"
#import "WQLearningexperienceViewController.h"
#import "WQUploadDocumentsViewController.h"
#import "TOCropViewController.h"

@interface WQlogonnRootViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WQUploadDocumentsVCDelegate,TOCropViewControllerDelegate>
@property (strong, nonatomic) UITextField *nametextField;        //姓名
@property (strong, nonatomic) UITextField *credentialsTextField; //证件的输入框
@property (strong, nonatomic) UITextField *telTextField;         //手机号
@property (strong, nonatomic) UITextField *verificationTextField;//验证码
@property (strong, nonatomic) UITextField *passwordTextField;    //密码
@property (strong, nonatomic) UIButton *gainBnt;                 //获取验证码
@property (strong, nonatomic) UIPickerView *citPickerView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIButton *addPhoto;

/**
 添加头像按钮下面的底图
 */
@property (nonatomic, retain) UIImageView * avatarBG;
@property (nonatomic, strong) UIButton *addPhotoTwo;


/**
 添加身份证按钮下面的底图
 */
@property (nonatomic, retain) UIImageView * criditCardPhotoBG;

@property (nonatomic, strong) UILabel *registeredCountLabel;     // 已注册人数
@property (strong, nonatomic) NSMutableArray *certificatePhotoArrayM;//记录上传证件照的数组
@property (strong, nonatomic) UIImage *myPhoto;
@property (nonatomic, strong) UIImageView *cropImageview;
@property (strong, nonatomic) UIImage *myCerPhoto;
@property (nonatomic, strong) UIImage *idPhotoImage;
@property (assign, nonatomic) NSInteger witchBtnSelected;
@property (assign, nonatomic) NSInteger uploadtouxiangCount;
@property (copy, nonatomic) NSString *personPhotofileID;
@property (copy, nonatomic) NSString *certificatePhotoFrontID;
@property (copy, nonatomic) NSString *certificatePhotoBackID;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, copy) NSString *mobilePhoneNo;
@property (nonatomic, copy) NSString *verificationCode;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) NSMutableArray *mutableArray;

@end

@implementation WQlogonnRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:0Xededed];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"注册";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(numberClick:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHex:0Xe4f1fd];
    self.uploadtouxiangCount = 1;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGRAction:)];
//    // 设置滑动方向
//    //swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.view addGestureRecognizer:pan];
//    NSLog(@"改变前%@",NSStringFromCGRect(self.view.frame));
}
//
//- (void)swipeGRAction:(UIPanGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateChanged) {
//        [self commitTranslation:[sender translationInView:self.view]];
//    }
//}
//
//- (void)commitTranslation:(CGPoint)translation {
//    //NSLog(@"%@",NSStringFromCGPoint(translation));
//    CGFloat absX = fabs(translation.x);
//    CGFloat absY = fabs(translation.y);
//    
//    // 设置滑动有效距离
//    if (MAX(absX, absY) < 10)
//        return;
//    
//    if (absX > absY ) {
//        
//        if (translation.x<0) {
//            
//            //向左滑动
//        }else{
//            
//            //向右滑动
//        }
//        
//    } else if (absY > absX) {
//        if (translation.y<0) {
//            //向上滑动
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = -absY;
//            //viewFrame.size.height = kScreenHeight + 50;
//            self.view.frame = viewFrame;
//            NSLog(@"%@",NSStringFromCGRect(self.view.frame));
//        }else{
//            
//            //向下滑动
//            CGRect viewFrame = self.view.frame;
//            CGFloat y = viewFrame.origin.y + absY;
//            viewFrame.origin.y = y;
//            //viewFrame.size.height = kScreenHeight + 50;
//            self.view.frame = viewFrame;
//            NSLog(@"改变前%@",NSStringFromCGRect(self.view.frame));
//        }
//    }
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    [self setupUI];
}

#pragma mark - 初始化UI
- (void)setupUI {
    //基本信息的label
    UILabel *basicLabel = [[UILabel alloc]init];
    [self.view addSubview:basicLabel];
    basicLabel.text = @"基本信息（仅验证以保护会员身份）";
    basicLabel.font = [UIFont systemFontOfSize:14];
    basicLabel.textColor = [UIColor colorWithHex:0X666666];
    [basicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
    }];
    
    
    _avatarBG = [[UIImageView alloc] init];
    [self.view addSubview:_avatarBG];
    _avatarBG.image = [UIImage imageNamed:@"addPhoto"];
    
    
    _criditCardPhotoBG = [[UIImageView alloc] init];
    [self.view addSubview:_criditCardPhotoBG];
    _criditCardPhotoBG.image = [UIImage imageNamed:@"addPhoto"];
    
    
    
    UIButton *addPhoto = [[UIButton alloc] init];
    if (self.photoImageView.image != nil) {
        [addPhoto setImage:self.photoImageView.image forState:UIControlStateNormal];
    }else{
        [addPhoto setImage:[UIImage imageNamed:@"zhucetoyxiang"] forState:UIControlStateNormal];
    }
    [addPhoto addTarget:self action:@selector(myselfBntClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhoto];
    
    //姓名的输入框
    UITextField *nametextField = [[UITextField alloc]init];
    nametextField.textColor = [UIColor colorWithHex:0X7b7b7b];
    nametextField.borderStyle = UITextBorderStyleRoundedRect;
    nametextField.backgroundColor = [UIColor whiteColor];
//    nametextField.layer.borderWidth = 1.0f;
//    nametextField.layer.cornerRadius = 5;
//    nametextField.layer.masksToBounds = YES;
//    nametextField.layer.borderColor= [UIColor colorWithHex:0Xdcdcdc].CGColor;
    nametextField.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:nametextField];
    nametextField.placeholder = @" 真实姓名";
    if (self.RealName != nil) {
        nametextField.text = self.RealName;
    }
    self.nametextField = nametextField;
    
    [addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(nametextField.mas_top);
        make.height.width.offset(60);
    }];
    
    [_avatarBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addPhoto);
        make.left.equalTo(addPhoto).offset(-6);
    }];
    


    [nametextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(basicLabel.mas_bottom).offset(5);
        make.left.equalTo(basicLabel.mas_left);
        make.right.equalTo(addPhoto.mas_left).offset(-5);
        make.height.offset(44);
    }];
    
    UIButton *myselfBnt = [[UIButton alloc] init];
    [myselfBnt setTitle:@"请上传真实头像(不可改)" forState:UIControlStateNormal];
    myselfBnt.titleLabel.font = [UIFont systemFontOfSize:13];
    [myselfBnt setTitleColor:[UIColor colorWithHex:0X5b2d8b] forState:UIControlStateNormal];
    [self.view addSubview:myselfBnt];
    [myselfBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nametextField.mas_right);
        make.top.equalTo(nametextField.mas_bottom).offset(5);
    }];
    
    UIButton *addPhotoTwo = [[UIButton alloc] init];
    if (self.idPhotoImage != nil) {
        [addPhotoTwo setImage:self.idPhotoImage forState:UIControlStateNormal];
    }else{
        [addPhotoTwo setImage:[UIImage imageNamed:@"zhucezhengjian"] forState:UIControlStateNormal];
    }
    [addPhotoTwo addTarget:self action:@selector(credentialsBntClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoTwo];
    
    [_criditCardPhotoBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addPhotoTwo);
        make.left.equalTo(addPhotoTwo).offset(-6);
    }];
    
    //证件的输入框
    UITextField *credentialsTextField = [[UITextField alloc] init];
    credentialsTextField.textColor = [UIColor colorWithHex:0X7b7b7b];
    credentialsTextField.backgroundColor = [UIColor whiteColor];
    credentialsTextField.borderStyle = UITextBorderStyleRoundedRect;
//    credentialsTextField.layer.borderWidth = 1.0f;
//    credentialsTextField.layer.cornerRadius = 5;
//    credentialsTextField.layer.masksToBounds = YES;
//    credentialsTextField.layer.borderColor = [UIColor colorWithHex:0Xdcdcdc].CGColor;
    credentialsTextField.font = [UIFont systemFontOfSize:13];
    credentialsTextField.placeholder = @" 身份证号";
    if (self.idNumber != nil) {
        credentialsTextField.text = self.idNumber;
    }
    [self.view addSubview:credentialsTextField];
    
    [addPhotoTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(credentialsTextField.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.width.offset(60);
    }];
    
    [credentialsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myselfBnt.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(nametextField.mas_left);
        make.right.equalTo(addPhotoTwo.mas_left).offset(-5);
        make.height.offset(44);
    }];
    
    UIButton *credentialsBnt = [[UIButton alloc] init];
    [credentialsBnt setTitle:@"上传以下任一种证件照片" forState:UIControlStateNormal];
    credentialsBnt.titleLabel.font = [UIFont systemFontOfSize:13];
    [credentialsBnt setTitleColor:[UIColor colorWithHex:0X5b2d8b] forState:UIControlStateNormal];
    [self.view addSubview:credentialsBnt];
    [credentialsBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(credentialsTextField.mas_right);
        make.top.equalTo(credentialsTextField.mas_bottom).offset(5);
    }];
    
    UILabel *promptLabel = [UILabel labelWithText:@"(身份证、驾驶证、居住证、社保卡、英语四六级证书)" andTextColor:[UIColor colorWithHex:0x5b2d8b] andFontSize:13];
    promptLabel.numberOfLines = ghStatusCellMargin;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(credentialsBnt.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(kScaleX(20));
        make.right.equalTo(addPhotoTwo.mas_right);
    }];
    
    //手机号
    
    
    UIView * bg = [[UIView alloc] init];
    
    [self.view addSubview:bg];
    
    bg.backgroundColor = [UIColor whiteColor];
    
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(12);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@(44 * 3));
    }];
    
    bg.layer.cornerRadius = 5;
    
    bg.clipsToBounds = YES;
    bg.layer.borderWidth = 0.5;
    bg.layer.borderColor = [UIColor colorWithHex:0xdcdcdc].CGColor;
    
    
    UITextField *telTextField = [[UITextField alloc]init];
    telTextField.textColor = [UIColor colorWithHex:0X7b7b7b];
//    telTextField.backgroundColor = [UIColor whiteColor];
//    telTextField.borderStyle = UITextBorderStyleRoundedRect;
//    telTextField.layer.borderWidth = 1.0f;
//    telTextField.layer.cornerRadius = 5;
//    telTextField.layer.masksToBounds = YES;
//    telTextField.layer.borderColor = [UIColor colorWithHex:0Xececec].CGColor;
    telTextField.font = [UIFont systemFontOfSize:13];
    telTextField.placeholder = @"手机号";
    if (self.mobilePhoneNo != nil) {
        telTextField.text = self.mobilePhoneNo;
    }
    [self.view addSubview:telTextField];
    [telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view.mas_left).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(44);
    }];
    
    //验证码
    UITextField *verificationTextField = [[UITextField alloc]init];
//    verificationTextField.backgroundColor = [UIColor whiteColor];
//    verificationTextField.borderStyle = UITextBorderStyleRoundedRect;
//    verificationTextField.textColor = [UIColor colorWithHex:0X7b7b7b];
//    verificationTextField.layer.borderWidth = 1.0f;
//    verificationTextField.layer.borderColor = [UIColor colorWithHex:0Xececec].CGColor;
    verificationTextField.font = [UIFont systemFontOfSize:13];
    verificationTextField.placeholder = @"验证码";
    if (self.verificationCode != nil) {
        verificationTextField.text = self.verificationCode;
    }
    [self.view addSubview:verificationTextField];
    [verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-16 - 10);
        make.height.offset(45);
    }];
    
    //密码
    UITextField *passwordTextField = [[UITextField alloc]init];
    passwordTextField.textColor = [UIColor colorWithHex:0X7b7b7b];
//    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
//    passwordTextField.backgroundColor = [UIColor whiteColor];
//    passwordTextField.layer.borderWidth= 1.0f;
//    passwordTextField.layer.borderColor= [UIColor colorWithHex:0Xececec].CGColor;
    passwordTextField.font = [UIFont systemFontOfSize:13];
    passwordTextField.placeholder = @"密码";
    if (self.passwordString != nil) {
        passwordTextField.text = self.passwordString;
    }
    [self.view addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(45);
    }];
    
    //获取验证码
    UIButton *gainBnt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 85, 33)];
    gainBnt.layer.cornerRadius = 5;
    gainBnt.layer.masksToBounds = YES;
    gainBnt.backgroundColor = [UIColor colorWithHex:0x5d2a89];
    [gainBnt setTitle:@"获取验证码" forState:UIControlStateNormal];
    gainBnt.titleLabel.font = [UIFont systemFontOfSize:13];
    [gainBnt addTarget:self action:@selector(gainBntClike) forControlEvents:UIControlEventTouchUpInside];
    //gainBnt.titleLabel.textColor = [UIColor whiteColor];
    [gainBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verificationTextField.rightView = gainBnt;
    verificationTextField.rightViewMode = UITextFieldViewModeAlways;
    
    //密码btn
    UIButton *passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [passwordBtn setImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
    [passwordBtn addTarget:self action:@selector(passwordBtnClike) forControlEvents:UIControlEventTouchUpInside];
    passwordBtn.titleLabel.textColor = [UIColor colorWithHex:0Xa550d6];
    [passwordBtn setTitleColor:[UIColor colorWithHex:0Xa550d6] forState:UIControlStateNormal];
    passwordTextField.rightView = passwordBtn;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *hasBeenRegisteredLabel = [UILabel labelWithText:@"名清华校友已实名注册" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.view addSubview:hasBeenRegisteredLabel];
    [hasBeenRegisteredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(passwordTextField.mas_bottom).offset(35);
    }];
    UILabel *registeredCountLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5d2a89] andFontSize:30];
    self.registeredCountLabel = registeredCountLabel;
    [self.view addSubview:registeredCountLabel];
    [registeredCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hasBeenRegisteredLabel.mas_centerY);
        make.right.equalTo(hasBeenRegisteredLabel.mas_left).offset(1);
    }];
    
    //实名注册
    UIButton *denglu = [UIButton new];
    denglu.backgroundColor = [UIColor colorWithHex:0X5d2a89];
    [denglu setTitle:@"实名注册" forState:UIControlStateNormal];
    denglu.layer.borderWidth = 1.0f;
    denglu.layer.cornerRadius = 5;
    denglu.layer.masksToBounds = YES;
    [self.view addSubview:denglu];
    [denglu addTarget:self action:@selector(denglubtnClike) forControlEvents:UIControlEventTouchUpInside];
    [denglu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(45);
        make.top.equalTo(hasBeenRegisteredLabel.mas_bottom).offset(17);
    }];
    
    //提示: 更完善的信息使您获得更高的信用分数
    UILabel *perfectLabel = [UILabel labelWithText:@"提示：完善信息让圈友看到你更高的信用" andTextColor:[UIColor colorWithHex:0X111111] andFontSize:12];
    [self.view addSubview:perfectLabel];
    
    [perfectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(denglu.mas_bottom).offset(17);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    nametextField.delegate = self;
    credentialsTextField.delegate = self;
    telTextField.delegate = self;
    verificationTextField.delegate = self;
    passwordTextField.delegate = self;
    
    
    
    
    NSInteger totleIineNum = 2;
    
    for (__block NSInteger i = 0; i < totleIineNum; ++ i) {
        UIView * line = [[UIView alloc] init];
        [self.view addSubview:line];
       [line mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(telTextField.mas_bottom).offset(44 * i - 0.5);
           make.left.equalTo(bg);
           make.right.equalTo(bg);
           make.height.equalTo(@(0.5));
       }];
        line.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
        [bg addSubview:line];
        [bg bringSubviewToFront:line];
    }
    
    
    
    
    self.nametextField = nametextField;
    self.credentialsTextField = credentialsTextField;
    self.telTextField = telTextField;
    self.verificationTextField = verificationTextField;
    self.passwordTextField = passwordTextField;
    self.gainBnt = gainBnt;
    self.addPhoto = addPhoto;
    self.addPhotoTwo = addPhotoTwo;
    if (self.photoId != nil) {
        self.personPhotofileID = self.photoId;
    }
    if (self.mutableArray != nil) {
        self.certificatePhotoArrayM = self.mutableArray;
    }
    
    
    
}

#pragma mark - 请求数据
- (void)loadData
{
    NSString *urlString = @"api/system/init";
    NSDictionary *params = [[NSDictionary alloc] init];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
        }
        self.registeredCountLabel.text = [NSString stringWithFormat:@"%@",response[@"user_count"]];
    }];
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //取消键盘
    [self.nametextField endEditing:YES];
    [self.credentialsTextField endEditing:YES];
    [self.telTextField endEditing:YES];
    [self.verificationTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.gainBnt endEditing:YES];
}

//dismissViewController
- (void)numberClick:(UIBarButtonItem *)sender {
    [self.gainBnt endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上传本人照片
- (void)myselfBntClike:(UIButton *)sender {
    self.idNumber = self.credentialsTextField.text;
    self.RealName = self.nametextField.text;
    self.passwordString = self.passwordTextField.text;
    self.verificationCode = self.verificationTextField.text;
    self.mobilePhoneNo = self.telTextField.text;
    self.mutableArray = self.certificatePhotoArrayM;
    self.photoId = self.personPhotofileID;
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        //TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        //cropController.delegate = self;
        /*[self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:cropController animated:YES completion:nil];
        }];*/
        
        if (image == nil) {
            return ;
        }
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        NSString *fileName = @"idPhoto";
        NSString *urlString = @"file/upload";
        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            self.personPhotofileID  = responseObject[@"fileID"];
            self.photoImageView.image = image;
            [self.addPhoto setImage:image forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task,NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
        }];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.cropImageview.image = image;
    CGRect viewFrame = [self.view convertRect:self.cropImageview.frame toView:self.navigationController.view];
    NSString *fileName = @"idPhoto";
    NSData *data = UIImageJPEGRepresentation(self.cropImageview.image, 0.7);
    NSString *urlString = @"file/upload";
    
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:self.cropImageview.image toFrame:viewFrame completion:^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            [self.certificatePhotoArrayM addObject:responseObject[@"fileID"]];
            [self.addPhoto setImage:self.cropImageview.image forState:UIControlStateNormal];
            _avatarBG.hidden = YES;
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
        }];
    }];
}

//证件的照片
- (void)credentialsBntClike:(UIButton *)sender {
    self.idNumber = self.credentialsTextField.text;
    self.RealName = self.nametextField.text;
    self.passwordString = self.passwordTextField.text;
    self.verificationCode = self.verificationTextField.text;
    self.mobilePhoneNo = self.telTextField.text;
    self.mutableArray = self.certificatePhotoArrayM;
    self.photoId = self.personPhotofileID;
    //NSString *fileName = @"idPhoto";
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:NO finishAction:^(UIImage *image) {
        UIImage *jinyongyuwanquanzhuce = [UIImage imageNamed:@"jinyongyuwanquanzhuce"];
        if (image == nil) {
            return ;
        }
        [self addImage:image withImage:jinyongyuwanquanzhuce];
    }];
}

- (void)addImage:(UIImage *)imageName1 withImage:(UIImage *)imageName2 {
    
    dispatch_group_t group = dispatch_group_create();
    // 设置一个异步线程组
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        UIImage *image1 = imageName1;
        UIImage *image2 = imageName2;
        
        UIGraphicsBeginImageContext(image1.size);
        
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        
        [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_semaphore_signal(sema);
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        NSString *fileName = @"idPhoto";
        NSString *urlString = @"file/upload";
        NSData *data = UIImageJPEGRepresentation(resultingImage, 0.7);
        [SVProgressHUD showWithStatus:@"图片上传中…"];
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            //self.personPhotofileID  = responseObject[@"fileID"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:resultingImage];
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.borderWidth = 1.0f;
            imageView.layer.cornerRadius = 0;
            self.idPhotoImage = imageView.image;
            [self.addPhotoTwo setImage:imageView.image forState:UIControlStateNormal];
            _criditCardPhotoBG.hidden = YES;
            [self.certificatePhotoArrayM addObject:responseObject[@"fileID"]];
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
        }];
    });
    //return resultingImage;
}

//获取验证码
- (void)gainBntClike {
    if (![self valiMobile:self.telTextField.text]) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入有效的手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    NSLog(@"点击了获取验验证码");
    
    NSString *urlString = @"api/user/sendregistersmscode";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.telTextField.text;
    //params[@"cellphone"] = @"15738017516";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL success = [response [@"success"] boolValue];
        if (success == YES) {
            [self.gainBnt setTitle:@"正在获取..." forState:UIControlStateNormal];
            self.gainBnt.enabled = NO;
            [self.gainBnt statWithTimeout:60 eventhandler:^(NSInteger timeout) {
                if(timeout <= 0){ //倒计时结束，关闭
                    //设置界面的按钮显示 根据自己需求设置
                    [self.gainBnt setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.gainBnt.enabled = YES;
                }else{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.gainBnt setTitle:[NSString stringWithFormat:@"%ld秒重试",(long)timeout] forState:UIControlStateNormal];
                }
            }];
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"该手机号已注册" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
    }];
}

//密码的显示
- (void)passwordBtnClike
{
    NSLog(@"点击了显示密码");
    if (self.passwordTextField.secureTextEntry == NO) {
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text=self.passwordTextField.text;
    }else {
        self.passwordTextField.secureTextEntry = NO;
    }
}

//把NSArray转为一个json字符串
- (NSString *)arrayToString:(NSArray *)array {
    
    NSString *str = @"['";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            str = [str stringByAppendingString:@"','"];
        }
        str = [str stringByAppendingString:array[i]];
    }
    str = [str stringByAppendingString:@"']"];
    
    return str;
}

//实名注册的点击事件
- (void)denglubtnClike
{
    NSLog(@"点击了实名注册");
    if ([self.nametextField.text isEqualToString:@""] || [self.nametextField.text isEqualToString:@" "] || [self.nametextField.text isEqualToString:@"  "] || [self.nametextField.text isEqualToString:@"   "] || [self.nametextField.text isEqualToString:@"    "]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"输入的姓名不合法(用户名只能包含中英文)" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if (![self validateIdentityCard:self.credentialsTextField.text]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入15-18位数字的身份证号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if (![self valiMobile:self.telTextField.text]) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入有效的手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入至少6位密码" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }

    NSString *urlString = @"api/user/register";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.telTextField.text;
    params[@"smscode"] = self.verificationTextField.text;
    params[@"password"] = [self.passwordTextField.text md5String];
    params[@"true_name"] = self.nametextField.text;
    params[@"idcard"] = self.credentialsTextField.text;
    params[@"pic_truename"] = self.personPhotofileID;
    params[@"idcard_pic"] = [self arrayToString:self.certificatePhotoArrayM];
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        [self.gainBnt setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.gainBnt.enabled = YES;
        if (error != nil) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL successbool = [response[@"success"] boolValue];
        if (successbool) {
            //注册成功
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"恭喜您，注册成功提交" message:@"请等候短信通知" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
    }];
}
#pragma mark - WQUploadDocumentsVCDelegate
- (void)WQUploadDocumentsVCDelegate:(WQUploadDocumentsViewController *)vc picId:(NSMutableArray *)picIdArray
{
    self.certificatePhotoArrayM = picIdArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 正则表达式
//判断手机号
- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

//判断身份证号15-18位数字
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

#pragma mark - 懒加载
- (NSMutableArray *)certificatePhotoArrayM {
    if (!_certificatePhotoArrayM) {
        _certificatePhotoArrayM = [NSMutableArray array];
    }
    return _certificatePhotoArrayM;
}
- (UIImageView *)cropImageview
{
    if (!_cropImageview) {
        _cropImageview = [[UIImageView alloc]init];
    }
    return _cropImageview;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
    }
    return _photoImageView;
}

@end
