//
//  WQMyCriditView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ToKnowClick)();

@interface WQMyCriditView : UIView

@property (nonatomic, assign) NSInteger creditValue;
@property (nonatomic, copy) ToKnowClick toKnowMore;
@end
