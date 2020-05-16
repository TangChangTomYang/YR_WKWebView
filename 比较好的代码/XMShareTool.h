//
//  XMShareTool.h
//  IMKit
//
//  Created by yangrui on 2020/5/11.
//  Copyright © 2020 Darren. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "XMImageCacheHelper.h"
#import "XMSelectorTools.h"
#import "XMFileTools.h"
#import "XMIMManager.h"
#import "TYHUDTools.h"
#import "GlobalConfig.h"





@interface XMShareTool : NSObject

// 微信好友分享 图片
+(NSDictionary *)weChatFriend_ImageShareInfoWithImageUrl:(NSString *)imageurl;

// 微信朋友圈分享 图片
+(NSDictionary *)weChatFriendCircle_ImageShareInfoWithImageUrl:(NSString *)imageurl;

 

 // 微信好友分享 连接
+(NSDictionary *)weChatFriend_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                             title:(NSString *)title
                                     thumbImageUrl:(NSString *)thumbImageUrl
                                                  desc:(NSString *)desc;

 // 微信 朋友圈分享 连接
+(NSDictionary *)weChatFriendCircle_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                             title:(NSString *)title
                                     thumbImageUrl:(NSString *)thumbImageUrl
                                                        desc:(NSString *)desc;


// 微博 分享 图片
+(NSDictionary  *)weBo_imageShareInfoWithImageUrl:(NSString *)imageUrl;

// 微博 分享 连接
+(NSDictionary  *)weBo_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                          title:(NSString  *)title
                                           text:(NSString *)text;


// 分享转发 给圈友 图片
+(void)transmit2CircleFriendImage:(NSString *)imageUrl fromVC:(UIViewController *)fromVC;


// 分享转发 给圈友 链接
+(void)transmit2CircleFriendLinkUrl:(NSString *)linkUrl
                              title:(NSString *)title
                            content:(NSString *)content
                           imageUrl:(NSString *)imageUrl
                             fromVC:(UIViewController *)fromVC;

@end
 
