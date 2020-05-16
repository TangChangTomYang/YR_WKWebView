//
//  XMOuterLinkBaseWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/15.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkBaseWebViewController.h"

@interface XMOuterLinkBaseWebViewController ()

@end

@implementation XMOuterLinkBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark- 子类 按需重写下列方法

// 子类根据需求, 可以重写这个方法
-(BOOL)needInjectionUserToken{
    return self.isInjectionUserToken;
}


@end
