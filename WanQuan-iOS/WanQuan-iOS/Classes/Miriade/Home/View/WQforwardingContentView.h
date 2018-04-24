//
//  WQforwardingContentView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/25.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLabel, WQretransmissionModel,WQforwardingContentView;

@protocol WQforwardingContentViewDelegate <NSObject>

/**
 外链的响应事件

 @param forwardingContentView self
 @param linkURLString 外链url
 */
- (void)wqLinksContentViewClick:(WQforwardingContentView *)forwardingContentView linkURLString:(NSString *)linkURLString;
@end

@interface WQforwardingContentView : UIView
@property (nonatomic ,weak) YYLabel *contentLabel;          //内容
@property (nonatomic, strong) WQretransmissionModel *model;

@property (nonatomic, weak) id <WQforwardingContentViewDelegate> delegate;

//@property (nonatomic, assign) BOOL isGroupForwarding;
@end
