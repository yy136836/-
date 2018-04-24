//
//  bohe
//
//  Created by 郭杭 on 15/12/16.
//  Copyright © 2015年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIImage *obtainImage(NSString *imageName) {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CLImagePickerResource" ofType:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *imagePath = [[imageBundle resourcePath] stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@interface CLImageScrollDisplayCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *displayImage;
@property (strong, nonatomic) NSString *imageUrl;

@property (assign, nonatomic) CGRect convertFrame;
@property (copy, nonatomic) void(^closeBtnClick)();

@end
