//
//  WQReleaseFriendsCircleViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQReleaseFriendsCircleViewController.h"
#import "TZImagePickerController.h"
#import "WQimageConCollectionView.h"
#import "WQReleaseFriendsCirclePromptView.h"
#import "WQLinksContentView.h"
#import "WQVisibleRangeView.h"

@interface WQReleaseFriendsCircleViewController () <UIScrollViewDelegate,TZImagePickerControllerDelegate,WQReleaseFriendsCirclePromptViewDelegate,WQLinksContentViewDelegate,WQVisibleRangeViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
// 输入框
@property (nonatomic, strong) UITextView *inputBoxTextView;
// 加号按钮
@property (nonatomic, strong) UIButton *addBtn;
// 虚线框
@property (nonatomic, strong) UIImageView *dottedLineImageView;
// 发布按钮
@property (nonatomic, strong) UIBarButtonItem *releaseBtn;
// 当前上传图片数量
@property (nonatomic, assign) NSInteger uploadCount;
//上传图片成功的ID数组
@property (nonatomic, strong) NSMutableArray *imageIdArray;
//发布参数
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) WQimageConCollectionView *collectionView;
//@property (nonatomic, strong) WQReleaseFriendsCirclePromptView *promptView;
@property (nonatomic, strong) WQLinksContentView *linksContentView;

/**
 可见范围的列表
 */
@property (nonatomic, strong) WQVisibleRangeView *visibleRangeView;

/**
 可见选项的图片
 */
@property (nonatomic, strong) UIImageView *visibleRangeImageView;

@end

@implementation WQReleaseFriendsCircleViewController {
    NSUserDefaults *userDefaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _uploadCount = 0;
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"发动态";
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    //[self.navigationController.navigationBar setTitleTextAttributes:
     //@{NSFontAttributeName:[UIFont systemFontOfSize:20],
       //NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *releaseBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseBtnClick)];
    self.releaseBtn = releaseBtn;
    [releaseBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = releaseBtn;
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark -- 初始化View
- (void)setupView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    self.scrollView = scrollView;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [scrollView addGestureRecognizer:swipeGestureUp];
    
    // 输入框
    UIView * inputBG = [[UIView alloc] init];
    inputBG.userInteractionEnabled = YES;
    [scrollView addSubview:inputBG];
    
    [inputBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(scrollView);
        make.width.equalTo(@(kScreenWidth));
        make.height.greaterThanOrEqualTo(@(kScreenHeight));
        make.bottom.equalTo(scrollView);
    }];
 
    UITextView *inputBoxTextView = [[UITextView alloc] init];
    inputBoxTextView.placeholder = @" 我想说…";
    self.inputBoxTextView = inputBoxTextView;
    inputBoxTextView.backgroundColor = [UIColor whiteColor];
    inputBoxTextView.font = [UIFont systemFontOfSize:15];
    [inputBG addSubview:inputBoxTextView];
    [inputBoxTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBG).offset(15);
        make.height.offset(120);
        make.left.offset(15);
        make.right.equalTo(inputBG).offset(-15);
    }];
    
    // 加号
    UIButton *addBtn = [[UIButton alloc] init];
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"fabuwanquanxuantupian"] forState:0];
    [inputBG addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBoxTextView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(inputBG).offset(ghSpacingOfshiwu);
    }];
    
    // 九宫格的图片展示
    WQimageConCollectionView *collectionView = [[WQimageConCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [inputBG addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBoxTextView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(inputBG).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(inputBG).offset(kScaleY(-ghSpacingOfshiwu));
        make.height.offset(500);
    }];
    
    __weak typeof(self) wealSelf = self;
    // 加号按钮
    [collectionView setAddImageBlock:^{
        [wealSelf addBtnClick];
    }];
    // 删除按钮
    [collectionView setDeleteBlock:^{
        CGFloat itemHW = (kScreenWidth - 2 * ghitemMargin) / 3;
        if (self.collectionView.imageArray.count <= 2) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW);
            }];
        }else if (self.collectionView.imageArray.count <= 5 && self.collectionView.imageArray.count > 3) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW * 2 + ghStatusCellMargin);
            }];
        }else {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW * 3 + ghStatusCellMargin * 2);
            }];
        }
        
        if (self.collectionView.imageArray.count >= 1) {
            [self.dottedLineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }
    }];
    
    // 虚线框
    UIImageView *dottedLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuxiankuang"]];
    self.dottedLineImageView = dottedLineImageView;
    dottedLineImageView.userInteractionEnabled = YES;
    [inputBG addSubview:dottedLineImageView];
    [dottedLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBG.mas_left).offset(ghSpacingOfshiwu);
        make.top.equalTo(addBtn.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(inputBG).offset(-ghSpacingOfshiwu);
        make.height.offset(60);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dottedLineImageViewClick)];
    [dottedLineImageView addGestureRecognizer:tap];
    
    // 粘贴链接
    UIButton *pasteLinkBtn = [[UIButton alloc] init];
    pasteLinkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [pasteLinkBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [pasteLinkBtn setTitle:@"点击粘贴文章链接" forState:UIControlStateNormal];
    [pasteLinkBtn addTarget:self action:@selector(dottedLineImageViewClick) forControlEvents:UIControlEventTouchUpInside];
    [dottedLineImageView addSubview:pasteLinkBtn];
    [pasteLinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dottedLineImageView.mas_top).offset(6);
        make.left.equalTo(dottedLineImageView.mas_left).offset(ghSpacingOfshiwu);
    }];
    
    // 链接提示文字
    UILabel *textLabel = [UILabel labelWithText:@"可从其它app的文章页点击\"分享\"——\"复制链接\"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
    textLabel.numberOfLines = 1;
    textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *linkImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dottedLineImageViewClick)];
    [textLabel addGestureRecognizer:linkImageViewTap];
    [dottedLineImageView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pasteLinkBtn.mas_left);
        make.bottom.equalTo(dottedLineImageView.mas_bottom).offset(-6);
    }];
    
    // 底部背景颜色
    UIView *backgroundColorview = [[UIView alloc] init];
    backgroundColorview.userInteractionEnabled = YES;
    backgroundColorview.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [inputBG addSubview:backgroundColorview];
    [backgroundColorview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dottedLineImageView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.right.equalTo(inputBG);
        make.bottom.equalTo(inputBG).offset(200);
    }];

    WQLinksContentView *linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.isWanquanHome = NO;
    linksContentView.delegate = self;
    self.linksContentView = linksContentView;
    linksContentView.hidden = YES;
    [inputBG addSubview:linksContentView];
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBG.mas_left).offset(ghSpacingOfshiwu);
        make.top.equalTo(addBtn.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(inputBG).offset(-ghSpacingOfshiwu);
        make.height.offset(60);
    }];
    
    // 可见选项
    UIImageView *visibleRangeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gongkaidongtai"]];
    self.visibleRangeImageView = visibleRangeImageView;
    visibleRangeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *visibleRangeImageViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visibleRangeBtnClick:)];
    [visibleRangeImageView addGestureRecognizer:visibleRangeImageViewtap];
    [inputBG addSubview:visibleRangeImageView];
    [visibleRangeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linksContentView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(ghSpacingOfshiwu);
//        make.bottom.equalTo(inputBG);
    }];
    
    // 可见范围的列表
    WQVisibleRangeView *visibleRangeView = [[WQVisibleRangeView alloc] init];
    visibleRangeView.delegate = self;
    self.visibleRangeView = visibleRangeView;
    visibleRangeView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:visibleRangeView];
    [visibleRangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
}

