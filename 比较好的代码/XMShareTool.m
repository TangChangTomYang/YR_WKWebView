//
//  XMShareTool.m
//  IMKit
//
//  Created by yangrui on 2020/5/11.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMShareTool.h"


@implementation XMShareTool

// 微信好友分享 图片
+(NSDictionary *)weChatFriend_ImageShareInfoWithImageUrl:(NSString *)imageurl{
    NSString *imgUrl = imageurl.length > 0 ? imageurl : 0;
   
    return @{@"mine":@"image",
             @"thumbData": imgUrl,
             @"channel":@"weixin"};
}

// 微信朋友圈分享 图片
+(NSDictionary *)weChatFriendCircle_ImageShareInfoWithImageUrl:(NSString *)imageurl{
    NSString *imgUrl = imageurl.length > 0 ? imageurl : 0;
   
    return @{@"mine":@"image",
             @"thumbData": imgUrl,
             @"channel":@"weixinGroup"};
}


 



 

 // 微信好友分享 连接
+(NSDictionary *)weChatFriend_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                             title:(NSString *)title
                                     thumbImageUrl:(NSString *)thumbImageUrl
                                              desc:(NSString *)desc{
     NSString *url = linkUrl.length > 0 ? linkUrl : 0;
     NSString *thumbImgUrl = thumbImageUrl.length > 0 ? thumbImageUrl : 0;
     NSString *titleStr = title.length > 0 ? title : 0;
     NSString *descStr = desc.length > 0 ? desc : 0;
     
     return  @{@"mime":@"link",
               @"title":titleStr,
               @"thumbData":thumbImgUrl,
               @"url":url,
               @"desc":descStr,
               @"channel":@"weixin"};
 }

 // 微信 朋友圈分享 连接
+(NSDictionary *)weChatFriendCircle_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                             title:(NSString *)title
                                     thumbImageUrl:(NSString *)thumbImageUrl
                                              desc:(NSString *)desc{
     NSString *url = linkUrl.length > 0 ? linkUrl : 0;
     NSString *thumbImgUrl = thumbImageUrl.length > 0 ? thumbImageUrl : 0;
     NSString *titleStr = title.length > 0 ? title : 0;
     NSString *descStr = desc.length > 0 ? desc : 0;
     
     return  @{@"mime":@"link",
               @"title":titleStr,
               @"thumbData":thumbImgUrl,
               @"url":url,
               @"desc":descStr,
               @"channel":@"weixinGroup"};
 }


// 微博 分享 图片
+(NSDictionary  *)weBo_imageShareInfoWithImageUrl:(NSString *)imageUrl{
    
    NSString *imgUrl = imageUrl.length > 0 ? imageUrl : @"";
    
    return  @{@"mime":@"image",
              @"channel":@"weibo",
              @"thumbData":imgUrl};
}

// 微博 分享 连接
+(NSDictionary  *)weBo_LinkShareInfoWithLinkUrl:(NSString *)linkUrl
                                          title:(NSString  *)title
                                           text:(NSString *)text{
    
    NSString *url = linkUrl.length > 0 ? linkUrl : @"";
    NSString *urlTitle = title.length > 0 ? title : @"";
    NSString *textStr = text.length > 0 ? text : @"";
   
    
    return  @{@"mime":@"link",
              @"channel":@"weibo",
              @"urlTitle":urlTitle,
              @"url":url,
              @"text":textStr};

}


