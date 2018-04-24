//
//  WQSchoolOfSocialSciencesView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSchoolOfSocialSciencesView;

@protocol WQSchoolOfSocialSciencesViewDelegate <NSObject>

/**
 班级响应事件

 @param schoolOfSocialSciencesView self
 */
- (void)wqSchoolOfSocialSciencesSerialNumberBtnClick:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView;

/**
 学位的响应事件

 @param schoolOfSocialSciencesView self
 */
- (void)wqSchoolOfSocialSciencesSelectedADegreeInBtnClick:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView;

/**
 开始时间和结束时间都确定的回调
 
 @param mbaView self
 */
- (void)wqSchoolOfSocialDetermineTime:(WQSchoolOfSocialSciencesView *)schoolOfSocialSciencesView;
@end

@interface WQSchoolOfSocialSciencesView : UIView

@property (nonatomic, weak) id <WQSchoolOfSocialSciencesViewDelegate> delegate;

/**
 班级号
 */
@property (nonatomic, strong) UIButton *serialNumberBtn;

/**
 学位
 */
@property (nonatomic, strong) UIButton *selectedADegreeInBtn;

/**
 开始时间
 */
@property (nonatomic, strong) UIButton *startTimeBtn;

/**
 到期时间
 */
@property (nonatomic, strong) UIButton *daoqiTimeBtn;

/**
 班级号后的三角
 */
@property (nonatomic, strong) UIButton *serialNumbersanjiaoBtn;

/**
 最底部的分割线
 */
@property (nonatomic, strong) UIView *bottomLineView;

/**
 班级的文字
 */
@property (nonatomic, strong) UILabel *banjiLabel;

@end