#pragma mark -- 可见选项
- (void)visibleRangeBtnClick:(UITapGestureRecognizer *)sender {
    
    UIGestureRecognizerState state = sender.state;
    
    if (state == UIGestureRecognizerStateEnded) {
        self.visibleRangeView.alpha = 1;
        self.visibleRangeView.hidden = NO;
    }
}

#pragma mark -- WQVisibleRangeViewDelegate
- (void)wqTableViewdidSelectRow:(WQVisibleRangeView *)visibleRangeView index:(NSInteger)index {
    self.visibleRangeView.alpha = 0;
    self.visibleRangeView.hidden = !self.visibleRangeView.hidden;
    if (index == 0) {
        self.visibleRangeImageView.image = [UIImage imageNamed:@"gongkaidongtai"];
        self.params[@"push_range"] = @"PUSH_RANGE_DEGREE2_FOLLOWER";
    }else if (index == 1) {
        self.visibleRangeImageView.image = [UIImage imageNamed:@"erduhaoyoukejian"];
        self.params[@"push_range"] = @"PUSH_RANGE_DEGREE2";
    }else {
        self.visibleRangeImageView.image = [UIImage imageNamed:@"haoyoukejian"];
        self.params[@"push_range"] = @"PUSH_RANGE_DEGREE1";
    }
}

#pragma mark -- WQLinksContentViewDelegate 
- (void)deleteBtnClick:(WQLinksContentView *)linksContentView {
    linksContentView.hidden = YES;
    self.params[@"link_img"] = @"";
    self.params[@"link_txt"] = @"";
    self.params[@"link_url"] = @"";
}

#pragma mark -- WQReleaseFriendsCirclePromptViewDelegate
- (void)wqDeleteBtnClickCirclePromptView:(WQReleaseFriendsCirclePromptView *)promptView {
    [userDefaults setObject:@"YES" forKey:@"WQCirclePrompt"];
    promptView.hidden = YES;
}

