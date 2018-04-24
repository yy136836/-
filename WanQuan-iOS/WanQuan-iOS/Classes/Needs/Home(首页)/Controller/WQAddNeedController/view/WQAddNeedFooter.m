//
//  WQAddNeedFooter.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddNeedFooter.h"

@interface WQAddNeedFooter ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *warnImageView;

@end

@implementation WQAddNeedFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString * text = @"注：发BBS公告将给查看者每人一个红包，金额和数量由您决定";
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text
                                                                             attributes:@{NSFontAttributeName:_infoLabel.font,
                                                                                          NSForegroundColorAttributeName:_infoLabel.textColor,
                                                                                          NSParagraphStyleAttributeName:style}];
    _infoLabel.text = nil;
    _infoLabel.attributedText = str;
    
    _warnImageView.layer.cornerRadius = _warnImageView.image.size.width / 2 ;
    _warnImageView.layer.masksToBounds = YES;
    
}

@end
