//
//  WQLoginAreaCodeView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLoginAreaCodeView;

@protocol WQLoginAreaCodeViewDelegate <NSObject>

/**
 tableview某行的响应事件

 @param loginAreaCodeView self
 @param areaCodeString 区号
 */
- (void)wqDidSelectRowAtIndexPath:(WQLoginAreaCodeView *)loginAreaCodeView areaCode:(NSString *)areaCodeString;
@end

@interface WQLoginAreaCodeView : UIView

@property (nonatomic, weak) id <WQLoginAreaCodeViewDelegate> delagate;

@end
