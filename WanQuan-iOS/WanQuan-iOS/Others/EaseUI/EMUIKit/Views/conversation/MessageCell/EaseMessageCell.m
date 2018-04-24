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

#import "EaseMessageCell.h"

#import "EaseBubbleView+Text.h"
#import "EaseBubbleView+Image.h"
#import "EaseBubbleView+Location.h"
#import "EaseBubbleView+Voice.h"
#import "EaseBubbleView+Video.h"
#import "EaseBubbleView+File.h"
#import "EaseBubbleView+WQGroupRecommend.h"
#import "WQTopicArticleController.h"

#import "UIImageView+EMWebCache.h"

#import "EaseEmotionEscape.h"
#import "EaseLocalDefine.h"

CGFloat const EaseMessageCellPadding = 6;

NSString *const EaseMessageCellIdentifierRecvText = @"EaseMessageCellRecvText";
NSString *const EaseMessageCellIdentifierRecvLocation = @"EaseMessageCellRecvLocation";
NSString *const EaseMessageCellIdentifierRecvVoice = @"EaseMessageCellRecvVoice";
NSString *const EaseMessageCellIdentifierRecvVideo = @"EaseMessageCellRecvVideo";
NSString *const EaseMessageCellIdentifierRecvImage = @"EaseMessageCellRecvImage";
NSString *const EaseMessageCellIdentifierRecvFile = @"EaseMessageCellRecvFile";

NSString *const EaseMessageCellIdentifierSendText = @"EaseMessageCellSendText";
NSString *const EaseMessageCellIdentifierSendLocation = @"EaseMessageCellSendLocation";
NSString *const EaseMessageCellIdentifierSendVoice = @"EaseMessageCellSendVoice";
NSString *const EaseMessageCellIdentifierSendVideo = @"EaseMessageCellSendVideo";
NSString *const EaseMessageCellIdentifierSendImage = @"EaseMessageCellSendImage";
NSString *const EaseMessageCellIdentifierSendFile = @"EaseMessageCellSendFile";

@interface EaseMessageCell()
{
    EMMessageBodyType _messageType;
}

@property (nonatomic) NSLayoutConstraint *statusWidthConstraint;
@property (nonatomic) NSLayoutConstraint *activtiyWidthConstraint;
@property (nonatomic) NSLayoutConstraint *hasReadWidthConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleMaxWidthConstraint;

@end

@implementation EaseMessageCell

