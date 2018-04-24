//
//  WQAddTopicController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddTopicController.h"
#import "WQAddTopicView.h"
#import "WQAddTopicAddImageView.h"
#import "WQTopicAddImageCell.h"
#import "WQTopicAddImageheadView.h"
#import "TZImagePickerController.h"
#import "WQReleaseFriendsCirclePromptView.h"
#import "WQLinksContentView.h"
#import "WQPhotoBrowser.h"

@interface WQAddTopicController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate, WQReleaseFriendsCirclePromptViewDelegate,WQLinksContentViewDelegate, MWPhotoBrowserDelegate>


@property (nonatomic, retain)UIScrollView * mainScroll;
@property (nonatomic, retain)WQAddTopicView * addTopicView;
@property (nonatomic, retain)NSMutableArray * picArray;
@property (nonatomic, retain)NSMutableArray * picIdArray;
@property (nonatomic, retain)NSMutableArray * selectedAssets;
@property (nonatomic, retain)WQAddTopicAddImageView * addImage;
@property (nonatomic, strong)WQLinksContentView *linksContentView;

@property (nonatomic, copy) NSString * linkTitle;
@property (nonatomic, copy) NSString * linkPic;
@property (nonatomic, copy) NSString * linkURLString;

//@property (nonatomic, retain) UILabel * imageCountLabel;
@property (nonatomic, assign) NSInteger uploadCount;

@property (nonatomic, retain) UIView * scrollBg;

@end


#define TAG_DELETE 1000

@implementation WQAddTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"发主题";
    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(backOnclick)];
//
//    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//
//    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
    

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target: self action:@selector(publishOnclick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];

//
    
    _mainScroll  = [[UIScrollView alloc] init];
    if(@available(iOS 11.0, *)) {
        _mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_mainScroll];
    [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    _scrollBg = [UIView new];
    [_mainScroll addSubview:_scrollBg];
    [_scrollBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_mainScroll);
        make.bottom.equalTo(_mainScroll.mas_bottom).offset(-50);
    }];
    
    _mainScroll.backgroundColor = [UIColor colorWithHex:0xef3f3f3];
    _mainScroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _mainScroll.showsVerticalScrollIndicator = YES;
    _mainScroll.scrollEnabled = YES;
    [self setupUI];

    _picArray = @[].mutableCopy;
    _picIdArray= @[].mutableCopy;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(backOnclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}






- (void)setupUI {
    

    _addTopicView  = [[NSBundle mainBundle] loadNibNamed:@"WQAddTopicView" owner:self options:nil].lastObject;
    [_scrollBg addSubview:_addTopicView];
    
    _addTopicView.backgroundColor = [UIColor whiteColor];
    
    
    [_addTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(_scrollBg);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@200);
    }];
    
    _addImage = [[WQAddTopicAddImageView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    _addImage.backgroundColor = UIColor.whiteColor;
    [_scrollBg addSubview:_addImage];
    [_addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(_addTopicView.mas_bottom);
        make.height.equalTo(@100);
    }];

    _addImage.delegate = self;
    _addImage.dataSource = self;
    [_addImage registerNib:[UINib nibWithNibName:@"WQTopicAddImageCell" bundle:nil] forCellWithReuseIdentifier:@"WQTopicAddImageCell"];
    [_addImage registerNib:[UINib nibWithNibName:@"WQTopicAddImageheadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WQTopicAddImageheadView"];
    _addImage.backgroundColor = [UIColor whiteColor];
    _addImage.showsHorizontalScrollIndicator = NO;

    
    
//    _imageCountLabel = [[UILabel alloc] init];
//    [self.view addSubview:_imageCountLabel];
//    
//    [_imageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(_addImage.mas_bottom);
//        make.height.equalTo(@18);
//    }];
//    _imageCountLabel.font = [UIFont systemFontOfSize:12];
//    _imageCountLabel.text = @"最多可添加10张图片";
//    _imageCountLabel.textColor = [UIColor colorWithHex:0x999999];
//    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * imageBG = [[UIView alloc] init];
    [_scrollBg addSubview:imageBG];
    imageBG.backgroundColor = [UIColor whiteColor];
    
    [imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addImage.mas_top);
        make.left.right.equalTo(_scrollBg);
        make.height.equalTo(@185);
    }];
    [_scrollBg sendSubviewToBack:imageBG];
    
    UIImageView *dottedLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuxiankuang"]];
    dottedLineImageView.userInteractionEnabled = YES;
    [_scrollBg addSubview:dottedLineImageView];
    [dottedLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(_addImage.mas_bottom).offset(10);
        make.right.equalTo(@-15);
        make.height.offset(60);
    }];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dottedLineImageViewClick)];
    [dottedLineImageView addGestureRecognizer:tap];

    // 粘贴链接
    UIButton *pasteLinkBtn = [[UIButton alloc] init];
    pasteLinkBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [pasteLinkBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [pasteLinkBtn setTitle:@"点击粘贴文章链接" forState:UIControlStateNormal];
    [pasteLinkBtn addTarget:self action:@selector(dottedLineImageViewClick) forControlEvents:UIControlEventTouchUpInside];
    [dottedLineImageView addSubview:pasteLinkBtn];
    [pasteLinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dottedLineImageView);
    }];
