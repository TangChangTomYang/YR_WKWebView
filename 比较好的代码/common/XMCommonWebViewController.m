//
//  XMCommonWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMCommonWebViewController.h"
#import "XMShareTool.h"

@interface XMCommonWebViewController ()

@end

@implementation XMCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoad];
     
}




#pragma mark- 子类 重写
// 子类根据需求, 可以重写这个方法
-(BOOL)needInjectionUserToken{
    return self.isInjectionUserToken;
}


// override
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
        /**< 分享到会话中的理财团或兴球说文章，在会话中点开，再分享时需要图片链接 */
        if (self.shareImageUrl.length >  0) {
            imageUrl = self.shareImageUrl;
        }
        else{
          imageUrl = @"";
        }
        
    }
    
//    NSString *subTitle = parameters[@"owner"];
    
    [XMShareTool transmit2CircleFriendLinkUrl:link title:title content:content imageUrl:imageUrl fromVC:self];
}

@end
