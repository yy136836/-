//
//  WQdemaadnforHairViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/3.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WQReleaseType) {
    WQOrderTypeNeeds = 0,   // 首页
    WQOrderTypeGroup        // 群组
};

/**
 home发需求//已弃置
 */
@interface WQdemaadnforHairViewController : UIViewController

@property(nonatomic,copy)NSString *contentTextViewtext;
@property(nonatomic,copy)void(^fileIdBlock)(NSString *);

/**
 图片
 */
@property(nonatomic,copy)NSString *imageString;
/*
 组头
 */
@property (nonatomic, copy) NSString *titleString;

/**
 子节点
 */
@property (nonatomic, copy) NSString *childNodesString;
/**
 订阅Id
 */
@property (nonatomic, copy) NSString *needsId;

/**
 群组id
 */
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, assign) WQReleaseType releaseType;
@end
