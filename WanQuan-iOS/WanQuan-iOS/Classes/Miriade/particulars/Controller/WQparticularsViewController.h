//
//  WQparticularsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/21.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQparticularsViewController : UIViewController

/**
 信用分
 */
@property (nonatomic, copy) NSString *creditPoints;
- (instancetype)initWithmId:(NSString *)mid;

//@property (nonatomic, copy) void(^deleteSuccessfulBlock)();
@end
