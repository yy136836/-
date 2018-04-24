//
//  WQMyHometwoTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQMyHomeModel;
@interface WQMyHometwoTableViewCell : UITableViewCell
@property (nonatomic, strong) WQMyHomeModel *myModel;
@property (weak, nonatomic) IBOutlet UIView *redDotView;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@end