// 分享转发 给圈友 图片
+(void)transmit2CircleFriendImage:(NSString *)imageUrl fromVC:(UIViewController *)fromVC{
    
//    if (![[XMLogonManager sharedXMLogonManager] isLogoned]) {
//        [TYHUDTools showError:@"未登录"];
//        return;
//    }
    
    [[XMSelectorTools shareSelectorTools] presentChatRelateControllerWithController:fromVC
                                                                           Callback:^(NSMutableArray *selectMember){
        // 选择的 好友成员
        if (!selectMember) {
            return ;
        }
        
        [[XMImageCacheHelper sharedXMImageCacheHelper] downloadFileWithURL:imageUrl
                                                                  progress:nil
                                                                 completed:^(BOOL isSuccess, NSString * _Nonnull fileID, NSData * _Nullable fileData) {
            
            // 图片下载完成
            if (isSuccess) {
                // 二进制data -> UIImage
                UIImage *image = [UIImage imageWithData:fileData];
                // 文件模型
                FileInfoModel *fileInfo= [XMFileTools createImageModel:image];
                
                [selectMember enumerateObjectsUsingBlock:^(NSNumber *userId, NSUInteger idx, BOOL *stop) {
                    
                    // 聊天模型数据
                    ChatModel *model = [[XMIMManager sharedXMIMManager] XMCreateFileMessage:[userId longLongValue]
                                                                              fileInfoArray:[NSMutableArray arrayWithObjects:fileInfo, nil]
                                                                                messageType:MessageTypeImage
                                                                              groupSendUids:nil];
                    
                    // 发送消息
                    [[XMIMManager sharedXMIMManager] sendMessage:model
                                                          chatId:[userId longLongValue]
                                                        progress:^(CGFloat progress, NSString * _Nonnull fileID) {
                        
                    }
                                                       completed:^(BOOL isSuccess, NSString * _Nonnull fileID) {
                        if(isSuccess){
                            [TYHUDTools showSuccess:NSInternational(@"general_sent_success")];
                        }
                        else{
                            // 消息发送失败
                            [TYHUDTools showError:NSInternational(@"chat_message_send_failed")];
                        }
                    }];
                    
                }];
            }
            else{
                [TYHUDTools showError:@"图片下载失败，请检查网络设置"];
            }
        }];
    }];
        
       
}


// 分享转发 给圈友 链接(差一个subTitle 考虑一下)
+(void)transmit2CircleFriendLinkUrl:(NSString *)linkUrl
                              title:(NSString *)title
                            content:(NSString *)content
                           imageUrl:(NSString *)imageUrl
                             fromVC:(UIViewController *)fromVC{
    
//    if (![[XMLogonManager sharedXMLogonManager] isLogoned]) {
//        UILog(@"----分享 圈友 连接时 未登录 ");
//        [TYHUDTools showError:@"未登录"];
//        return;
//    }
    
     if (title.length <= 0) {
         title = @"";
     }
     if (content.length <= 0) {
         content = @"";
     }
     if (imageUrl.length <= 0) {
         imageUrl = @"";
     }
     if (linkUrl.length <= 0) {
         linkUrl = @"";
     }
    
     NSDictionary *jsonDic = @{@"contentType" : @(1),                        // imgtype = 1 ?
                               @"content" : @{@"title":title,
                                              @"detail":content,
                                              @"link":linkUrl,
                                              @"image":@{@"imageUrl":imageUrl,
                                                         @"imgType":@(1)}},  // imgtype = 1 ?
                               @"push" : @{@"title":title,
                                           @"msg":content,
                                           @"action":linkUrl}
                             };
     NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    
    [[XMSelectorTools shareSelectorTools] presentChatRelateControllerWithController:fromVC Callback:^(NSMutableArray *selectMember){
        // 选择的 好友成员
        if (!selectMember) {
            return ;
        }
        
        [selectMember enumerateObjectsUsingBlock:^(NSNumber *userId, NSUInteger idx, BOOL *stop){
                      
                      ChatModel *model = [[XMIMManager sharedXMIMManager] XMCreateLinkMessageFormatMessage:[userId longLongValue]
                                                                                                      text:jsonStr
                                                                                             groupSendUids:nil];
                      
                      [[XMIMManager sharedXMIMManager] XMSendMessage:[userId longLongValue] messageItem:model];
                      if(model){
                          // 已发送
                          [TYHUDTools showSuccess:NSInternational(@"chat_message_sent")];
                      }
                      else{
                          // 消息发送失败
                          [TYHUDTools showError:NSInternational(@"chat_message_send_failed")];
                      }
                      
                  }];
        
    }];
   
   
                  
     
     
       
}
 
@end
