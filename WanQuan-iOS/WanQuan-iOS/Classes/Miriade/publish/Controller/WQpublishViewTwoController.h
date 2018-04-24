//
//  WQpublishViewTwoController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQpublishViewTwoController : UIViewController
@property (nonatomic, strong) NSMutableArray *imageIdArray;   //上传图片成功的ID数组

@property (nonatomic, copy) void(^releaseSuccessBlock)();
@end
