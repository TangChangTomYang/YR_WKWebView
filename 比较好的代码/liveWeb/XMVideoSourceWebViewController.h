//
//  XMVideoSourceWebViewController.h
//  IMKit
//
//  Created by yangrui on 2020/5/15.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMVideoSourceWebViewController : XMBaseWebViewController

/**
 {
     androidType = 3;
    // 邀请卡
     invitationCard =     {
         content = "";
         link = 11;
         name = "";
         time = 1589349927000;
         title = "\U76f4\U64ad\U540e\U7ba1\U6d4b\U8bd5\U7b2c\U4e8c\U8f6e\U5386\U53f2\U5217\U8868";
     };
    // 分享 info
     paramer =     {
         content = "\U76f4\U64ad\U540e\U7ba1\U6d4b\U8bd5\U7b2c\U4e8c\U8f6e\U5386\U53f2\U5217\U8868";
         imageUrl = "https://cib.feinno.net:19203/group1/M00/06/DF/qAc9qV683pHstV7iAAAVLNQq82U171.jpg";
         link = 11;
         title = "\U5708\U5b50\U76f4\U64ad\U95f4";
     };
     type = link;
 }
 
 */



/**
 {
     content = "\U76f4\U64ad\U540e\U7ba1\U6d4b\U8bd5\U7b2c\U4e8c\U8f6e\U5386\U53f2\U5217\U8868";
     imageUrl = "https://cib.feinno.net:19203/group1/M00/06/DF/qAc9qV683pHstV7iAAAVLNQq82U171.jpg";  // 分享图片 连接
     link = 11;
     title = "\U5708\U5b50\U76f4\U64ad\U95f4";
 }
 */
@property(nonatomic, strong)NSDictionary *shareInfo;

/**
 {
     content = "";  // 内容,
     link = 11;     // 二维码链接
     name = "";     //
     time = 1589349927000;  //
     title = "\U76f4\U64ad\U540e\U7ba1\U6d4b\U8bd5\U7b2c\U4e8c\U8f6e\U5386\U53f2\U5217\U8868"; // 标题,
 }
 */
@property(nonatomic, strong)NSDictionary *invitationCardInfo;
@end

NS_ASSUME_NONNULL_END
