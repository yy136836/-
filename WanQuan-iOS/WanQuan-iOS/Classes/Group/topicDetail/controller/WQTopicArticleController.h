//
//  WQTopicArticleController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"
#import "WQArticleModel.h"

@interface WQTopicArticleController : WQViewController

@property (nonatomic, copy) NSString * URLString;
@property (nonatomic, copy) NSString * NavTitle;
@property (nonatomic, retain) UIWebView * webView;

@end
