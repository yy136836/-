//
//  WQlikeListView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

@class WQzanLike_listModel;

@interface WQlikeListView : UIView
@property (nonatomic, strong) UILabel *user_nameLabel;
@property (nonatomic, strong) NSArray *likeArray;
@property (nonatomic, strong) WQzanLike_listModel *listModel;
@property (nonatomic, strong) UIView *bottomLineView;
@end
