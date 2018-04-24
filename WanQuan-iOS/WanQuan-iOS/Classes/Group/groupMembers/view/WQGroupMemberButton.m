//
//  WQGroupMemberButton.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.

//

#import "WQGroupMemberButton.h"
#import "WQGroupMemberModel.h"
@implementation WQGroupMemberButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;        
        [self setTitleColor: [UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
//        self.imageView.layer.contentsRect = 5;
        
        UIImageView * imageView = [self valueForKey:@"imageView"];
        if (imageView) {
            
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
        }
        [self setImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        self.showsTouchWhenHighlighted = NO;
    }
    return self;
}




- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(0, contentRect.size.width, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}



- (void)setModel:(WQGroupMemberModel *)model {
    _model = model;
    
    [self setTitle:model.user_name forState:UIControlStateNormal];

    [self yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(_model.user_pic)]
                    forState:UIControlStateNormal
                     options:YYWebImageOptionProgressive];
    [self yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(_model.user_pic)]
                    forState:UIControlStateHighlighted
                     options:YYWebImageOptionProgressive];
    
}

@end
