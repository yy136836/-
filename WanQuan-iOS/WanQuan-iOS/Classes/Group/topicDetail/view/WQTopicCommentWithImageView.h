//
//  WQTopicCommentWithImageView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddImage)(UIButton * sender);

@interface WQTopicCommentWithImageView : UIView
@property (weak, nonatomic) IBOutlet UITextField *commentField;

@property (nonatomic, copy) AddImage addImage;

@property (nonatomic, copy) AddImage removeImage;

@property (weak, nonatomic) IBOutlet UIButton *addPicButton;
@property (weak, nonatomic) IBOutlet UIButton *removePicButton;

@end
