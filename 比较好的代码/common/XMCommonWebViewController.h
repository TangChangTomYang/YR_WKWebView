//
//  XMCommonWebViewController.h
//  IMKit
//
//  Created by yangrui on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMCommonWebViewController : XMBaseWebViewController
// 注入token
@property(nonatomic, assign, getter=isInjectionUserToken)BOOL injectionUserToken;


/**< 分享到会话中的理财团或兴球说文章，在会话中点开，再分享时需要图片链接 */
@property (nonatomic, copy) NSString *shareImageUrl; // 这个属性 有时候需要传递
@end



NS_ASSUME_NONNULL_END
