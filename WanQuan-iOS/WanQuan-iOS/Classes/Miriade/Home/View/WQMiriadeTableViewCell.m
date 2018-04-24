//
//  WQMiriadeTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <YYLabel.h>
#import "WQMiriadeTableViewCell.h"
#import "WQOriginalStatusView.h"
#import "WQStatusToolBarView.h"
#import "WQRetweetStatusView.h"
#import "WQMiriadeaModel.h"
#import "WQlike_listModel.h"
#import "WQStatusPictureView.h"
#import "WQforwardingContentView.h"
#import "WQMiriadeViewController.h"
#import "WQretransmissionModel.h"
#import "WQlittleHelperStatusToolBarView.h"
#import "WQGroupForwardView.h"
#import "WQGroupInformationViewController.h"
#import "WQLinksContentView.h"

@interface WQMiriadeTableViewCell() <WQforwardingContentViewDelegate>
@property (nonatomic, copy) NSString *midString;
@end

@implementation WQMiriadeTableViewCell {
    WQLinksContentView *linksContentView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    NSString *midString = [[NSString alloc] init];
    self.midString = midString;
    
    self.originalstatus = [[WQOriginalStatusView alloc] init];
    [self.contentView addSubview:_originalstatus];
    
    self.groupForwardView = [[WQGroupForwardView alloc] init];
    self.groupForwardView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
    [_groupForwardView addGestureRecognizer:tap];
    [self.contentView addSubview:_groupForwardView];
    
    self.statusToolBarView = [[WQStatusToolBarView alloc] init];
    [self.contentView addSubview:_statusToolBarView];
    
    self.retweetStatusView = [[WQRetweetStatusView alloc] init];
    [self.contentView addSubview:_retweetStatusView];
    
    self.forwardingContentView = [[WQforwardingContentView alloc] init];
    self.forwardingContentView.delegate = self;
    [self.contentView addSubview:_forwardingContentView];
    
    self.littleHelperStatusToolBarView = [[WQlittleHelperStatusToolBarView alloc] init];
    self.littleHelperStatusToolBarView.isHome = YES;
    [self.contentView addSubview:_littleHelperStatusToolBarView];
    
    linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick:)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    
    //自动布局
    [_originalstatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    
    [_retweetStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_originalstatus.mas_bottom);
    }];
    
    [_forwardingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_retweetStatusView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
//    [_groupForwardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_retweetStatusView.mas_bottom);
//        make.height.offset(60);
//        make.right.left.equalTo(self.contentView);
//    }];
    
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_forwardingContentView.mas_bottom);
        make.height.offset(60);
        make.right.left.equalTo(self.contentView);
    }];
    
    [_littleHelperStatusToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(kScaleX(45));
        make.top.equalTo(linksContentView.mas_bottom);
    }];
    
    [_statusToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(kScaleX(45));
        make.top.equalTo(linksContentView.mas_bottom);
    }];
    
    __weak typeof(self) weakSelf = self;
    // 点击头像
    [self.originalstatus setHeadPortraitBlock:^{
        if (weakSelf.headPortraitBlock) {
            weakSelf.headPortraitBlock();
        }
    }];
    
    [self.originalstatus setClikeBlock:^(UIButton *sender) {
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if (weakSelf.shardClikeBlock) {
            weakSelf.shardClikeBlock(sender);
        };
    }];
    
    [self.littleHelperStatusToolBarView setUnlikeBtnBlock:^{
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqMiriadeTableViewCellDelegate:)]) {
            [weakSelf.delegate wqMiriadeTableViewCellDelegate:weakSelf];
        }
    }];
    
    [self.littleHelperStatusToolBarView setCommentBtnBlock:^{
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqCommentBtnDelegate:)]) {
            [weakSelf.delegate wqCommentBtnDelegate:weakSelf];
        };
    }];
    
    [self.statusToolBarView setUnlikeBtnBlock:^{
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqMiriadeTableViewCellDelegate:)]) {
            [weakSelf.delegate wqMiriadeTableViewCellDelegate:weakSelf];
        }
    }];
    
    [self.statusToolBarView setRetweetbtnBlock:^{
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqRetweetBtnDelegate:)]) {
            [weakSelf.delegate wqRetweetBtnDelegate:weakSelf];
        };
    }];
    
    [self.statusToolBarView setCommentBtnBlock:^{
        //状态id
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqCommentBtnDelegate:)]) {
            [weakSelf.delegate wqCommentBtnDelegate:weakSelf];
        };
    }];
    [self.statusToolBarView setPlayTourBtnClikeBlock:^{
        //状态id
        
        if ([weakSelf.miriadeaModel.user_id isEqualToString:[EMClient sharedClient].currentUsername]) {
            [WQAlert showAlertWithTitle:nil message:@"加油获得别人的鼓励吧" duration:1.3];
            return;
        }
        weakSelf.midString = weakSelf.miriadeaModel.id;
        if (weakSelf.midStringBlock) {
            weakSelf.midStringBlock(weakSelf.midString);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(wqsetPlayTourBtnDelegate:)]) {
            [weakSelf.delegate wqsetPlayTourBtnDelegate:weakSelf];
        }
    }];
    
    // 点击文字
    [self.retweetStatusView setContentLabelClikeBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(wqContentLabelClike:)]) {
            [weakSelf.delegate wqContentLabelClike:weakSelf];
        }
    }];
}

