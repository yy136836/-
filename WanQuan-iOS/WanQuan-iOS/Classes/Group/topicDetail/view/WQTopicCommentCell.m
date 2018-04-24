//
//  WQTopicCommentCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicCommentCell.h"
#import "WQCommentTextView.h"
#import "WQUserProfileController.h"
#import <NSAttributedString+YYText.h>
#import "WQCommentDetailController.h"
#import "WQUserProfileController.h"


#import "WQPhotoBrowser.h"


@interface WQTopicCommentCell ()<UITextViewDelegate,MWPhotoBrowserDelegate, YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *postTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *creditButton;
@property (nonatomic, retain) YYLabel * commentShowLabel;


/**
 评论按钮
 */
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

/**
 评论里面带的图片
 */
@property (nonatomic, retain) UIImageView * commentCottentImageView;
@end

@implementation WQTopicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    
    [_commentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentOntap)]];
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarOntap)]];
    
    
//    if (!_commentShowLabel) {

//    }
    
//    if (!_commentShowLabel) {
//        _commentShowLabel = [[YYLabel alloc] init];
//        [self.contentView addSubview:_commentShowLabel];
//    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setModel:(WQCommentAndReplyModel *)model {
    _model = model;
    
    for (UIImageView * image in self.contentView.subviews) {
        if ([image isKindOfClass:[UIImageView class]]&&(image.width == 200 || image.height == 200)) {
            [image removeFromSuperview];
        }
    }
    
    _addHeight = 0;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(_model.user_pic)] options:YYWebImageOptionProgressive];
    _userName.text = model.user_name;
    
    _postTimeLable.text = model.createtime;
    
    if (_commentShowLabel) {
        [_commentShowLabel removeFromSuperview];
    }
    
    _commentShowLabel = [[YYLabel alloc] init];
    [self.contentView addSubview:_commentShowLabel];
    [_creditButton setTitle:[NSString stringWithFormat:@"%@分",model.user_creditscore] forState:UIControlStateNormal];
    
    NSString * degreeStr ;
    
    NSInteger degree = model.user_degree.integerValue;
    if (degree == 0) {
        degreeStr = @"自己";
    }else if (degree <= 2) {
        degreeStr = @"2度内好友";
    } else if (degree == 3){
        degreeStr = @"3度好友";
    } else {
        degreeStr = @"4度外好友";
    }
    
//    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
//    style.headIndent = 10;
//    style.tailIndent = 10;
//    
//    NSAttributedString * attr = [[NSAttributedString alloc] initWithString:degreeStr attributes:@{NSParagraphStyleAttributeName:style}];
    
    _degreeLabel.text = degreeStr;
    CGSize size = [_degreeLabel sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    
    [_degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_creditButton.mas_right).offset(10);
        make.height.equalTo(_creditButton.mas_height);
        make.width.width.equalTo(@(size.width + 10));
    }];
    
//    评论内容
    _commentLabel.text = model.content?:@"";
    _commentLabel.hidden = YES;
    
    
    _commentShowLabel.frame = CGRectMake(_commentLabel.x, _commentLabel.y, kScreenWidth - 80, 21);
    //        lab.textContainerInset = UIEdgeInsetsMake(3, 0, 3, 0);
    _commentShowLabel.numberOfLines = 0;
    
//    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 10;
    NSMutableAttributedString*  attr = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@{NSForegroundColorAttributeName:_commentLabel.textColor,NSFontAttributeName:_commentLabel.font}];
    
    
//    UILabel * lab = [UILabel new];
    [_commentLabel setAttributedText:attr] ;
    [_commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 80, MAXFLOAT)];
    
    attr.yy_lineSpacing = 6;
    
    [_commentShowLabel setAttributedText:attr];
    
    CGSize commentSize = [_commentShowLabel sizeThatFits:CGSizeMake(kScreenWidth - 80, MAXFLOAT)];
    
    if (commentSize.height > 21) {
        _commentShowLabel.frame = CGRectMake(_commentShowLabel.x, _commentShowLabel.y, _commentShowLabel.width, commentSize.height);
    } else {
        _commentShowLabel.frame = CGRectMake(_commentShowLabel.x, _commentShowLabel.y, _commentShowLabel.width, 21);
    }

    
    CGPoint commentStart = CGPointMake(70, _commentShowLabel.y + _commentShowLabel.height + 10);

    _addHeight += commentSize.height - 21;

    
