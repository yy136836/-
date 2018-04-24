//
//  WQRetweetStatusView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/13.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLabel;
@interface WQRetweetStatusView : UIView
@property (nonatomic, strong) UILabel *contentLabel;  //内容
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) UIImageView *picImageView;

/**
 是否有内容
 */
@property (nonatomic, assign) BOOL isContent;

@property (nonatomic, copy) void(^contentLabelClikeBlock)();
@end