#pragma mark -- scrollView轻扫手势触发方法
- (void)swipeGesture:(id)sender {
    [self.inputBoxTextView resignFirstResponder];
}

#pragma mark -- 粘贴框响应事件
- (void)dottedLineImageViewClick {
    NSString *url = [[UIPasteboard generalPasteboard] string];
    
    
    if (!url.length) {
        [WQAlert showAlertWithTitle:nil message:@"未在您粘贴的内容中找到有效链接" duration:1.3];
        return;
    }
    
    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray<NSTextCheckingResult *> * results = [detector matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    NSTextCheckingResult * result;
    if (results.count) {
        result = results[0];
        NSRange urlRange = result.range;
        url = [url substringWithRange:urlRange];
    }

    

    
    // 粘贴的不是网页链接
    if (![self urlValidation:url]) {
        [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"您粘贴的不是网页链接" andAnimated:YES andTime:1.5];
        return;
    }
    
    // 剪贴板中没有内容
    if ([url isEqualToString:@"\t"]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"您的剪贴板中没有内容" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"url"] = url;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"链接识别中…"];
    NSString *urlstring = @"api/tool/parselink";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlstring parameters:params completion:^(id response, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismissWithDelay:0.3];
        }

        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            self.linksContentView.hidden = NO;
            [self.linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:response[@"img"]] options:0];
            [self.linksContentView.linksLabel setText:response[@"title"]];
            /*
            link_img false string 外链的Logo
            link_txt false string 外链的标题
            link_url false string 外链的URL
             */

            
            self.params[@"link_img"] = [NSString stringWithFormat:@"%@",response[@"img"]];
            self.params[@"link_txt"] = self.linksContentView.linksLabel.text;
            self.params[@"link_url"] = url;
        }else {
//            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请粘贴后重试" preferredStyle:UIAlertControllerStyleAlert];
//
//            [self presentViewController:alertVC animated:YES completion:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                });
//            self.params[@"link_img"] = [NSString stringWithFormat:@"%@",response[@"img"]];
            self.params[@"link_txt"] = @"分享文章";
//            self.params[@"link_url"] = url;

        }
        
        [SVProgressHUD dismissWithDelay:0.3];
        
    }];
    
}

- (BOOL)urlValidation:(NSString *)string {
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    //NSString * regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *reges = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *arrayOfAllMatches = [reges matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:match.range];
        NSLog(@"匹配");
        return YES;
    }
    return NO;
}

#pragma mark -- 加号的响应事件
- (void)addBtnClick {
    [[WQAuthorityManager manger] showAlertForAlbumAuthority];
    [[WQAuthorityManager manger] showAlertForCameraAuthority];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.automaticallyAdjustsScrollViewInsets = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (NSInteger i = 0; i < photos.count; i++) {
            [self.collectionView addImageWithImgae:photos[i]];
        }
        CGFloat itemHW = (kScreenWidth - 2 * ghitemMargin) / 3;
        if (self.collectionView.imageArray.count <= 2) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW);
            }];
        }else if (self.collectionView.imageArray.count == 3 || self.collectionView.imageArray.count <= 5 & self.collectionView.imageArray.count > 3) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW * 2 + ghStatusCellMargin);
            }];
        }else {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(itemHW * 3 + ghStatusCellMargin * 2);
            }];
        }
        
        if (self.collectionView.imageArray.count >= 1) {
            [self.dottedLineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -- 发布按钮响应事件
- (void)releaseBtnClick {
    self.releaseBtn.enabled = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"图片上传中…"];
    
    //[self checkImagesToUpload];
    
    if (_uploadCount < self.collectionView.imageArray.count) {
        [self uploadImage:self.collectionView.imageArray[_uploadCount]];
    } else {
        [self publish];
    }
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
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
    
}

- (void)checkImagesToUpload {
    if (_uploadCount < self.collectionView.imageArray.count) {
        [self uploadImage:self.collectionView.imageArray[_uploadCount]];
    } else {
        [self publish];
    }
    
}

- (void)publish {
    NSString *urlString = @"api/moment/status/createstatus";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:self.imageIdArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    self.params[@"pic"] = idcardStr;
    self.params[@"content"] = self.inputBoxTextView.text;
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
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"发布成功!" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    if (self.releaseSuccessBlock) {
                        self.releaseSuccessBlock();
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQPostInviduaTrendsSuccessNoti object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
            }];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
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
        _params[@"push_range"] = @"PUSH_RANGE_DEGREE2_FOLLOWER";
    }
    return _params;
}


- (void)back {
    if (![self.inputBoxTextView.text isVisibleString] && self.collectionView.imageArray.count < 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否放弃已编辑的内容？"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"退出"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      //[self dismissViewControllerAnimated:YES completion:nil];
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
