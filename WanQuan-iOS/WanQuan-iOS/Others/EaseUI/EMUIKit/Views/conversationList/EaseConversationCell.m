/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationCell.h"

#import "EMConversation.h"
#import "UIImageView+EMWebCache.h"
#import "WQEaseMobTools.h"

CGFloat const EaseConversationCellPadding = 10;

@interface EaseConversationCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;

@end

@implementation EaseConversationCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseConversationCell *cell = [self appearance];
    cell.titleLabelColor = HEX(0x111111);
    cell.titleLabelFont = [UIFont systemFontOfSize:16];
    cell.detailLabelColor = HEX(0x999999);
    cell.detailLabelFont = [UIFont systemFontOfSize:14];
    cell.timeLabelColor = HEX(0x999999);
    cell.timeLabelFont = [UIFont systemFontOfSize:10];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showAvatar = YES;
        [self _setupSubview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLastMessage:) name:WQConversationCellShoudUpdateDetailTextNoti object:nil];
    }
    
    return self;
}

#pragma mark - private layout subviews

- (void)_setupSubview
{
    _avatarView = [[EaseImageView alloc] init];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
//    _avatarView.layer.cornerRadius = 25;
//    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = [UIColor colorWithHex:0x999999];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = [UIColor colorWithHex:0x111111];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = _detailLabelFont;
    _detailLabel.textColor = [UIColor colorWithHex:0x666666];
    [self.contentView addSubview:_detailLabel];
    
    [self _setupAvatarViewConstraints];
//    [self _setupTimeLabelConstraints];
//    [self _setupTitleLabelConstraints];
//    [self _setupDetailLabelConstraints];
}

#pragma mark - Setup Constraints
- (void)_setupAvatarViewConstraints
{
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(50);
        make.top.left.equalTo(self).offset(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarView.mas_top).offset(3);
        make.left.equalTo(_avatarView.mas_right).offset(10);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(self).offset(-12);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_avatarView.mas_bottom).offset(-3);
        make.right.equalTo(_timeLabel.mas_right);
    }];
    /*[self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];*/
}



#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}

#pragma mark - 如果是最后一条消息有问题请不要看这里!!!!!
- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    NSLog(@"model.title%@",model.title);
    NSLog(@"model.avatarURLPath%@",model.avatarURLPath);
    NSLog(@"model.avatarImage%@",model.avatarImage);
    
    
    if ([_model.title length] > 0) {
        self.titleLabel.text = _model.title;
    } else {
        self.titleLabel.text = @"";
    }
// MARK: 测试用字典看 conversation 的附加信息
//    NSDictionary * dic = _model.conversation.ext;
    
    if (self.showAvatar) {
        if ([_model.avatarURLPath length] > 0){
//            [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholderImage:_model.avatarImage];
            [self.avatarView.imageView yy_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholder:_model.avatarImage];
        } else {
            if (_model.avatarImage) {
                self.avatarView.image = _model.avatarImage;
            }
        }
    }
    

    
    NSString *lastTitle = nil;
    if(self.detailLabel.attributedText != nil){
        
        lastTitle = self.detailLabel.attributedText.string;
    }
//    if (_model.conversation.unreadMessagesCount == 0) {
//        _avatarView.showBadge = NO;
//    }
//    else{
//        
//        _avatarView.showBadge = YES;
//        _avatarView.badge = _model.conversation.unreadMessagesCount;
//    }
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

- (void)setDetailLabelFont:(UIFont *)detailLabelFont
{
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor
{
    _detailLabelColor = detailLabelColor;
    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont
{
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor
{
    _timeLabelColor = timeLabelColor;
    _timeLabel.textColor = _timeLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifierWithModel:(id)model
{
    return @"EaseConversationCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
//    return EaseConversationCellMinHeight;
    return 80;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}




- (void)updateLastMessage:(NSNotification *)noti {
    if (noti.object == self.model) {
        
        NSString * text = noti.userInfo[@"info"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.detailLabel.attributedText = text.length ? [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:text textFont:self.detailLabel.font] : [NSAttributedString new];
        });
    }
    

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
