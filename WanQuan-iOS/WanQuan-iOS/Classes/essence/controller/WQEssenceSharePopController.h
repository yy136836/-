//
//  WQEssenceSharePopController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"


@protocol WQEssenceSharePopControllerDelegate <NSObject>
- (void)essenceSharePopShareToThird;
- (void)essenceSharePopShareToCircle;

@end

@interface WQEssenceSharePopController : WQViewController
@property (nonatomic, retain) id<WQEssenceSharePopControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray * shareToTitles;
@end
