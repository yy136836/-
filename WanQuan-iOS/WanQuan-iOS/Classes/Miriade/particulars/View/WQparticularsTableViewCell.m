//
//  WQparticularsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQparticularsTableViewCell.h"
#import "WQoriginalStatusView.h"
#import "WQretweetStatus.h"
#import "WQStatusToolBar.h"
#import "WQparticularsModel.h"
#import "WQoriginalContentView.h"
#import "WQlikeListView.h"
#import "WQzanLike_listModel.h"
#import "WQreward_ListView.h"
#import "WQThePastTimeView.h"
#import "WQlittleHelperStatusToolBarView.h"
#import "WQGroupForwardView.h"
#import "WQGroupInformationViewController.h"
#import "WQLinksContentView.h"
#import "WQTopicArticleController.h"
#import "WQsourceMomentStatusModel.h"

@interface WQparticularsTableViewCell() <WQoriginalContentViewDelegate>
@property (nonatomic, strong) WQoriginalContentView *originalContentView;
@property (nonatomic, strong) WQThePastTimeView *thePastTimeView;
//@property (nonatomic, strong) WQGroupForwardView *groupForwardView;
@property (nonatomic, strong) WQlittleHelperStatusToolBarView *littleHelperStatusToolBarView;
@property (nonatomic, copy) NSString *midString;

/**
 白图的view   加载数据前显示
 */
@property (nonatomic, strong) UIView *mengbanView;

@end

@implementation WQparticularsTableViewCell {
    WQLinksContentView *linksContentView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.picArray = [[NSArray alloc]init];
        NSString *midString = [[NSString alloc]init];
        self.midString = midString;
    }
    return self;
}

- (void)setupUI {
    self.originalStatusView = [[WQoriginalStatusView alloc]init];
    [self.contentView addSubview:_originalStatusView];
    
    self.retweetStatusView = [[WQretweetStatus alloc]init];
    [self.contentView addSubview:_retweetStatusView];
    
    self.thePastTimeView = [[WQThePastTimeView alloc]init];
    [self.contentView addSubview:_thePastTimeView];
    
//    self.groupForwardView = [[WQGroupForwardView alloc] init];
//    self.groupForwardView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
//    [_groupForwardView addGestureRecognizer:tap];
//    [self.contentView addSubview:_groupForwardView];
    
    self.statusToolBarView = [[WQStatusToolBar alloc]init];
    [self.contentView addSubview:_statusToolBarView];
    
    self.originalContentView = [[WQoriginalContentView alloc]init];
    self.originalContentView.delegate = self;
    [self.contentView addSubview:_originalContentView];
    
    linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick:)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    
    self.likeListView = [[WQlikeListView alloc]init];
    _likeListView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.contentView addSubview:_likeListView];
    
    self.reward_ListView = [[WQreward_ListView alloc]init];
    _reward_ListView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.contentView addSubview:_reward_ListView];
    
    self.littleHelperStatusToolBarView = [[WQlittleHelperStatusToolBarView alloc] init];
    self.littleHelperStatusToolBarView.isHome = NO;
    [self.contentView addSubview:_littleHelperStatusToolBarView];
    
    [_originalStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    [_retweetStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_originalStatusView.mas_bottom);
    }];
    
