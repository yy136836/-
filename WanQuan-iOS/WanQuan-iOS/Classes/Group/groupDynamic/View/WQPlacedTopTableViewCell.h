//
//  WQPlacedTopTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQPlacedTopTableViewCell : UITableViewCell

/**
 置顶内容
 */
@property (nonatomic, copy) NSString *subjectString;

@property (nonatomic, strong) UIButton *tagBtn;

@end
