//
//  WQdemaadnforHairview.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQdemaadnforHairview;
@protocol WQdemaadnforHairviewDelegate <NSObject>

@optional

@end

@interface WQdemaadnforHairview : UIView<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) id <WQdemaadnforHairviewDelegate> delegate;

@property (nonatomic, assign) BOOL contentnil;
@property (nonatomic, assign) BOOL titlenil;
@property (nonatomic, assign) BOOL fontLength;
@property (nonatomic, strong) UITextField *headlineTextField;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) NSMutableArray *imageArray;
// 选填的约定时间
@property (nonatomic, strong) UITextField *timeTextFieid;
// 选填的约定地点
@property (nonatomic, strong) UITextField *placeTextField;
// 资质要求
@property (nonatomic, strong) UITextView *qualificationTextView;
// 提供联系方式
@property (nonatomic, strong) UIButton *contactBtn;
// 帮助牵线
@property (nonatomic, strong) UIButton *facilitateBtn;
// 安排见面
@property (nonatomic, strong) UIButton *arrangeBtn;
// 问事前边的label
@property (nonatomic, strong) UILabel *label;


- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString;
@end
