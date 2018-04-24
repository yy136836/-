//
//  WQCircleDynamicCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCircleNewsModel.h"
@interface WQCircleDynamicCell : UITableViewCell

@property (nonatomic, assign) CGFloat addHeight;
@property (nonatomic, retain) WQCircleNewsModel * model;
@end
