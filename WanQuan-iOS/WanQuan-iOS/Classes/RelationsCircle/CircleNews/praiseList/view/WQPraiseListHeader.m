//
//  WQPraiseListHeader.m
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/5.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQPraiseListHeader.h"

@interface WQPraiseListHeader ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end



@implementation WQPraiseListHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString * infoText = _infoLabel.text;
    
    NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineSpacing = style.lineSpacing + 5;
    
    NSDictionary * attr = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:14],
                            NSForegroundColorAttributeName : HEX(0x75A8EB),
                            NSParagraphStyleAttributeName : style
                            };
    
    
    NSMutableAttributedString * attrInfo = [[NSMutableAttributedString alloc] initWithString:infoText attributes:attr];
    _infoLabel.attributedText = attrInfo;
}

@end
