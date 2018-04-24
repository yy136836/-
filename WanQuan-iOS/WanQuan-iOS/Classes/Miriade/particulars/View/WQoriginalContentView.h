//
//  WQoriginalContentView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

@class WQsourceMomentStatusModel,WQparticularsModel,WQoriginalContentView;

@protocol WQoriginalContentViewDelegate <NSObject>
/**
 外链的响应事件
 
 @param forwardingContentView self
 @param linkURLString 外链url
 */
- (void)wqLinksContentViewClick:(WQoriginalContentView *)originalContentView linkURLString:(NSString *)linkURLString;
@end

@interface WQoriginalContentView : UIView
@property (nonatomic, weak) YYLabel *contentLabel;              //内容
@property (nonatomic, strong) WQsourceMomentStatusModel *model;
@property (nonatomic, strong) WQparticularsModel *particularsModel;

@property (nonatomic, weak) id <WQoriginalContentViewDelegate> delegate;

@property (nonatomic, assign) BOOL isDeleteOriginalContent;

@end