@synthesize statusButton = _statusButton;
@synthesize bubbleView = _bubbleView;
@synthesize hasRead = _hasRead;
@synthesize activity = _activity;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseMessageCell *cell = [self appearance];
    cell.statusSize = 20;
    cell.activitySize = 20;
    cell.leftBubbleMargin = UIEdgeInsetsMake(8, 15, 8, 10);
    cell.rightBubbleMargin = UIEdgeInsetsMake(8, 10, 8, 15);
    
    
    cell.messageTextFont = [UIFont systemFontOfSize:16];
    
    cell.messageLocationFont = [UIFont systemFontOfSize:10];
    cell.messageLocationColor = [UIColor whiteColor];
    
    //    cell.messageVoiceDurationColor = [UIColor grayColor];
    cell.messageVoiceDurationFont = [UIFont systemFontOfSize:12];
    
    cell.messageFileNameColor = [UIColor blackColor];
    cell.messageFileNameFont = [UIFont systemFontOfSize:13];
    cell.messageFileSizeColor = [UIColor grayColor];
    cell.messageFileSizeFont = [UIFont systemFontOfSize:11];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model {
    
    NSLog(@"%@",model.message.ext);
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageType = model.bodyType;
        [self _setupSubviewsWithType:_messageType
                            isSender:model.isSender
                               model:model];
        self.bubbleMargin = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - setup subviews

- (void)_setupSubviewsWithType:(EMMessageBodyType)messageType
                      isSender:(BOOL)isSender
                         model:(id<IMessageModel>)model
{
    _statusButton = [[UIButton alloc] init];
    _statusButton.translatesAutoresizingMaskIntoConstraints = NO;
    _statusButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_statusButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/messageSendFail"] forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.hidden = YES;
    [self.contentView addSubview:_statusButton];
    
    _bubbleView = [[EaseBubbleView alloc] initWithMargin:isSender?_rightBubbleMargin:_leftBubbleMargin isSender:isSender];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    _bubbleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bubbleView];
    
    
    
    _avatarView = [[UIImageView alloc] init];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    _avatarView.backgroundColor = [UIColor clearColor];
    _avatarView.clipsToBounds = YES;
    _avatarView.userInteractionEnabled = YES;
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_avatarView];
    
    _hasRead = [[UILabel alloc] init];
    _hasRead.translatesAutoresizingMaskIntoConstraints = NO;
    _hasRead.text = NSEaseLocalizedString(@"hasRead", @"Read");
    _hasRead.textAlignment = NSTextAlignmentCenter;
    _hasRead.font = [UIFont systemFontOfSize:12];
    _hasRead.hidden = YES;
    [_hasRead sizeToFit];
    [self.contentView addSubview:_hasRead];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.translatesAutoresizingMaskIntoConstraints = NO;
    _activity.backgroundColor = [UIColor clearColor];
    _activity.hidden = YES;
    [self.contentView addSubview:_activity];
    
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:model]) {
        [self setCustomBubbleView:model];
    } else {
        switch (messageType) {
            case EMMessageBodyTypeText: {
                
                EMMessage * message = model.message;
                NSMutableDictionary * coiffedExt = message.ext.mutableCopy;
                if (![message.ext[@"nid"] length]) {
                    
                    coiffedExt[@"from_name"] = message.ext[@"from_name"];
                    coiffedExt[@"from_pic"] = message.ext[@"from_pic"];
                    coiffedExt[@"to_name"] = message.ext[@"to_name"];
                    coiffedExt[@"to_pic"] = message.ext[@"to_pic"];
                    coiffedExt[@"istruename"] = @(YES);
                    coiffedExt[@"is_bidding"] = @(YES);
                    coiffedExt[@"isBidTureName"] = @(YES);
                    
                    
                    if ([message.ext[@"group"] length]) {
                        coiffedExt[@"group"] = message.ext[@"group"];
                        
                    }
                    message.ext = coiffedExt;
                } else {
                    coiffedExt = message.ext.mutableCopy;
                    if (message.ext[@"group"]) {
                        [coiffedExt removeObjectForKey:@"group"];
                    }
                    message.ext = coiffedExt;
                    
                    NSLog(@"%@",coiffedExt);
                    
                }
                
                if (!model.message.ext[@"group"]) {
                    [_bubbleView setupTextBubbleView];
                    
                    _bubbleView.textLabel.font = _messageTextFont;
                    _bubbleView.textLabel.textColor = _messageTextColor;
                    
                    
                    
                    
                } else {
                    
                    [_bubbleView setupGroupRecommendBubbleView];
                    [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@0);
                        make.right.equalTo(@0);
                        make.height.equalTo(@115);
                        make.width.equalTo(@180);
                    }];
                    //                    _bubbleView.backgroundColor = [UIColor cyanColor];
                    
                    if (model.isSender) {
                        
                        self.messageTextColor = [UIColor whiteColor];
                    } else {
                        
                        self.messageTextColor = HEX(0x333333);
                    }
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                [_bubbleView setupImageBubbleView];
                
                
                _bubbleView.imageView.image = [UIImage imageNamed:@"EaseUIResource.bundle/imageDownloadFail"];
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                [_bubbleView setupLocationBubbleView];
                
                _bubbleView.locationImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_location_preview"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
                _bubbleView.locationLabel.font = _messageLocationFont;
                _bubbleView.locationLabel.textColor = _messageLocationColor;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                [_bubbleView setupVoiceBubbleView];
                
                if (model.isSender) {
                    _bubbleView.voiceDurationLabel.textColor = [UIColor whiteColor];
                    
                } else {
                    _bubbleView.voiceDurationLabel.textColor = [UIColor grayColor];
                    
                }
                
                
                _bubbleView.voiceDurationLabel.font = _messageVoiceDurationFont;
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                [_bubbleView setupVideoBubbleView];
                
                _bubbleView.videoTagView.image = [UIImage imageNamed:@"EaseUIResource.bundle/messageVideo"];
            }
                break;
            case EMMessageBodyTypeFile:
            {
                [_bubbleView setupFileBubbleView];
                
                
                
                
                _bubbleView.fileNameLabel.font = _messageFileNameFont;
                _bubbleView.fileNameLabel.textColor = _messageFileNameColor;
                _bubbleView.fileSizeLabel.font = _messageFileSizeFont;
            }
                break;
            default:
                break;
        }
    }
    
    [self _setupConstraints];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
    [_bubbleView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapAction:)];
    [_avatarView addGestureRecognizer:tapRecognizer2];
}

