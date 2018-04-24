//
//  WQretweetStatus.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYLabel,WQStatusPictureView;

@interface WQretweetStatus : UIView
@property (nonatomic, strong) YYLabel *contentLabel;                  //内容
@property (nonatomic, strong) WQStatusPictureView *statusPictureView;
@property (nonatomic, strong) NSArray *picArray;
@end
