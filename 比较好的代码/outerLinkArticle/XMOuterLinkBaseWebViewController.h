//
//  XMOuterLinkBaseWebViewController.h
//  IMKit
//
//  Created by yangrui on 2020/5/15.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMBaseWebViewController.h"


@interface XMOuterLinkBaseWebViewController : XMBaseWebViewController

// 注入token
@property(nonatomic, assign, getter=isInjectionUserToken)BOOL injectionUserToken;
@end
 
