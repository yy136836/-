//
//  WQtopUpPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQtopUpPopupWindowView : UIView
@property (nonatomic, copy) void (^returnBtnClikeBlock)();
@property (nonatomic, copy) void (^submitBtnClikeBlock)(NSString *moneyString);
@end