////
////    // 链接图片
    UIImageView *linkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fabuwanquanlianjie"]];
    linkImageView.userInteractionEnabled = YES;
    [dottedLineImageView addSubview:linkImageView];
    [linkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pasteLinkBtn.mas_left).offset(-ghSpacingOfshiwu);
        make.centerY.equalTo(pasteLinkBtn);
    }];
//
    UITapGestureRecognizer *linkImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dottedLineImageViewClick)];
    [linkImageView addGestureRecognizer:linkImageViewTap];
    
    // 提示
    
    
//    //////////////
    WQReleaseFriendsCirclePromptView *promptView = [[WQReleaseFriendsCirclePromptView alloc] init];
    promptView.backgroundColor = HEX(0xf3f3f3);
    promptView.delegate = self;
    [_scrollBg addSubview:promptView];
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_scrollBg);
        make.top.equalTo(imageBG.mas_bottom);
        make.height.equalTo(@150);
    }];
//
//    NSDictionary * storage = [NSDictionary dictionaryWithContentsOfFile:WQ_STORAGE_FILE_PATH];
//    
//    if (storage[WQ_DES_CLOSED_KEY]) {
//        promptView.hidden = YES;
//    }
//    
    
    self.linksContentView = [[WQLinksContentView alloc] init];
    _linksContentView.delegate = self;
    _linksContentView.hidden = YES;
    [_scrollBg addSubview:_linksContentView];
    [_linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollBg.mas_left).offset(ghSpacingOfshiwu);
        make.top.equalTo(_addImage.mas_bottom).offset(10);
        make.right.equalTo(_scrollBg).offset(-ghSpacingOfshiwu);
        make.height.offset(60);
    }];
    
    
    
    UIView * bg = [UIView new];
    [_scrollBg addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_scrollBg);
        make.top.equalTo(promptView.mas_bottom);
        make.height.equalTo(@(kScreenWidth / 4));
        make.bottom.equalTo(_scrollBg.mas_bottom);
    }];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"WQCirclePrompt"];
    if ([str isEqualToString:@"YES"]) {
        promptView.hidden = YES;
    }
    
//    _mainScroll.contentSize = CGSizeMake(kScreenHeight, 800);
}


