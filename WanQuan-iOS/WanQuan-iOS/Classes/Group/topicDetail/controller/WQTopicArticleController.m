//
//  WQTopicArticleController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicArticleController.h"
#import "MBProgressHUD.h"
@interface WQTopicArticleController ()<UIWebViewDelegate>
@property (nonatomic, retain) MBProgressHUD * hud;
@property (nonatomic, retain) UIBarButtonItem * pop;
@property (nonatomic, retain) UIBarButtonItem * close;
@property (nonatomic, retain) NSURLRequest * loadingRequest;
@end

@implementation WQTopicArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT)];
    _webView.scalesPageToFit = YES;
    _webView.delegate =self;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
//    _webView.hidden = YES;
    [self.view addSubview:_webView];
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
    
    _pop = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    
    _close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"web_close"] style:UIBarButtonItemStyleDone target:self action:@selector(closeWebView)];

    self.navigationItem.leftBarButtonItems = @[_pop];
    self.navigationItem.title = self.NavTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"huanyihuan"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshRequest)];
    

   
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.removeFromSuperViewOnHide = NO;
    [self.view addSubview:_hud];
    [self.view bringSubviewToFront:_hud];

//    [self.navigationController.view addSubview:_hud];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.URLString.length) {
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
//                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.douban.com/note/636772079/?dt_ref=02B380E3F459AA448E530105625086E9AD369D659148A6493608ED479712DE414DF04AB726CF3548&dt_dapp=1"]]];
        
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    

    
    _loadingRequest = request;
//    if ([_loadingRequest.URL.absoluteString isEqualToString:@"about:blank"]) {
//        return NO;
//    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_hud showAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

    _hud.label.text = @"加载成功";
    [_hud hideAnimated:YES afterDelay:1.2];
    
    if (_webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[_pop,_close];
    } else {
        self.navigationItem.leftBarButtonItems = @[_pop];
    }
    
    NSString * text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = text;
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if ([_loadingRequest.URL.absoluteString isEqualToString:self.URLString]) {
        _hud.label.text = @"网页无法显示";
        [_hud hideAnimated:YES afterDelay:1.2];
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

- (void)refreshRequest {
    if (!_webView.isLoading) {
        [_webView loadRequest:_loadingRequest];
    }
}
- (void)dealloc {
    _webView.delegate = nil;
    [_hud hideAnimated:YES];
    [_webView stopLoading];
}
@end
