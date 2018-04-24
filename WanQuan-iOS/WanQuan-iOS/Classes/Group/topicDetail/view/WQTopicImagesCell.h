//
//  WQTopicImagesCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQImageInfoModel.h"

typedef void(^PicOntap)();

@interface WQTopicImagesCell : UITableViewCell

@property (nonatomic, retain)WQImageInfoModel * model;
@property (nonatomic, copy) PicOntap ontap;
@end