#pragma mark - collectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!_picArray.count) {
        return CGSizeMake(kScreenWidth - 20, 100);
    }
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArray.count ? self.picArray.count + 1 : 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQTopicAddImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WQTopicAddImageCell" forIndexPath:indexPath];
    if (indexPath.row < _picArray.count) {
        
        [cell.showingImage setImage:_picArray[indexPath.row] ];
        cell.deleteButton.hidden = NO;
    } else {
        
        [cell.showingImage setImage:[UIImage imageNamed:@"tianjiatupian"]];
        cell.deleteButton.hidden = YES;
    }
    
    [cell.deleteButton addTarget:self action:@selector(deleteOnclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = TAG_DELETE + indexPath.row;
    
    return cell;

    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _picArray.count) {
        [self addOnclick];
    } else {
        WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
        browser .currentPhotoIndex = indexPath.row;
        browser.alwaysShowControls = NO;
        browser.displayActionButton = NO;
        browser.shouldTapBack = YES;
        browser.shouldHideNavBar = YES;
        
        //[self.navigationController pushViewController:browser animated:YES];
        [self presentViewController:browser animated:NO completion:nil];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WQTopicAddImageheadView" forIndexPath:indexPath];
        reusableView = header;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {

        reusableView = [UICollectionReusableView new];
    }
    reusableView.backgroundColor = self.view.backgroundColor;
    
    
    WQTopicAddImageheadView * view = (WQTopicAddImageheadView * )reusableView;
    
    if (view.height) {
        [view.addImageButton addTarget:self action:@selector(addOnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
    
    return reusableView;
}

#pragma mark - photoBrowser
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto * photo = [[MWPhoto alloc]initWithImage:_picArray[index]];
    return photo;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}



 #pragma mark - barbuttonItem
/**
 发布
 */
- (void)submit {
    [self.view endEditing:YES];

    if (![_addTopicView.titleField.text isVisibleString]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [WQAlert showAlertWithTitle:nil message:@"请填写标题" duration:1.3];
        return;
    }

    if (![_addTopicView.cottentTextView.text isVisibleString]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [WQAlert showAlertWithTitle:nil message:@"请填写内容" duration:1.3];
        return;
    }
    
    _uploadCount = 0;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:@"图片上传中.."];
    [self checkImagesToUpload];
}



- (void)checkImagesToUpload {
    
    if (_uploadCount < _picArray.count) {
        [self uploadImage:_picArray[_uploadCount]];
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
            [_picIdArray addObject:responseObject[@"fileID"]];
        }
        _uploadCount ++;
        [self checkImagesToUpload];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [_picIdArray removeAllObjects];
        [SVProgressHUD dismiss];
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
    
}




- (void)fetchLinkInfo:(NSString *)URLString {
    NSString * strURL = @"api/tool/parselink";
    
//    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//    if (!secreteKey.length) {
//        return;
//    }
    
    
    [SVProgressHUD showWithStatus:@"正在解析链接"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSString * legal = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * param = @{@"url":legal}.mutableCopy;
    
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"网络请求错误请重试"];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        if (![response[@"success"] boolValue]) {
            [SVProgressHUD dismiss];

//            [SVProgressHUD showErrorWithStatus:response[@"message"]];
//            [SVProgressHUD dismissWithDelay:1];
            _linkTitle = @"分享文章";
            _linkPic = nil;
        } else {
            [SVProgressHUD dismiss];
            _linkTitle = response[@"title"];
            _linkPic = response[@"img"];
        }
        _linkURLString = URLString;
        
        _linksContentView.hidden = NO;
        [_linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:_linkPic] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        _linksContentView.linksLabel.text = _linkTitle;
        
    }];

}




- (void)publish {
    
    [SVProgressHUD showWithStatus:@"正在发布...."];

    NSString * strURL = @"api/group/creategrouptopic";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;

        return;
    }
    
    
    //    secretkey true string
    //    gid true string 群ID
    //    subject true string 标题：不能为空，不超过128个字符
    //    content true string 内容：不能为空
    //    pic false string jsonarray , 32位的图片文件ID
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    param[@"gid"] = _gid;
    param[@"subject"] = _addTopicView.titleField.text;
    param[@"content"] = _addTopicView.cottentTextView.text;
    

    
    if (_linkURLString) {
        param[@"link_url"] = _linkURLString;
        if (_linkTitle) {
            param[@"link_txt"] = _linkTitle;
        }
        
        if (_linkPic) {
            param[@"link_img"] = _linkPic;
        }
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    if(_picIdArray.count){
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:_picIdArray
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
        
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        param[@"pic"] = str;
    }
    
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (error) {
            NSLog(@"%@",error);

            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.3];
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
                    if (self.releaseSuccessBlock) {
                        self.releaseSuccessBlock();
                    }
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];

}
    
    


