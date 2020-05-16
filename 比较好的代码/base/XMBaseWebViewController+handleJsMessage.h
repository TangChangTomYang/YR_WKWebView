//
//  XMBaseWebViewController+handleJsMessage.h
//  IMKit
//
//  Created by yangrui on 2020/5/14.
//  Copyright © 2020 Darren. All rights reserved.
//
 


#import "XMBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMBaseWebViewController (handleJsMessage)

-(void)handleJs_doBack;

-(void)handleJs_doLogin;

-(void)handleJs_getUserData:(NSDictionary *)dic;

-(void)handleJs_doShare:(NSDictionary *)shareInfo;

-(void)Js_shareWeChatLink:(NSDictionary *)dic;
-(void)Js_shareWeChatCircleLink:(NSDictionary *)dic;
-(void)Js_shareWeboLink:(NSDictionary *)dic;
-(void)Js_shareCopyLink:(NSString *)link;
// 有必要传 subTitle 吗?
// 圈子 图片分享还没做 
-(void)js_shareCircleUrlLink:(NSDictionary  *)dic;

// 手机银行打开外链
-(void)handleJs_openUrl:(NSString *)url;

-(void)handleJs_openLiveUrl:(NSDictionary *)dic;

-(void)nativeOpenOuterLinkUrl:(NSDictionary *)dic;

-(void)handleJs_nativeSDKReleaseDate;

-(void)handleJs_previewLiveQRCodePictures:(NSArray<NSString *> *)imageUrlArr;
@end

NS_ASSUME_NONNULL_END
