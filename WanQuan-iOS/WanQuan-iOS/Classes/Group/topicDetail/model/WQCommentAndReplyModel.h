//
//  WQCommentAndReplyModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQGroupReplyModel.h"
@interface WQCommentAndReplyModel : NSObject

@property (nonatomic, copy) NSString * tid;


/**
 该主题是否可以删除
 */
@property (nonatomic, assign) BOOL canDelete;


/**
 评论的 id
 */
@property (nonatomic, copy) NSString * id;

/**
 user_id true string 一级评论的用户ID

 */
@property (nonatomic, copy) NSString * user_id;

/**
 user_name true string 一级评论的用户姓名

 */
@property (nonatomic, copy) NSString * user_name;

/**
 user_tag true string 一级评论的用户Tag

 */
@property (nonatomic, copy) NSString * user_tag;

/**
 user_pic true string 一级评论的用户头像

 */
@property (nonatomic, copy) NSString * user_pic;

/**
 user_idcard_status true string 一级评论的idcard_status

 */
@property (nonatomic, copy) NSString * user_idcard_status;

/**
 createtime true string 一级评论的发布时间：yyyy-MM-dd HH:mm:ss

 */
@property (nonatomic, copy) NSString * createtime;

/**
 content true string 一级评论的内容

 */
@property (nonatomic, copy) NSString * content;

/**
 comment_count

 */
@property (nonatomic, copy) NSString * comment_count;


/**
 true array[object]当前一级评论下的二级评论
 */
@property (nonatomic, retain) NSArray * comments;

/**
 信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

/**
 几度好友
 */
@property (nonatomic, copy) NSString *user_degree;


//pic =             (
//                   c47573e8fc804e97a13fcf4cf9660f73
//                   );

/**
 评论带的图片
 (
     c47573e8fc804e97a13fcf4cf9660f73
 )
 */
@property (nonatomic, retain) NSArray * pic;


//"pic_widh_width_height" =             (
//                                       {
//                                           fileID = c47573e8fc804e97a13fcf4cf9660f73;
//                                           height = 1104;
//                                           width = 828;
//                                       }
//                                       );

/**
 图片的宽高比属性等
 (
     {
         fileID = c47573e8fc804e97a13fcf4cf9660f73;
         height = 1104;
         width = 828;
     }
 );
 */
@property (nonatomic, retain) NSArray * pic_widh_width_height;



//past_second

@property (nonatomic, retain) NSNumber * past_second;

@end