- (void)wqDeleteBtnClickCirclePromptView:(WQReleaseFriendsCirclePromptView *)promptView {
    promptView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey: @"WQCirclePrompt"];
}


#pragma mark - action 

- (void)addOnclick {
    [self.view endEditing:YES];
    [[WQAuthorityManager manger] showAlertForAlbumAuthority];
    [[WQAuthorityManager manger] showAlertForCameraAuthority];
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
    picker.navigationBar.tintColor = [UIColor whiteColor];
    [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker.automaticallyAdjustsScrollViewInsets = NO;
    picker.selectedAssets = self.selectedAssets?:@[].mutableCopy;
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.selectedAssets = assets.mutableCopy;
        [self.picArray removeAllObjects];
        [self.picArray addObjectsFromArray:photos];
        [_addImage reloadData];
        
        //        _imageCountLabel.text = [NSString stringWithFormat:@"已添加%zd张,还可以添加%zd张",_picArray.count,10 - _picArray.count];
        if (_picArray.count) {
            //            [_addImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_picArray.count inSection:0]
            //                               indexPathForRow:_picArray.count
            //                                     inSection:0
            //                              atScrollPosition:UICollectionViewScrollPositionRight
            //                                      animated:YES]
            [_addImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_picArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)dottedLineImageViewClick {
    
    NSString * pasteUrlString = [[UIPasteboard generalPasteboard] string];
    if (pasteUrlString.length) {
        
        NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray * links = [detector matchesInString:pasteUrlString
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, pasteUrlString.length)];
        
        if (links.count != 1) {
            
            [WQAlert showAlertWithTitle:nil message:@"未在您粘贴的内容中找到有效链接" duration:1.3];
            return;
        } else {
            
            NSTextCheckingResult * result = links[0];
            
            pasteUrlString = [pasteUrlString substringWithRange:result.range];
            
            [self fetchLinkInfo:pasteUrlString];
        }
    } else {
        [WQAlert showAlertWithTitle:nil
                            message:@"您的粘贴板上没有内容" duration:1.3];
    }
}



- (void)backOnclick {
    [self.view endEditing:YES];
    
    if (![_addTopicView.titleField.text isVisibleString] && ![_addTopicView.cottentTextView.text isVisibleString]) {
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
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)publishOnclick:(UIBarButtonItem *)sender {
    if (!sender.enabled) {
        return;
    }
    [self.view endEditing:YES];

    [self submit];
}


- (void)deleteOnclick:(UIButton *)sender {
    [self.view endEditing:YES];

    NSInteger index = sender.tag - TAG_DELETE;
    [_picArray removeObjectAtIndex:index];
    [_selectedAssets removeObjectAtIndex:index];
    [_addImage reloadData];
//    _imageCountLabel.text = [NSString stringWithFormat:@"已添加%zd张,还可以添加%zd张",_selectedAssets.count,10 - _selectedAssets.count];
//    if (!_selectedAssets.count) {
//        _imageCountLabel.text = @"最多可添加10张图片";
//    }
//    
    if (_picArray.count) {

        [_addImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_picArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}


#pragma mark -- WQLinksContentViewDelegate
- (void)deleteBtnClick:(WQLinksContentView *)linksContentView {
    _linkPic = nil;
    _linkTitle = nil;
    _linkURLString = nil;
    linksContentView.hidden = YES;
}




@end
