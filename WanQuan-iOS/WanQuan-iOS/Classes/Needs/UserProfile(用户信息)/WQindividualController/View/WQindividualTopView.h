//
//  WQindividualTopView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQUserProfileModel;
@interface WQindividualTopView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;
//@property (nonatomic,strong) UITableView *documentsTableView;
//@property (nonatomic,strong) UITableView *rightTablebView;
@property (nonatomic, copy) NSString *touxiangImageUrl;
@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) WQUserProfileModel *model;

@property (nonatomic,copy) void(^pickerClikeBlock)();
@end
