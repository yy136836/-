//
//  WQCirleMessageCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCircleNewsModel.h"
@interface WQCirleMessageCell : UITableViewCell
@property (nonatomic, retain) WQCircleNewsModel * model;
@property (nonatomic, assign) CGFloat addHeight;
@end
