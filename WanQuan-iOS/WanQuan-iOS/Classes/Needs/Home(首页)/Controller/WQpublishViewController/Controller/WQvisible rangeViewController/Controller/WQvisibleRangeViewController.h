//
//  WQvisibleRangeViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQvisibleRangeViewController : UIViewController
@property(nonatomic,copy)void(^finishBtnClikeBlock)(NSArray *);
@property(nonatomic,copy)void(^didSelectBlock)(NSInteger);
@property(nonatomic,copy)void(^finishBtnBlock)(NSInteger);
@end