#pragma mark - Setup Constraints

- (void)_setupConstraints
{
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth - 140];
    [self addConstraint:self.bubbleMaxWidthConstraint];
    self.bubbleMaxWidthConstraint.active = YES;
    
    //status button
    self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.statusSize];
    [self addConstraint:self.statusWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    //activtiy
    self.activtiyWidthConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.activitySize];
    [self addConstraint:self.activtiyWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.activity attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self _updateHasReadWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.activity attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

#pragma mark - Update Constraint

- (void)_updateHasReadWidthConstraint
{
    if (_hasRead) {
        [self removeConstraint:self.hasReadWidthConstraint];
        
        self.hasReadWidthConstraint = [NSLayoutConstraint constraintWithItem:_hasRead attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
        [self addConstraint:self.hasReadWidthConstraint];
    }
}

- (void)_updateStatusButtonWidthConstraint
{
    if (_statusButton) {
        [self removeConstraint:self.statusWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.statusSize];
        [self addConstraint:self.statusWidthConstraint];
    }
}

- (void)_updateActivityWidthConstraint
{
    if (_activity) {
        [self removeConstraint:self.activtiyWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.activitySize];
        [self addConstraint:self.activtiyWidthConstraint];
    }
}

- (void)_updateBubbleMaxWidthConstraint
{
    [self removeConstraint:self.bubbleMaxWidthConstraint];
    //    self.bubbleMaxWidthConstraint.active = NO;
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bubbleMaxWidth];
    [self addConstraint:self.bubbleMaxWidthConstraint];
    //    self.bubbleMaxWidthConstraint.active = YES;
}

#pragma mark - setter

- (void)setModel:(id<IMessageModel>)model
{
    _model = model;
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:model]) {
        [self setCustomModel:model];
    } else {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
            {
                
                
                
                EMMessage * message = model.message;
                NSMutableDictionary * coiffedExt = message.ext.mutableCopy;
                if (![message.ext[@"nid"] length]) {
                    
                    coiffedExt[@"from_name"] = message.ext[@"from_name"];
                    coiffedExt[@"from_pic"] = message.ext[@"from_pic"];
                    coiffedExt[@"to_name"] = message.ext[@"to_name"];
                    coiffedExt[@"to_pic"] = message.ext[@"to_pic"];
                    coiffedExt[@"istruename"] = @(YES);
                    coiffedExt[@"is_bidding"] = @(YES);
                    coiffedExt[@"isBidTureName"] = @(YES);
                    
                    if ([message.ext[@"group"] length]) {
                        coiffedExt[@"group"] = message.ext[@"group"];
                        
                    }
                    message.ext = coiffedExt;
                } else {
                    coiffedExt = message.ext.mutableCopy;
                    if (message.ext[@"group"]) {
                        [coiffedExt removeObjectForKey:@"group"];
                    }
                    message.ext = coiffedExt;
                    
                    NSLog(@"%@",coiffedExt);
                    
                }
                
                
                if (model.message.ext[@"group"]) {
                    
                    NSLog(@"%@",model.message.ext[@"group"]);
                    //        TODO韩扬 分享群定制
                    NSString * jsonStr = model.message.ext[@"group"];
                    
                    if (![jsonStr isKindOfClass:[NSString class]]) {
                        return;
                    }
                    if (jsonStr.length) {
                        NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        if (!dic) {
                            return;
                        }
                        
                        //                        @property (strong, nonatomic) YYLabel * groupNamelabel;
                        //                        @property (strong, nonatomic) UIImageView * groupImageView;
                        //                        @property (strong, nonatomic) YYLabel * groupInfoLabel;
                        //                        @property (strong, nonatomic) YYLabel * groupMemberNumberLabel;
                        _bubbleView.groupNamelabel.attributedText = [[NSAttributedString alloc] initWithString:dic[@"name"]
                                                                                                    attributes:
                                                                     @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                       NSForegroundColorAttributeName:[UIColor colorWithHex:0x111111]}];
                        [_bubbleView.groupImageView sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(dic[@"pic"])] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
                        
                        _bubbleView.groupInfoLabel.attributedText =[[NSAttributedString alloc] initWithString:dic[@"description"]
                                                                                                   attributes:
                                                                    @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                      NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]}];
                        
                        NSString * numberDes = [NSString stringWithFormat:@"圈成员人数:%@人",dic[@"member_count"]];
                        
                        _bubbleView.groupMemberNumberLabel.attributedText =
                        [[NSAttributedString alloc] initWithString:numberDes
                                                        attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                                                      NSForegroundColorAttributeName:HEX(0x666666)}];
                        
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bubbleView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:kScreenWidth  -140]];
                    }
                    
                    NSLog(@"%@",model.message.ext);
                    return;
                }
                
                
                if (model.isSender) {
                    
                    _bubbleView.textLabel.textColor = [UIColor whiteColor];
                } else {
                    
                    _bubbleView.textLabel.textColor = HEX(0x333333);
                }
            
                // 识别链接
                _bubbleView.textLabel.type = @"环信";
                [_bubbleView.textLabel setTextWithLinkAttribute:model.text];
