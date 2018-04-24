//
//  WQGroupActivitiesDetailsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/20.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQGroupActivitiesDetailsViewController.h"
#import "WQTopicStickOrDeleteController.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
@interface WQGroupActivitiesDetailsViewController () <UIWebViewDelegate,UIPopoverPresentationControllerDelegate,WQTopicStickOrDeleteControllerDelegate>

@property (nonatomic, retain) UIWebView * webView;
//@property (nonatomic, retain) MBProgressHUD * hud;
@property (nonatomic, retain) UIBarButtonItem * pop;
@property (nonatomic, retain) UIBarButtonItem * close;
@property (nonatomic, retain) NSURLRequest * loadingRequest;

@property (nonatomic, retain) WQTopicStickOrDeleteController *popOverVC;

@end

@implementation WQGroupActivitiesDetailsViewController

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
    
    _pop = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    
    _close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"web_close"] style:UIBarButtonItemStyleDone target:self action:@selector(closeWebView)];
    self.navigationItem.leftBarButtonItems = @[_pop];
    self.navigationItem.title = @"活动详情";
    if (self.isAdmin) {
        UIBarButtonItem *sharbarbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStyleDone target:self action:@selector(shar)];
        UIButton * moreButton = [[UIButton alloc] init];
        [moreButton setTitle:@"∙∙∙" forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [moreButton sizeToFit];
        [moreButton addTarget:self action:@selector(barBtnsClick) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
        
        self.navigationItem.rightBarButtonItems = @[barBtn,sharbarbtn];
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStyleDone target:self action:@selector(shar)];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    if (self.urlString.length) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载中,请稍候..."];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT)];
    _webView.scalesPageToFit = YES;
    _webView.delegate =self;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    //    _webView.hidden = YES;
    [self.view addSubview:_webView];
    
    // 复制链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyLink) name:WQSharCopyLink object:nil];
}

#pragma mark -- 复制链接
- (void)copyLink {
    UMShareMenuSelectionView *view = [[UMShareMenuSelectionView alloc] init];
    [view hiddenShareMenuView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareUrl;
    [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

- (void)barBtnsClick {
    if (self.navigationItem.rightBarButtonItem) {
        _popOverVC = [WQTopicStickOrDeleteController new];
        _popOverVC.modalPresentationStyle = UIModalPresentationPopover;
        _popOverVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        _popOverVC.popoverPresentationController.delegate = self;
        _popOverVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        _popOverVC.delegate = self;
        //    TODO
        _popOverVC.sticked = self.isTop;
        [self presentViewController:_popOverVC animated:YES completion:nil];
    }
}

/**
 置顶或者取消置顶
 */
- (void)WQTopicStickOrDeleteControllerDelegateStickTopic {
    NSString *urlString = @"api/group/activity/settop";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gaid"] = self.gaid;
    if (self.isTop) {
        params[@"settop"] = @"false";
    }else {
        params[@"settop"] = @"true";
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showWithStatus:@"网络请求出错..."];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        NSString *str;
        if ([response[@"success"] boolValue]) {
            
            if (self.settopSuccessBlock) {
                self.settopSuccessBlock();
            }
            
            if (self.isTop) {
                str = @"已取消置顶";
                self.isTop = !self.isTop;
            }else {
                str = @"置顶成功";
                self.isTop = !self.isTop;
            }
        }else {
            if (self.isTop) {
                str = @"取消置顶失败";
            }else {
                str = @"置顶失败";
            }
        }
        [_popOverVC dismissViewControllerAnimated:YES completion:^{
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:str andAnimated:YES andTime:1];
        }];
    }];
}

/**
 删除帖子
 */
- (void)WQTopicStickOrDeleteControllerDelegateDeleteTopic {
    NSString *urlString = @"api/group/activity/delete";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gaid"] = self.gaid;
    
    NSLog(@"%@   -----  %@",urlString,params);
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showWithStatus:@"网络请求出错..."];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            if (self.deleteSuccessBlock) {
                self.deleteSuccessBlock();
            }
            [_popOverVC dismissViewControllerAnimated:YES
                                           completion:^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
        }else {
            [_popOverVC dismissViewControllerAnimated:YES
                                           completion:^{
                                               [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"删除失败" andAnimated:YES andTime:1];
                                           }];
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    _loadingRequest = request;

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    if (_webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[_pop,_close];
    } else {
        self.navigationItem.leftBarButtonItems = @[_pop];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_loadingRequest.URL.absoluteString isEqualToString:self.urlString]) {
        // 加载失败
        [SVProgressHUD dismiss];
    }
}

- (void)popVC {
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeWebView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - popoverPresentationController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}

- (void)shar {
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [WQSingleton sharedManager].platname = @"NORMAL";
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        if(platformType == UMSocialPlatformType_Sina){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType ==WQCopyLink){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (self.shareUrl.length) {
                pasteboard.string = self.shareUrl;
            }else{
                pasteboard.string = self.urlString;
            }
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];

            
        }
    }];
}

//分享不同的内容到平台platformType
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    switch (index) {
        case 0:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            break;
        case 1:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sms];
            break;
        case 2:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;
        case 3:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;
        case 4:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            break;
        case 5:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;
        default:
            break;
    }
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString *thumbURL = WEB_IMAGE_URLSTRING(self.pic);
    NSString *titleString = [@"【活动报名】" stringByAppendingString:self.title];
    NSString *descr = [[[@"时间: " stringByAppendingString:self.time] stringByAppendingString:@"\n地点: "] stringByAppendingString:self.addr];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:descr thumImage:thumbURL];
    
    //设置网页地址
    
    if (self.shareUrl.length) {
        shareObject.webpageUrl = self.shareUrl;
    }else{
        shareObject.webpageUrl = self.urlString;
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj {
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}


- (void)dealloc {
    _webView.delegate = nil;
    [_webView stopLoading];
}

@end
