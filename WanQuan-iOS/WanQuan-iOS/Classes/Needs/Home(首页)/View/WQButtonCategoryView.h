//
//  WQButtonCategoryView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQButtonCategoryView;

@protocol ButtonCategoryDelegate <NSObject>
@optional
- (void)myLFmyMineBalanceCell:(WQButtonCategoryView*)ButtonCategoryView didClickAddButton:(UIButton*)addButton;
- (void)homeMapView:(WQButtonCategoryView*)ButtonCategoryView didClickAddButton:(UIButton*)addButton;
- (void)shousuoBtnClike:(WQButtonCategoryView*)ButtonCategoryView didClickAddButton:(UIButton*)addButton;
@end
@interface WQButtonCategoryView : UIView

@property (nonatomic, weak) id <ButtonCategoryDelegate> delegate;

@property (nonatomic, assign) CGFloat btnCGfloat;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *mapBtn;
@property (nonatomic, strong) UIButton *srbBtn;
@property (nonatomic, strong) UIButton *shousuoBtn;

@property (nonatomic, copy) void (^BtnClickBlock)(NSInteger index);  //点击事件的Block

@end
