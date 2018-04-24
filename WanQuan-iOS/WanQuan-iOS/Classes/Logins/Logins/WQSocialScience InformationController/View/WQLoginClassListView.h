//
//  WQLoginClassListView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLoginClassListView;

@protocol WQLoginClassListViewDelegate <NSObject>

/**
 选中列表某一行的响应事件

 @param classListView self
 @param titleString title
 */
- (void)wqTableviewdidSelectRowAtClick:(WQLoginClassListView *)classListView titleString:(NSString *)titleString classIdString:(NSString *)classIdString;

@end

@interface WQLoginClassListView : UIView

@property (nonatomic, weak) id <WQLoginClassListViewDelegate> delegate;

/**
 班级列表数据
 */
@property (nonatomic, strong) NSArray *dataArray;

@end
