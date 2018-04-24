//
//  WQfeedbackView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTextField;

@interface WQfeedbackView : UIView

@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) WQTextField *titleTextField;

@end
