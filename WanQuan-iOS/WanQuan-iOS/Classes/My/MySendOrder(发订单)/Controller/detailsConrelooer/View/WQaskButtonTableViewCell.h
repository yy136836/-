//
//  WQaskButtonTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQaskButtonTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) void(^askBtnCliekBlock)();

@end
