//
//  WQHomeNewVisitorsLoginView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQHomeNewVisitorsLoginView : UIView

@property (nonatomic, copy) void(^loginBtnClickBlock)();
@property (nonatomic, copy) NSString * btnTitle;
@property (nonatomic, copy) NSAttributedString * noLocateText;
@end