//    [_groupForwardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_retweetStatusView.mas_bottom);
//        make.height.offset(60);
//        make.right.left.equalTo(self.contentView);
//    }];
    
    [_originalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_retweetStatusView.mas_bottom).offset(ghStatusCellMargin);
        make.left.right.equalTo(self.contentView);
    }];
    
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalContentView.mas_bottom).offset(-ghStatusCellMargin);
        make.height.offset(60);
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
    
    [_thePastTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.left.equalTo(_originalContentView.mas_left);
        make.height.offset(30);
        make.top.equalTo(linksContentView.mas_bottom).offset(-5);
    }];
    [_likeListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.left.equalTo(_originalContentView.mas_left);
        make.top.equalTo(_thePastTimeView.mas_bottom).offset(ghStatusCellMargin);
    }];
    [_reward_ListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_likeListView.mas_bottom).offset(1);
        make.left.equalTo(_originalStatusView.mas_left);
        make.right.equalTo(self.contentView);
    }];
    [_statusToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(_reward_ListView.mas_bottom);
    }];
    
    [_littleHelperStatusToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(_reward_ListView.mas_bottom);
        make.height.offset(kScaleX(35));
    }];
    
    // 白图的view   加载数据前显示
    UIView *mengbanView = [[UIView alloc] init];
    self.mengbanView = mengbanView;
    mengbanView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mengbanView];
    [mengbanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    // 点击头像
    [self.originalStatusView setHeadPortraitBlock:^{
        if (weakSelf.headPortraitBlock) {
            weakSelf.headPortraitBlock();
        }
    }];
    
    [_littleHelperStatusToolBarView setUnlikeBtnBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(likBtnClike:mid:)]) {
            [weakSelf.delegate likBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    
    [_littleHelperStatusToolBarView setCommentBtnBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(commentsBtnClike:mid:)]) {
            [weakSelf.delegate commentsBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    
    //赞响应事件
    [_statusToolBarView setLikeBtnClikeBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(likBtnClike:mid:)]) {
            [weakSelf.delegate likBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    [_statusToolBarView setTreadBtnClikeBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(TreadBtnClike:mid:)]) {
            [weakSelf.delegate TreadBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    [_statusToolBarView setCommentsBtnClikeBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(commentsBtnClike:mid:)]) {
            [weakSelf.delegate commentsBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    [_originalStatusView setShareBtnClikeBlock:^{
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(shareBtnClike:mid:)]) {
            [weakSelf.delegate shareBtnClike:weakSelf mid:weakSelf.midString];
        }
    }];
    [self.statusToolBarView setPlayTourBtnClikeBlock:^{
        //状态id
        if ([weakSelf.model.user_id isEqualToString:[EMClient sharedClient].currentUsername]) {
            [WQAlert showAlertWithTitle:nil message:@"加油获得别人的鼓励吧" duration:1.3];
            return;
        }
        weakSelf.midString = weakSelf.model.id;
        if ([weakSelf.delegate respondsToSelector:@selector(wqsetPlayTourBtnDelegate:)]) {
            [weakSelf.delegate wqsetPlayTourBtnDelegate:weakSelf];
        }
    }];
    [_thePastTimeView setDeleteBtnClikeBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(wqDeleteBtnClikeDelegate:)]) {
            [weakSelf.delegate wqDeleteBtnClikeDelegate:weakSelf];
        }
    }];
    
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick:(UITapGestureRecognizer *)tap {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = _model.link_url;
    vc.NavTitle = _model.link_txt;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 转发外链的响应事件
- (void)wqLinksContentViewClick:(WQoriginalContentView *)originalContentView linkURLString:(NSString *)linkURLString {
    if ([self.delegate respondsToSelector:@selector(wqForwardingLinksContentViewClick:linkURLString:)]) {
        [self.delegate wqForwardingLinksContentViewClick:self linkURLString:linkURLString];
    }
}

- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = self.model.extras[@"group_id"];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(WQparticularsModel *)model {
    _model = model;
    _retweetStatusView.picArray = model.pic;
    _thePastTimeView.thePastTime = model.past_second;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是否可以赞
    if (!model.can_like) {
        // 不是自己发的
        if (![model.user_id isEqualToString:im_namelogin]) {
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
    
    if (![model.user_id isEqualToString:im_namelogin]) {
        _thePastTimeView.deleteBtn.hidden = YES;
    }
    
    if ([model.link_url isEqualToString:@""]) {
        linksContentView.hidden = YES;
        // 没有链接
        [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_thePastTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(_originalContentView.mas_left);
            make.height.offset(30);
            make.top.equalTo(_originalContentView.mas_bottom).offset(-50);
        }];
    }else {
        linksContentView.hidden = NO;
        if ([model.link_img isEqualToString:@""]) {
            linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
        }else {
            //[linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.link_url] options:0];
            [linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        }
        [linksContentView.linksLabel setText:model.link_txt];
        
        // 有链接
        [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_originalContentView.mas_bottom).offset(-ghDistanceershi);
            make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
            make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
            make.height.offset(60);
        }];
    }
    
    if ([model.type isEqualToString:@"TYPE_FW"]) {
        _originalContentView.particularsModel = model;
        WQsourceMomentStatusModel *statusModel = model.source_moment_status;
        if (statusModel.deleted) {
            _originalContentView.isDeleteOriginalContent = YES;
//            [_originalContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.height.offset(0);
//            }];
        }else {
            _originalContentView.model = model.source_moment_status;
        }

        _originalContentView.hidden = NO;
//        [_thePastTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView);
//            make.left.equalTo(_originalContentView.mas_left);
//            make.height.offset(30);
//            make.top.equalTo(_originalContentView.mas_bottom).offset(-5);
//        }];
        
        [_thePastTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(_originalContentView.mas_left);
            make.height.offset(30);
            make.top.equalTo(_originalContentView.mas_bottom);
        }];
        
        if (model.reward_list.count < 1 && model.like_list.count < 1) {
            [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_thePastTimeView.mas_bottom).offset(ghStatusCellMargin);
            }];
            [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_thePastTimeView.mas_bottom).offset(ghStatusCellMargin);
            }];
            _likeListView.hidden = YES;
            _reward_ListView.hidden = YES;
        }else{
            _likeListView.hidden = NO;
            _reward_ListView.hidden = NO;
            if (model.like_list.count >= 1 && model.reward_list.count < 1) {
                [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_likeListView.mas_bottom);
                }];
                [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_likeListView.mas_bottom);
                }];
            }else if (model.like_list.count < 1 && model.reward_list.count >= 1){
                [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_reward_ListView.mas_bottom);
                }];
                [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_reward_ListView.mas_bottom);
                }];
            }
            [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_reward_ListView.mas_bottom);
            }];
            [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_reward_ListView.mas_bottom);
            }];
            _reward_ListView.reward_list = model.reward_list;
        }
        
    }else{
        _originalContentView.hidden = YES;
        [_thePastTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(_originalContentView.mas_left);
            make.height.offset(30);
            make.top.equalTo(linksContentView.mas_bottom);
        }];
        
        
        if (model.reward_list.count < 1 && model.like_list.count < 1) {
            [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_thePastTimeView.mas_bottom).offset(ghStatusCellMargin);
            }];
            [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_thePastTimeView.mas_bottom).offset(ghStatusCellMargin);
            }];
            _likeListView.hidden = YES;
            _reward_ListView.hidden = YES;
        }else{
            _likeListView.hidden = NO;
            _reward_ListView.hidden = NO;
            if (model.like_list.count >= 1 && model.reward_list.count < 1) {
                [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_likeListView.mas_bottom);
                }];
                [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_likeListView.mas_bottom);
                }];
            }else if (model.like_list.count < 1 && model.reward_list.count >= 1){
                [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_reward_ListView.mas_bottom);
                }];
                [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(_reward_ListView.mas_bottom);
                }];
                // 高度设置为0不然会有一个灰条
                [_likeListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
            }
            [_statusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_reward_ListView.mas_bottom);
            }];
            [_littleHelperStatusToolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(_reward_ListView.mas_bottom);
            }];
            _reward_ListView.reward_list = model.reward_list;
        }
    }
    if (model.like_list.count == 0) {
        //_likeListView.praiseImageView.hidden = YES;
    }else {
        //_likeListView.praiseImageView.hidden = NO;
    }
    if (model.reward_list.count == 0) {
//        _reward_ListView.exceptionalIamgeView.hidden = YES;
    }else {
//        _reward_ListView.exceptionalIamgeView.hidden = NO;
    }
    
    if ([model.user_name isEqualToString:@"万圈小助手"]) {
        _littleHelperStatusToolBarView.hidden = NO;
        _statusToolBarView.hidden = YES;
        _littleHelperStatusToolBarView.CommentsLabel.text = [NSString stringWithFormat:@"%d",model.comment_count];
        _littleHelperStatusToolBarView.likeLabel.text = [NSString stringWithFormat:@"%d",model.like_count];
    }else {
        _littleHelperStatusToolBarView.hidden = YES;
        _statusToolBarView.hidden = NO;
    }
    
    
    self.mengbanView.hidden = YES;
    
    // 是转发的群组
