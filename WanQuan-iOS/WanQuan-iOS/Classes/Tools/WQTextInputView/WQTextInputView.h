//
//  WQTextInputView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTextInputView;
@protocol WQTextInputViewDelegate <NSObject>
- (void)WQTextInputView:(WQTextInputView *)textInputView sendButtonClicked:(UIButton *)sendButton;
- (void)WQTextInputView:(WQTextInputView *)textInputView deleteImageButtonOnclick:(UIButton *)deleteImageButton;
- (void)WQTextInputView:(WQTextInputView *)textInputView addImageViewOnTap:(UIImageView *)addImageView;
@end

@interface WQTextInputView : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;
@property (weak, nonatomic) IBOutlet UITextView *inputtextView;
@property (weak, nonatomic) IBOutlet UIImageView *addPicImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;


@property (nonatomic, assign) id <WQTextInputViewDelegate> delegate;

@end
