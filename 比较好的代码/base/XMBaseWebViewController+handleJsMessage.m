//
//  XMBaseWebViewController+handleJsMessage.m
//  IMKit
//
//  Created by yangrui on 2020/5/14.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMBaseWebViewController+handleJsMessage.h"
#import "XMShareTool.h"
#import "XMOuterLinkArticleWebViewController.h"
#import "XMVideoSourceWebViewController.h"


 


@implementation XMBaseWebViewController (handleJsMessage)

-(void)handleJs_doBack{
    [self webViewGoBack];
}


-(void)handleJs_doLogin{
    [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
        NSDictionary *paramDic = @{@"currentVC": self, @"isJumpToUI":@(YES)};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XMJumpBankLogonNotification object:nil userInfo:paramDic];
    }];
}

-(void)handleJs_getUserData:(NSDictionary *)dic{
    BOOL isLogoned = [self isLogined];
    
    NSString *mobile = [self mobilePhoneStr];
    NSInteger userType = [self bankUserType];
    if (!isLogoned) {
       mobile = @"0";
       userType = 0;
    }
    
    NSString *callbackMethodName = dic[@"callback"];

    NSDictionary *callbackParamDic = @{@"mobile":mobile,
                                       @"isLogoned":@(isLogoned),
                                       @"userType":@(userType)};
   NSData *callbackParamDicData = [NSJSONSerialization dataWithJSONObject:callbackParamDic options:0 error:nil];
   NSString *callbackParamDicDataStr = [[NSString alloc]initWithData:callbackParamDicData encoding:NSUTF8StringEncoding];
   NSString *jsStr = [NSString stringWithFormat:@"%@('%@')",callbackMethodName,callbackParamDicDataStr];

   [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


 /**
  shareInfo 中包含一个  type 标记分享类型
  
  */
-(void)handleJs_doShare:(NSDictionary *)shareInfo{
    
    NSInteger shareType = [shareInfo[@"type"] integerValue];
    
    if(shareType == 1){// 圈子 连接分享
        // 圈子 图片 分享 还没有 type 做
       UILog(@"---分享 圈子 连接分享");
        [self js_shareCircleUrlLink:shareInfo];
        return;
    }
    
    if(shareType == 2){ // 微信 连接
        UILog(@"---分享 微信 连接");
        [self js_shareWeChatLink:shareInfo];
        return;
    }
    
    if(shareType == 3){ // 微信 朋友圈 连接
       UILog(@"---分享 微信 朋友圈 连接");
       [self js_shareWeChatCircleLink:shareInfo];
       return;
    }
    
    if(shareType == 4){ // 微博 连接
        UILog(@"---分享 微博 连接");
        [self js_shareWeboLink:shareInfo];
        return;
    }
     
    if(shareType == 5){ // 分享 复制 连接
        UILog(@"---分享 复制 连接");
        [self js_shareCopyLink:self.webViewUrl];
        return;
    }
    
}

-(void)js_shareWeChatLink:(NSDictionary *)dic{
    
    NSString *linkUrl = dic[@"linkUrl"];
    if(linkUrl.length ==  0){
        linkUrl = @"";
    }
    
    NSString *content = dic[@"content"];
    if(content.length ==  0){
        content = @"";
    }
    
    NSString *imgUrl = dic[@"imgUrl"];
    if(imgUrl.length ==  0){
        imgUrl = @"";
    }
    NSString *title = dic[@"title"];
    if(title.length ==  0){
        title = @"";
    }
    
    [XMShareTool weChatFriend_LinkShareInfoWithLinkUrl:linkUrl title:title thumbImageUrl:imgUrl desc:content];
}

-(void)js_shareWeChatCircleLink:(NSDictionary *)dic{
   NSString *linkUrl = dic[@"linkUrl"];
   if(linkUrl.length ==  0){
       linkUrl = @"";
   }
   
   NSString *content = dic[@"content"];
   if(content.length ==  0){
       content = @"";
   }
   
   NSString *imgUrl = dic[@"imgUrl"];
   if(imgUrl.length ==  0){
       imgUrl = @"";
   }
   NSString *title = dic[@"title"];
   if(title.length ==  0){
       title = @"";
   }
   
   [XMShareTool weChatFriendCircle_LinkShareInfoWithLinkUrl:linkUrl title:title thumbImageUrl:imgUrl desc:content];
}

-(void)js_shareWeboLink:(NSDictionary *)dic{
    NSString *linkUrl = dic[@"linkUrl"];
    if(linkUrl.length ==  0){
        linkUrl = @"";
    }
    
    NSString *content = dic[@"content"];
    if(content.length ==  0){
        content = @"";
    }
     
    NSString *title = dic[@"title"];
    if(title.length ==  0){
        title = @"";
    }
    [XMShareTool weBo_LinkShareInfoWithLinkUrl:linkUrl title:title text:content];
    
}

-(void)js_shareCopyLink:(NSString *)link{
    UILog(@"--分享 复制 连接");
    [TYHUDTools showSuccess:@"已复制"];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:link];
}

// 有必要传 subTitle 吗?
-(void)js_shareCircleUrlLink:(NSDictionary  *)dic{
    
    NSString *link = dic[@"linkUrl"];
    if (link.length == 0 ) {
        link = @"";
    }
    
    NSString *title = dic[@"title"];
    if (title.length == 0) {
        title = @"";
    }
    NSString *content = dic[@"content"];
    if (content.length == 0) {
        content  = @"";
    }
    
    NSString *imageUrl = dic[@"imgUrl"];
    if (imageUrl.length == 0) { 
        imageUrl = @"";
    }
    
//    NSString *subTitle = parameters[@"owner"];
    
    [XMShareTool transmit2CircleFriendLinkUrl:link title:title content:content imageUrl:imageUrl fromVC:self];
}



// 手机银行打开外链
-(void)handleJs_openUrl:(NSString *)url{
    NSDictionary *info = @{@"type":@(XMClickJumpTypeOther),@"linkUrl": url, @"currentVC": self };
    [XMNotificationCenter postNotificationName:XMJumpToWebViewNotification object:nil userInfo:info];
}

-(void)handleJs_openLiveUrl:(NSDictionary *)dic{
    NSString *openType = dic[@"type"];
    if([openType isEqualToString:@"image"]){ // 图片跳转
        
        UILog(@"------- openLiveUrl ---- 打开的是 图片, 功能还未实现----");
        UILog(@"---openLiveUrlInfo: %@",dic);
    }
    else if ([openType isEqualToString:@"link"]){ // 直播 链接跳转
        
        NSDictionary *invitationCardInfo = dic[@"invitationCard"];
        NSDictionary *shareLinkInfo = dic[@"paramer"];
        NSString *videoSourceUrl = shareLinkInfo[@"link"];
        
        XMVideoSourceWebViewController *sourceWebVC = [[XMVideoSourceWebViewController alloc] init];
        sourceWebVC.invitationCardInfo = invitationCardInfo;
        sourceWebVC.shareInfo = shareLinkInfo;
        sourceWebVC.url = videoSourceUrl;  
        [self.navigationController pushViewController:sourceWebVC animated:YES];
    }
    
}

-(void)nativeOpenOuterLinkUrl:(NSDictionary *)dic{
    
    NSString *baseUrl = dic[@"baseUrl"];
    if(baseUrl.length == 0){
        baseUrl = @"";
    }
    NSString *imgUrl = dic[@"imgUrl"];
    if(imgUrl.length == 0){
        imgUrl = @"";
    }
    NSString *msgId = dic[@"msgId"];
    if(msgId.length == 0){
        msgId = @"";
    }
    NSString *publisherId = dic[@"publisherId"];
    if(publisherId.length == 0){
        publisherId = @"";
    }
    NSString *url = dic[@"url"];
    if(url.length == 0){
        url = @"";
    }
    if([url hasPrefix:@"nav://"]){// 避免出现native导航条
        url = [url substringFromIndex:6];
    }
    
    if (url.length == 0 || baseUrl.length == 0 || msgId.length == 0 || publisherId.length == 0) {
        return;
    }
    
    NSString *commentBaseUrl = self.webView.URL.absoluteString;
    
    XMOuterLinkArticleWebViewController *outerlinkArticleVC = [[XMOuterLinkArticleWebViewController alloc] init];
//    outerlinkArticleVC.injectionUserToken = YES;
    outerlinkArticleVC.url = url;
    outerlinkArticleVC.msgId = msgId;
    outerlinkArticleVC.publisherId = publisherId;
    outerlinkArticleVC.imgUrl = imgUrl.length > 0 ? imgUrl : @"";
    outerlinkArticleVC.baseUrl = baseUrl;
    outerlinkArticleVC.commentBaseUrl = commentBaseUrl;
    
    [self.navigationController pushViewController:outerlinkArticleVC animated:YES];
}

-(void)handleJs_nativeSDKReleaseDate{
    // 告诉H5现在的发版日期
    NSString  *jsStr = [NSString stringWithFormat:@"nativeSDKReleaseDateCallback(\"%@\")",iOS_Release_For_H5_date ];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}

-(void)handleJs_previewLiveQRCodePictures:(NSArray<NSString *> *)imageUrlArr{
    [self previewLiveQRCodePictures:imageUrlArr];
}

@end
