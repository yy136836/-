//
//  WQIndividualTrendsTableView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQIndividualTrendsTableView.h"
#import "WQIndividualTrendsReplyCell.h"
@interface WQIndividualTrendsTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WQIndividualTrendsTableView

- (instancetype)init {
    if (self = [super init]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"WQIndividualTrendsReplyCell" bundle:nil] forCellReuseIdentifier:@"WQIndividualTrendsReplyCell"];
        self.scrollEnabled = NO;
        self.backgroundColor = HEX(0xf3f3f3);
        
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.comment_children_count.intValue > 2 ? 3  : _model.comment_children_count.intValue;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQIndividualTrendsReplyCell * cell = [self dequeueReusableCellWithIdentifier:@"WQIndividualTrendsReplyCell"];
    CGFloat height = indexPath.row < _model.comment_children.count ? [cell heightWithModel:_model.comment_children[indexPath.row]] : 25;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     WQIndividualTrendsReplyCell * cell = [self dequeueReusableCellWithIdentifier:@"WQIndividualTrendsReplyCell"];
    if (indexPath.row < _model.comment_children.count) {
        cell.model = _model.comment_children[indexPath.row];
        
    } else {
        UIFont * font = [UIFont systemFontOfSize:14];
        UIColor * linkColor = [UIColor colorWithHex:0x9767d0];
        UIColor * commenColor = [UIColor colorWithHex:0x333333];
        NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        style.lineSpacing = 5;
        
        NSDictionary * moreAttr = @{
                                    NSFontAttributeName : font,
                                    NSForegroundColorAttributeName:linkColor,
                                    NSLinkAttributeName:@"more",
                                    NSParagraphStyleAttributeName : style
                                    };
        
        NSMutableAttributedString *  att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%zd条回复>",_model.comment_children_count] attributes:moreAttr];
        [att yy_setTextHighlightRange:NSMakeRange(0, att.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            // TODO: showMore;pushCommentDetail;
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
