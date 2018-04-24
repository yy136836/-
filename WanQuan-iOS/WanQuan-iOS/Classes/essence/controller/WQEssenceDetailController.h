//
//  WQEssenceDetailController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"
#import "WQEssenceModel.h"
#import "WQEssenceDataEntity.h"

@class WQmoment_choicest_articleModel;

@interface WQEssenceDetailController : WQViewController

@property (nonatomic, retain) id<WQEssenceDataEntity> model;

@property(nonatomic,copy)void (^FavSuccessBlock)();


/**
 是否展开评论的输入框
 */
@property (nonatomic, assign) BOOL isComment;

//@property (nonatomic, strong) WQmoment_choicest_articleModel *model;

/**
 网页作为 tableView 的 header
 */
@property (nonatomic, retain) UIWebView * webView;


@end