//                _bubbleView.textLabel.userInteractionEnabled = YES;
//                _bubbleView.userInteractionEnabled = YES;
                // 链接的响应事件
                [_bubbleView.textLabel yb_addAttributeTapActionWithStrings:_bubbleView.textLabel.linkArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
                    WQTopicArticleController * vc = [[WQTopicArticleController alloc] init];
                    vc.URLString = string;
                    vc.NavTitle = @"";
                    [self.viewController.navigationController pushViewController:vc animated:YES];
                }];
                
                // _bubbleView.textLabel.attributedText = [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:self.messageTextFont];
            }
                break;
            case EMMessageBodyTypeImage:
            {
                UIImage *image = _model.thumbnailImage;
                if (!image) {
                    image = _model.image;
                    if (!image) {
                        [_bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.fileURLPath] placeholderImage:[UIImage imageNamed:_model.failImageName]];
                    } else {
                        _bubbleView.imageView.image = image;
                    }
                } else {
                    _bubbleView.imageView.image = image;
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                _bubbleView.locationLabel.text = _model.address;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                if (_bubbleView.voiceImageView) {
                    
                    if (self.model.isSender) {
                        self.bubbleView.voiceImageView.animationImages = @[[UIImage imageNamed:@"yuyin4"],[UIImage imageNamed:@"yuyin5"]];
                    } else {
                        
                        self.bubbleView.voiceImageView.animationImages = @[[UIImage imageNamed:@"yuyin1"],[UIImage imageNamed:@"yuyin2"]];
                    }
                    
                }
                if (!self.model.isSender) {
                    if (self.model.isMediaPlayed){
                        _bubbleView.isReadView.hidden = YES;
                    } else {
                        _bubbleView.isReadView.hidden = NO;
                    }
                }
                
                if (_model.isMediaPlaying) {
                    [_bubbleView.voiceImageView startAnimating];
                }
                else{
                    [_bubbleView.voiceImageView stopAnimating];
                    
                    if (self.model.isSender) {
                        self.bubbleView.voiceImageView.image = [UIImage imageNamed:@"yuyin6"];
                    } else {
                        
                        self.bubbleView.voiceImageView.image = [UIImage imageNamed:@"yuyin3"];
                    }
                }
                
                _bubbleView.voiceDurationLabel.text = [NSString stringWithFormat:@"%d''",(int)_model.mediaDuration];
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                UIImage *image = _model.isSender ? _model.image : _model.thumbnailImage;
                if (!image) {
                    image = _model.image;
                    if (!image) {
                        [_bubbleView.videoImageView sd_setImageWithURL:[NSURL URLWithString:_model.fileURLPath] placeholderImage:[UIImage imageNamed:_model.failImageName]];
                    } else {
                        _bubbleView.videoImageView.image = image;
                    }
                } else {
                    _bubbleView.videoImageView.image = image;
                }
            }
                break;
            case EMMessageBodyTypeFile:
            {
                _bubbleView.fileIconView.image = [UIImage imageNamed:_model.fileIconName];
                _bubbleView.fileNameLabel.text = _model.fileName;
                _bubbleView.fileSizeLabel.text = _model.fileSizeDes;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setStatusSize:(CGFloat)statusSize
{
    _statusSize = statusSize;
    [self _updateStatusButtonWidthConstraint];
}

- (void)setActivitySize:(CGFloat)activitySize
{
    _activitySize = activitySize;
    [self _updateActivityWidthConstraint];
}

- (void)setSendBubbleBackgroundImage:(UIImage *)sendBubbleBackgroundImage
{
    _sendBubbleBackgroundImage = sendBubbleBackgroundImage;
}

- (void)setRecvBubbleBackgroundImage:(UIImage *)recvBubbleBackgroundImage
{
    _recvBubbleBackgroundImage = recvBubbleBackgroundImage;
}

- (void)setBubbleMaxWidth:(CGFloat)bubbleMaxWidth
{
    _bubbleMaxWidth = bubbleMaxWidth;
    [self _updateBubbleMaxWidthConstraint];
}

- (void)setRightBubbleMargin:(UIEdgeInsets)rightBubbleMargin
{
    _rightBubbleMargin = rightBubbleMargin;
}

- (void)setLeftBubbleMargin:(UIEdgeInsets)leftBubbleMargin
{
    _leftBubbleMargin = leftBubbleMargin;
}

- (void)setBubbleMargin:(UIEdgeInsets)bubbleMargin
{
    _bubbleMargin = bubbleMargin;
    _bubbleMargin = self.model.isSender ? _rightBubbleMargin:_leftBubbleMargin;
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:_model]) {
        [self updateCustomBubbleViewMargin:_bubbleMargin model:_model];
    } else {
        if (_bubbleView) {
            switch (_messageType) {
                case EMMessageBodyTypeText:
                {
                    EMMessage * message = self.model.message;
                    NSMutableDictionary * coiffedExt = message.ext.mutableCopy;
                    if (![message.ext[@"nid"] length]) {
                        
                        coiffedExt[@"from_name"] = message.ext[@"from_name"];
                        coiffedExt[@"from_pic"] = message.ext[@"from_pic"];
                        coiffedExt[@"to_name"] = message.ext[@"to_name"];
                        coiffedExt[@"to_pic"] = message.ext[@"to_pic"];
                        coiffedExt[@"istruename"] = @(YES);
                        coiffedExt[@"is_bidding"] = @(YES);
                        coiffedExt[@"isBidTureName"] = @(YES);
                        
                        
                        if ([message.ext[@"group"] length]) {
                            coiffedExt[@"group"] = message.ext[@"group"];
                            
                        }
                        message.ext = coiffedExt;
                    } else {
                        coiffedExt = message.ext.mutableCopy;
                        if (message.ext[@"group"]) {
                            [coiffedExt removeObjectForKey:@"group"];
                        }
                        message.ext = coiffedExt;
                        
                        NSLog(@"%@",coiffedExt);
                        
                    }
                    
                    if (_model.message.ext[@"group"]) {
                        [_bubbleView updateGroupRecommendBubbleViewMargin:_bubbleMargin];
                        
                    } else {
                        NSLog(@"---------------------------%@",_model.message.ext);
                        
                        NSDictionary * dic = _model.message.ext;
                        
                        [_bubbleView updateTextMargin:_bubbleMargin];
                    }
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    [_bubbleView updateImageMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    [_bubbleView updateLocationMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    [_bubbleView updateVoiceMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    [_bubbleView updateVideoMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeFile:
                {
                    [_bubbleView updateFileMargin:_bubbleMargin];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
}

- (void)setMessageTextFont:(UIFont *)messageTextFont
{
    _messageTextFont = messageTextFont;
    if (_bubbleView.textLabel) {
        _bubbleView.textLabel.font = messageTextFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    _messageTextColor = messageTextColor;
    if (_bubbleView.textLabel) {
        _bubbleView.textLabel.textColor = _messageTextColor;
    }
}

- (void)setMessageLocationColor:(UIColor *)messageLocationColor
{
    _messageLocationColor = messageLocationColor;
    if (_bubbleView.locationLabel) {
        _bubbleView.locationLabel.textColor = _messageLocationColor;
    }
}

- (void)setMessageLocationFont:(UIFont *)messageLocationFont
{
    _messageLocationFont = messageLocationFont;
    if (_bubbleView.locationLabel) {
        _bubbleView.locationLabel.font = _messageLocationFont;
    }
}

- (void)setSendMessageVoiceAnimationImages:(NSArray *)sendMessageVoiceAnimationImages
{
    _sendMessageVoiceAnimationImages = sendMessageVoiceAnimationImages;
}

- (void)setRecvMessageVoiceAnimationImages:(NSArray *)recvMessageVoiceAnimationImages
{
    _recvMessageVoiceAnimationImages = recvMessageVoiceAnimationImages;
}

- (void)setMessageVoiceDurationColor:(UIColor *)messageVoiceDurationColor
{
    _messageVoiceDurationColor = messageVoiceDurationColor;
    if (_bubbleView.voiceDurationLabel) {
        _bubbleView.voiceDurationLabel.textColor = _messageVoiceDurationColor;
    }
}

- (void)setMessageVoiceDurationFont:(UIFont *)messageVoiceDurationFont
{
    _messageVoiceDurationFont = messageVoiceDurationFont;
    if (_bubbleView.voiceDurationLabel) {
        _bubbleView.voiceDurationLabel.font = _messageVoiceDurationFont;
    }
}

- (void)setMessageFileNameFont:(UIFont *)messageFileNameFont
{
    _messageFileNameFont = messageFileNameFont;
    if (_bubbleView.fileNameLabel) {
        _bubbleView.fileNameLabel.font = _messageFileNameFont;
    }
}

- (void)setMessageFileNameColor:(UIColor *)messageFileNameColor
{
    _messageFileNameColor = messageFileNameColor;
    if (_bubbleView.fileNameLabel) {
        _bubbleView.fileNameLabel.textColor = _messageFileNameColor;
    }
}

- (void)setMessageFileSizeFont:(UIFont *)messageFileSizeFont
{
    _messageFileSizeFont = messageFileSizeFont;
    if (_bubbleView.fileSizeLabel) {
        _bubbleView.fileSizeLabel.font = _messageFileSizeFont;
    }
}

- (void)setMessageFileSizeColor:(UIColor *)messageFileSizeColor
{
    _messageFileSizeColor = messageFileSizeColor;
    if (_bubbleView.fileSizeLabel) {
        _bubbleView.fileSizeLabel.textColor = _messageFileSizeColor;
    }
}

#pragma mark - action

- (void)bubbleViewTapAction:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!_delegate) {
            return;
        }
        if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:_model]) {
            if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                [_delegate messageCellSelected:_model];
                return;
            }
        }
        switch (_model.bodyType) {
            case EMMessageBodyTypeImage:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                //                _model.isMediaPlaying = !_model.isMediaPlaying;
                //                if (_model.isMediaPlaying) {
                //                    [_bubbleView.voiceImageView startAnimating];
                //                }
                //                else{
                //                    [_bubbleView.voiceImageView stopAnimating];
                //                }
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeFile:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
                
            case EMMessageBodyTypeText: {
                
                if (self.bubbleView.textLabel.linkArray.count) {
                    WQTopicArticleController * vc = [[WQTopicArticleController alloc] init];
                    vc.URLString = self.bubbleView.textLabel.linkArray[0];
                    vc.NavTitle = @"";
                    [self.viewController.navigationController pushViewController:vc animated:YES];
                }
                
                EMMessage * message = self.model.message;
                NSMutableDictionary * coiffedExt = message.ext.mutableCopy;
                if (![message.ext[@"nid"] length]) {
                    
                    coiffedExt[@"from_name"] = message.ext[@"from_name"];
                    coiffedExt[@"from_pic"] = message.ext[@"from_pic"];
                    coiffedExt[@"to_name"] = message.ext[@"to_name"];
                    coiffedExt[@"to_pic"] = message.ext[@"to_pic"];
                    coiffedExt[@"istruename"] = @(YES);
                    coiffedExt[@"is_bidding"] = @(YES);
                    coiffedExt[@"isBidTureName"] = @(YES);
                    
                    if ([message.ext[@"group"] length]) {
                        coiffedExt[@"group"] = message.ext[@"group"];
                        
                    }
                    message.ext = coiffedExt;
                } else {
                    coiffedExt = message.ext.mutableCopy;
                    if (message.ext[@"group"]) {
                        [coiffedExt removeObjectForKey:@"group"];
                    }
                    message.ext = coiffedExt;
                    
                    NSLog(@"%@",coiffedExt);
                    
                }
                
                if (_model.message.ext[@"group"]) {
                    if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                        [_delegate messageCellSelected:_model];
                    }
                }
                
                
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)avatarViewTapAction:(UITapGestureRecognizer *)tapRecognizer
{
    if ([_delegate respondsToSelector:@selector(avatarViewSelcted:)]) {
        [_delegate avatarViewSelcted:_model];
    }
}

- (void)statusAction
{
    if ([_delegate respondsToSelector:@selector(statusButtonSelcted:withMessageCell:)]) {
        [_delegate statusButtonSelcted:_model withMessageCell:self];
    }
}

#pragma mark - IModelCell
/*
 - (BOOL)isCustomBubbleView:(id<IMessageModel>)model
 {
 return NO;
 }
 
 - (void)setCustomModel:(id<IMessageModel>)model
 {
 
 }
 
 - (void)setCustomBubbleView:(id<IMessageModel>)model
 {
 
 }
 
 - (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
 {
 
 }*/

#pragma mark - public

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    NSString *cellIdentifier = nil;
    if (model.isSender) {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
                cellIdentifier = EaseMessageCellIdentifierSendText;
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = EaseMessageCellIdentifierSendImage;
                break;
            case EMMessageBodyTypeVideo:
                cellIdentifier = EaseMessageCellIdentifierSendVideo;
                break;
            case EMMessageBodyTypeLocation:
                cellIdentifier = EaseMessageCellIdentifierSendLocation;
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = EaseMessageCellIdentifierSendVoice;
                break;
            case EMMessageBodyTypeFile:
                cellIdentifier = EaseMessageCellIdentifierSendFile;
                break;
            default:
                break;
        }
    }
    else{
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
                cellIdentifier = EaseMessageCellIdentifierRecvText;
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = EaseMessageCellIdentifierRecvImage;
                break;
            case EMMessageBodyTypeVideo:
                cellIdentifier = EaseMessageCellIdentifierRecvVideo;
                break;
            case EMMessageBodyTypeLocation:
                cellIdentifier = EaseMessageCellIdentifierRecvLocation;
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = EaseMessageCellIdentifierRecvVoice;
                break;
            case EMMessageBodyTypeFile:
                cellIdentifier = EaseMessageCellIdentifierRecvFile;
                break;
            default:
                break;
        }
    }
    
    return cellIdentifier;
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    if (model.cellHeight > 0) {
        return model.cellHeight;
    }
    
    EaseMessageCell *cell = [self appearance];
    CGFloat bubbleMaxWidth = cell.bubbleMaxWidth;
    
    bubbleMaxWidth -= (cell.leftBubbleMargin.left + cell.leftBubbleMargin.right + cell.rightBubbleMargin.left + cell.rightBubbleMargin.right)/2;
    
    CGFloat height = EaseMessageCellPadding + cell.bubbleMargin.top + cell.bubbleMargin.bottom;
    
    switch (model.bodyType) {
        case EMMessageBodyTypeText:
        {
            NSAttributedString *text = [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:cell.messageTextFont];
            
            
            
            //CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 30 + 16 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            

            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            [style setLineSpacing:5];
            NSDictionary *attribute = @{NSFontAttributeName:cell.messageTextFont,NSParagraphStyleAttributeName:style};
            CGRect rect = [text.string boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 30 + 16 , CGFLOAT_MAX)
                                                options:\
                              NSStringDrawingTruncatesLastVisibleLine |
                              NSStringDrawingUsesLineFragmentOrigin |
                              NSStringDrawingUsesFontLeading
                                             attributes:attribute
                                                context:nil];
            height += (rect.size.height > 20 ? rect.size.height : 20) + 42;
            
            


            //            NSString *text = model.text;
            //            UIFont *textFont = cell.messageTextFont;
            //            CGSize retSize;
            //            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            //                retSize = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size;
            //            }else{
            //                retSize = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            //            }
            //
            //
            //            height += (retSize.height > 20 ? retSize.height : 20) + 10;
        }
            break;
        case EMMessageBodyTypeImage:
        case EMMessageBodyTypeVideo:
        {
            CGSize retSize = model.thumbnailImageSize;
            if (retSize.width == 0 || retSize.height == 0) {
                retSize.width = kEMMessageImageSizeWidth;
                retSize.height = kEMMessageImageSizeHeight;
            }
            else if (retSize.width > retSize.height) {
                CGFloat height = kEMMessageImageSizeWidth / retSize.width * retSize.height;
                retSize.height = height;
                retSize.width = kEMMessageImageSizeWidth;
            }
            else {
                CGFloat width = kEMMessageImageSizeHeight / retSize.height * retSize.width;
                retSize.width = width;
                retSize.height = kEMMessageImageSizeHeight;
            }
            
            return height += (retSize.height + 40);
            
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            height += kEMMessageLocationHeight;
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            height += kEMMessageVoiceHeight;
        }
            break;
        case EMMessageBodyTypeFile:
        {
            NSString *text = model.fileName;
            UIFont *font = cell.messageFileNameFont;
            CGRect nameRect;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                nameRect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            } else {
                nameRect.size = [text sizeWithFont:font constrainedToSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            }
            height += (nameRect.size.height > 20 ? nameRect.size.height : 20);
            
            text = model.fileSizeDes;
            font = cell.messageFileSizeFont;
            CGRect sizeRect;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                sizeRect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            } else {
                sizeRect.size = [text sizeWithFont:font constrainedToSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            }
            height += (sizeRect.size.height > 15 ? sizeRect.size.height : 15);
        }
            break;
        default:
            break;
    }
    
    height += EaseMessageCellPadding;
    model.cellHeight = height;
    //    model.cellHeight += 30;
    return height;
}

@end
