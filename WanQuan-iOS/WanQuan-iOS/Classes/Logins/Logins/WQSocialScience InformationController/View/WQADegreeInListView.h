//
//  WQADegreeInListView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQADegreeInListView;

@protocol WQADegreeInListViewDelegate <NSObject>
/**
 选中列表某一行的响应事件
 
 @param classListView self
 @param titleString title
 */
- (void)wqADegreeInListViewdidSelectRowAtClick:(WQADegreeInListView *)aDegreeInListView titleString:(NSString *)titleString;

@end

@interface WQADegreeInListView : UIView

@property (nonatomic, weak) id <WQADegreeInListViewDelegate> delegate;

/**
 列表数据
 */
@property (nonatomic, strong) NSArray *ADegreeInDataArray;

@end