#pragma mark -- 转发外链的响应事件
- (void)wqLinksContentViewClick {
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:)]) {
        [self.delegate wqLinksContentViewClick:self];
    }
}

#pragma mark -- 转发外链的响应事件
- (void)wqLinksContentViewClick:(WQforwardingContentView *)forwardingContentView linkURLString:(NSString *)linkURLString {
    if ([self.delegate respondsToSelector:@selector(wqForwardingLinksContentViewClick:linkURLString:)]) {
        [self.delegate wqForwardingLinksContentViewClick:self linkURLString:linkURLString];
    }
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:)]) {
        [self.delegate wqLinksContentViewClick:self];
    }
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = self.miriadeaModel.extras[@"group_id"];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)setMiriadeaModel:(WQMiriadeaModel *)miriadeaModel {
    _miriadeaModel = miriadeaModel;
    
    if ([miriadeaModel.content isEqualToString:@""]) {
        _retweetStatusView.isContent = NO;
        _retweetStatusView.contentLabel.text = @" ";
    }else {
        _retweetStatusView.isContent = YES;
        _retweetStatusView.contentLabel.attributedText = [self getAttributedStringWithString:miriadeaModel.content lineSpace:5];
        _retweetStatusView.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    _originalstatus.creditPointsLabel.text = [miriadeaModel.user_creditscore stringByAppendingString:@"分"];
    
    if (miriadeaModel.truename) {
        switch (miriadeaModel.user_tag.count) {
            case 1:{
                _originalstatus.tagOncLabel.hidden = NO;
                _originalstatus.tagOncLabel.text = miriadeaModel.user_tag.firstObject;
                _originalstatus.tagTwoLabel.hidden = YES;
            }
                break;
            case 2:{
                _originalstatus.tagOncLabel.hidden = NO;
                _originalstatus.tagTwoLabel.hidden = NO;
                _originalstatus.tagOncLabel.text = miriadeaModel.user_tag.firstObject;
                _originalstatus.tagTwoLabel.text = miriadeaModel.user_tag.lastObject;
            }
                break;
            case 0:{
                _originalstatus.tagTwoLabel.hidden = YES;
                _originalstatus.tagOncLabel.hidden = YES;
            }
                break;
            default:
                break;
        }
    }else {
        _originalstatus.tagTwoLabel.hidden = YES;
        _originalstatus.tagOncLabel.hidden = YES;
    }
    
    _originalstatus.nameLabel.text = miriadeaModel.user_name;
    [_originalstatus.iconView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(miriadeaModel.user_pic)] options:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是否可以赞
    if (!miriadeaModel.can_like) {
        // 不是自己发的
        if (![miriadeaModel.user_id isEqualToString:im_namelogin]) {
            [_statusToolBarView.unlikeBtn setImage:[UIImage imageNamed:@"yidianzan"] forState:UIControlStateNormal];
            _statusToolBarView.likeLabel.textColor = [UIColor colorWithHex:0xee9b11];
            [_littleHelperStatusToolBarView.unlikeBtn setImage:[UIImage imageNamed:@"yidianzan"] forState:UIControlStateNormal];
            _littleHelperStatusToolBarView.likeLabel.textColor = [UIColor colorWithHex:0xee9b11];
        }
    }else {
        [_statusToolBarView.unlikeBtn setImage:[UIImage imageNamed:@"haoyouquanzan"] forState:UIControlStateNormal];
        _statusToolBarView.likeLabel.textColor = [UIColor colorWithHex:0x999999];
        [_littleHelperStatusToolBarView.unlikeBtn setImage:[UIImage imageNamed:@"haoyouquanzan"] forState:UIControlStateNormal];
        _littleHelperStatusToolBarView.likeLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    
    //赞,踩,评论数量
    _statusToolBarView.likeLabel.text = [NSString stringWithFormat:@"%d",miriadeaModel.like_count];
    _statusToolBarView.TreadLable.text = [NSString stringWithFormat:@"%d",miriadeaModel.dislike_count];
    _statusToolBarView.CommentsLabel.text = [NSString stringWithFormat:@"%d",miriadeaModel.comment_count];
    _statusToolBarView.like_count = miriadeaModel.like_count;
    _retweetStatusView.picArray = miriadeaModel.pic;
    // type状态为原创
    
    
    if ([miriadeaModel.user_name isEqualToString:@"万圈小助手"]) {
        _littleHelperStatusToolBarView.hidden = NO;
        _statusToolBarView.hidden = YES;
        [_originalstatus.creditBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(42);
        }];
        _littleHelperStatusToolBarView.CommentsLabel.text = [NSString stringWithFormat:@"%d",miriadeaModel.comment_count];
        _littleHelperStatusToolBarView.likeLabel.text = [NSString stringWithFormat:@"%d",miriadeaModel.like_count];
    }else {
        _littleHelperStatusToolBarView.hidden = YES;
        _statusToolBarView.hidden = NO;
    }
    // 是否有外链
    if ([miriadeaModel.link_url isEqualToString:@""]) {
        // 没有链接
        linksContentView.hidden = YES;
        [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        // 不是转发的
        if ([miriadeaModel.type isEqualToString:@"TYPE_ORIGINAL"]) {
            _forwardingContentView.hidden = YES;
            
            [_littleHelperStatusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.offset(kScaleX(45));
                make.top.equalTo(_retweetStatusView.mas_bottom);
            }];
            
            [_statusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.offset(kScaleX(45));
                make.top.equalTo(_retweetStatusView.mas_bottom);
            }];
        }else{
            // 是转发的
//            if ([miriadeaModel.cate isEqualToString:@"CATE_GROUP"]) {
//                _forwardingContentView.isGroupForwarding = YES;
//            }else {
//                _forwardingContentView.isGroupForwarding = NO;
//            }

            _forwardingContentView.hidden = NO;
            _forwardingContentView.model = miriadeaModel.source_moment_status;
            
//            [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView.mas_left).offset(ghSpacingOfshiwu);
//                make.top.equalTo(_forwardingContentView.mas_bottom);
//                make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
//                make.height.offset(0);
//            }];
            [_littleHelperStatusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.offset(kScaleX(45));
                make.top.equalTo(_forwardingContentView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            [_statusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.offset(kScaleX(45));
                make.top.equalTo(_forwardingContentView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }
        
    }else {
        // 有链接
        linksContentView.hidden = NO;
        if ([miriadeaModel.link_img isEqualToString:@""]) {
            linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
        }else {
            [linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:miriadeaModel.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        }
        [linksContentView.linksLabel setText:miriadeaModel.link_txt];
        
        _forwardingContentView.hidden = YES;
        
        [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(ghSpacingOfshiwu);
            make.top.equalTo(_retweetStatusView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
            make.height.offset(60);
        }];
        
        [_littleHelperStatusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.offset(kScaleX(45));
            make.top.equalTo(linksContentView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        
        [_statusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.offset(kScaleX(45));
            make.top.equalTo(linksContentView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
