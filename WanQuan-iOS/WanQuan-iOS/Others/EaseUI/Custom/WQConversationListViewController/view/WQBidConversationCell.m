//
//  WQBidConversationCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQBidConversationCell.h"

@interface WQBidConversationCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *unreadMessageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMesageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageDateLabel;

@end

@implementation WQBidConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    _avatar.layer.cornerRadius = 25;
    _avatar.layer.masksToBounds = YES;
    
    _unreadMessageNumberLabel.layer.cornerRadius = 10.5;
    _unreadMessageNumberLabel.layer.masksToBounds = YES;
    
    _bidTypeLabel.layer.cornerRadius = 2;
    _bidTypeLabel.layer.masksToBounds = YES;
    
    _bidTypeLabel.layer.borderColor = HEX(0xeeeeee).CGColor;
    _bidTypeLabel.layer.borderWidth = 0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(id<IConversationModel>)model {
    _model = model;
    
    
}


@end
