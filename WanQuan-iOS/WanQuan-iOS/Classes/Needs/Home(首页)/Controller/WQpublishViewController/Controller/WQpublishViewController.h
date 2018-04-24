//
//  WQpublishViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQpublishViewController : UIViewController
@property(nonatomic,copy)NSString *headlineTextField;
@property(nonatomic,copy)NSString *contentTextView;

//图片ID
//@property(nonatomic,copy)NSString *imageId;

@property(nonatomic,strong)NSArray *imageId;
@end
