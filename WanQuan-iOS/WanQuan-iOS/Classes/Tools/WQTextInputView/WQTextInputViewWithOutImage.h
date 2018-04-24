//
//  WQTextInputViewWithOutImage.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTextInputViewWithOutImage;
@protocol WQTextInputViewWithOutImageDelegate <NSObject>

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton;

@end

@interface WQTextInputViewWithOutImage : UIView


@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *inputtextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;

@property (nonatomic, assign) id<WQTextInputViewWithOutImageDelegate> delegate;
@end
