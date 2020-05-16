//
//  XMOuterLinkArticleWebViewController.h
//  IMKit
//
//  Created by yangrui on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkBaseWebViewController.h"
#import "XMOuterLinkArticleBottomToolBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface XMOuterLinkArticleWebViewController : XMOuterLinkBaseWebViewController


/**文章ID*/
@property(nonatomic, strong)NSString *msgId;
/**文章ID*/
@property(nonatomic, strong)NSString *publisherId;
/** http 请求的ip + port*/
@property(nonatomic, strong)NSString *baseUrl;
 /**评论baseURL(文章列表地址)*/
@property(nonatomic, strong)NSString *commentBaseUrl;



/**分享图片的url*/
@property(nonatomic, strong)NSString *imgUrl;

// 分享时的content
@property(nonatomic, strong)NSString *shareContent;


@property(nonatomic, strong)XMOuterLinkArticleBottomToolBar *toolBar;
@end

NS_ASSUME_NONNULL_END