//    if ([model.cate isEqualToString:@"CATE_GROUP"]) {
//        _groupForwardView.hidden = NO;
//        _originalContentView.hidden = YES;
//        [_groupForwardView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_retweetStatusView.mas_bottom).offset(-ghStatusCellMargin);
//            make.height.offset(60);
//            make.right.left.equalTo(self.contentView);
//        }];
//        
//        [_thePastTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView);
//            make.left.equalTo(_originalContentView.mas_left);
//            make.height.offset(30);
//            make.top.equalTo(_groupForwardView.mas_bottom).offset(ghStatusCellMargin);
//        }];
//        
//        NSString *groupImage = [imageUrlString stringByAppendingString:model.extras[@"group_pic"]];
//        [_groupForwardView.groupHeadPortrait yy_setImageWithURL:[NSURL URLWithString:groupImage] placeholder:[UIImage imageNamed:@""]];
//        _groupForwardView.nameLabel.text = model.extras[@"group_name"];
//        _groupForwardView.groupIntroduceLabel.text = model.extras[@"group_desc"];
//    }else {
//        _originalContentView.hidden = NO;
//        _groupForwardView.hidden = YES;
//        [_groupForwardView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_retweetStatusView.mas_bottom);
//            make.height.offset(0);
//            make.right.left.equalTo(self.contentView);
//        }];
//    }
    
}

@end