//    图片
//    [_commentImageView removeFromSuperview];
    if (model.pic.count) {
        
        
        
        _commentCottentImageView = [[UIImageView alloc] init];
        CGFloat picWidth = 0;
        CGFloat picHeight = 0;
        
        [self.contentView addSubview:_commentCottentImageView];
        //        {
//            fileID = c47573e8fc804e97a13fcf4cf9660f73;
//            height = 1104;
//            width = 828;
//        }
        NSDictionary * picInfo = model.pic_widh_width_height[0];
        
        CGFloat width = [picInfo[@"width"] doubleValue];
        CGFloat height = [picInfo[@"height"] doubleValue];
        
        CGFloat factor = width / height;
        
        
        
        
        CGFloat minFactor = 0.75;
        CGFloat macFactor = 1.33;
        CGFloat maxLengthOfSide = 200;
        CGFloat minLengthOfSide = 150;
        
        if (factor < minFactor) {
            picHeight = maxLengthOfSide;
            picWidth = minLengthOfSide;
        } else if (factor > macFactor) {
            picWidth = minLengthOfSide;
            picHeight = maxLengthOfSide;
        } else {
            picHeight = maxLengthOfSide;
            picWidth = maxLengthOfSide;
        }
        
        _commentCottentImageView.frame = CGRectMake(commentStart.x, commentStart.y, picWidth, picHeight);
        _commentCottentImageView.contentMode = UIViewContentModeScaleAspectFill;
        commentStart.y = commentStart.y + picHeight + 15;
        _commentCottentImageView.clipsToBounds = YES;
        _addHeight += (picHeight + 10);
        [_commentCottentImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(model.pic[0])] options:YYWebImageOptionProgressive];
        _commentCottentImageView.userInteractionEnabled = YES;
        [_commentCottentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic)]];
        
    }//    二级评论
    NSArray * secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:model.comments];

    
    NSLog(@"%f",_addHeight);
    if (secondnaryComments.count) {
        [self creatCommentsWith:secondnaryComments startPoint:commentStart];
    }
    NSLog(@"%f\n\n\n",_addHeight);
}

- (void)creatCommentsWith:(NSArray *)comments startPoint:(CGPoint)startPoint{
    
    if (!comments.count) {
        return;
    }
    
    if (comments.count < 3) {
        
        for (NSInteger i = 0 ; i < comments.count;  ++ i) {
            WQCommentTextView * textView = [[WQCommentTextView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, kScreenWidth - 70 - 10, 10)];
            textView.model = comments[i];
//            textView.delegate = self;
            [self.contentView addSubview:textView];
            startPoint.x = startPoint.x;
            startPoint.y += textView.height;
            _addHeight +=  textView.height;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [textView addGestureRecognizer:tap];
            
        }
    } else {
        for (NSInteger i = 0 ; i < 2;  ++ i) {
            WQCommentTextView * textView = [[WQCommentTextView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, kScreenWidth - 70 - 10, 10)];
            textView.model = comments[i];
//            textView.delegate = self;
            _addHeight += textView.height;
            [self.contentView addSubview:textView];
            startPoint.x = startPoint.x;
            startPoint.y += textView.height;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [textView addGestureRecognizer:tap];

        }
        WQCommentTextView * textView = [[WQCommentTextView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, kScreenWidth - 70 - 10, 25)];
        
        
        NSDictionary * moreAttr = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:[UIColor colorWithHex:0x9767d0],
                                    NSLinkAttributeName:@"more"
                                    };
        
        NSMutableAttributedString *  att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%zd条回复>",comments.count] attributes:moreAttr];
        
        
        textView.font = [UIFont systemFontOfSize:14];
        [att yy_setTextHighlightRange:NSMakeRange(0, att.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self textView:textView shouldInteractWithURL:[NSURL URLWithString:@"more"] inRange:NSMakeRange(0, 1)];
        }];
        
        textView.attributedText = att;
        textView.frame = CGRectMake(textView.x, textView.y, textView.contentSize.width, textView.contentSize.height);
        textView.delegate = self;
        [self.contentView addSubview:textView];
        startPoint.x = startPoint.x;
        startPoint.y += textView.height;
        _addHeight += textView.height;
        
        
    }
    _addHeight += 15;

}



#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString isEqualToString:@"more"]) {
//        推出评论详情页面
        if (self.delegate && [self.delegate respondsToSelector:@selector(WQTopicCommentCellDelegateshowMore:)]) {
            
            //        self.delegate WQTopicCommentCellD:self addComment:self.model
            [self.delegate WQTopicCommentCellDelegateshowMore:_model];
        }
        
    } else {
//        推出个人页面
        WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:URL.absoluteString];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }
    return NO;
}






- (void)commentOntap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQTopicCommentCellD:addCommentWithId:)]) {
        [self.delegate WQTopicCommentCellD:self addCommentWithId:nil];
    }
}



- (void)avatarOntap {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    __weak typeof(self) weakSelf = self;
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    
    
    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:im_namelogin];
        
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
}


- (void)onTap:(UITapGestureRecognizer *)tap {
    
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        WQCommentTextView * textView = (WQCommentTextView * )(tap.view);

        CGPoint point = [tap locationInView:textView];

        NSAttributedString * str = textView.attributedText;

        NSDictionary * dic = textView.highlightTextAttributes;


         [self textView:nil shouldInteractWithURL:[NSURL URLWithString:@"more"] inRange:NSMakeRange(0, 1)];
    }
}

- (void)showPic {
    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser .currentPhotoIndex = 0;
    browser.alwaysShowControls = NO;
    
    browser.displayActionButton = NO;
    
    browser.shouldTapBack = YES;
    
    browser.shouldHideNavBar = YES;
    
    [self.viewController.navigationController pushViewController:browser animated:YES];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:WEB_IMAGE_URLSTRING(_model.pic[0])];
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    
    return photo;
}



@end
