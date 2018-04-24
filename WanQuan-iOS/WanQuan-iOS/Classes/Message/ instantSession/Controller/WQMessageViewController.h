//
//  WQMessageViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQmessageHomeTopView.h"
@interface WQMessageViewController : UIViewController

@property (nonatomic,retain)WQmessageHomeTopView *topView;


- (void)clickAtMessage;
-(void)setupUnreadMessageCount;
@end
