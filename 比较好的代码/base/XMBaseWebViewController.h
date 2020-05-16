//
//  XMBaseWebViewController.h
//  IMKit
//
//  Created by yangrui on 2020/5/12.
//  Copyright © 2020 Darren. All rights reserved.
//

/** 注意, 在后续使用 webViewController 时, 不要直接使用父类, 尽量子类化

 */





#import <UIKit/UIKit.h>
#import "GlobalConfig.h"
#import <WebKit/WebKit.h>
#import "XMNavgationBar.h"
#import "IMKitInterface.h"
#import "XMCustomShareActionSheet.h"
#import "XMShareTool.h"

@interface XMBaseWebViewController : UIViewController
<WKScriptMessageHandler,
WKUIDelegate,
WKNavigationDelegate,
XMCustomShareActionDelegate
>
/**
 1. 创建 XMBaseWebViewController 实例时, 第一个必须传递的参数
 2. 当 url 包含nav://前缀时  XMBaseWebViewController 会自动添加native 的navBar 用户控制web页面的 前进后退控制
 3. 当 url 不包含nav://前缀时, XMBaseWebViewController 不会添加native 的navBar. 页面的前进后退由H5 调用原生的doBack 方法来控制
 */
@property(nonatomic, strong)NSString *url;

@property(nonatomic, strong)WKWebView *webView;

@property(nonatomic, strong)XMNavgationBar *navBar; // 需要优化

/**网页的标题, 如果需要 替换网页的标题就传入*/
@property(nonatomic, strong)NSString *navBarTitle;

/** webView 真实加载的URL, 经过url编码和取出 nav:// 后的url*/
@property(nonatomic, strong, readonly)NSString *webViewUrl;
// 网页加载的进度
@property(nonatomic, assign)float loadingWebProgress;

#pragma mark- 供外部 调用方法
-(BOOL)isLogined;

-(NSString *)tokenStr;

-(long long)fetchUserID;

-(NSString *)mobilePhoneStr;

-(NSInteger)bankUserType;

-(NSString *)encodeUrlStr:(NSString *)urlStr;

-(void)previewLiveQRCodePictures:(NSArray<NSString *> *)imageUrlArr;

// 视频资源路径, ios 需要内嵌HTML 打开
-(BOOL)isVideoSourceUrl:(NSString *)url;
-(BOOL)isMp4VideoSource:(NSString *)url;

-(NSString *)webViewUrl;
 
-(void)webViewGoBack;


// 显示分享 弹窗
-(void)showShareMenuAlertWithTypeArr:(NSArray<NSNumber *> *)shareTypeArr;

#pragma mark- 子类 按需重写下列方法

-(void)setupUI;

-(void)setupNavBar;

//(默认情况下是根据 url 中包含 nav:// 自动添加的)
-(BOOL)needDisplayNativeNavBar;

// 子类根据需求, 可以重写这个方法
-(void)setupWebView;

// 注册 JS 可以个 native 发送的消息名称, 这个方法代表了native 可以为web提供的能
-(NSMutableArray<NSString *> *)registJsCallNativeMessageNames;

-(BOOL)needInjectionUserToken;

// 旧版本 webView JS call native 兼容性脚本
-(BOOL)needInjectionUIWebViewCompatibilityScript;

// 禁用放大手势
-(BOOL)forbitZoomGesture;

// 画中画
-(BOOL)useWebViewPlayer;

-(CGRect)webViewFrame;

-(void)webViewLoad;

-(void)registNotice;


#pragma mark- native 分享菜单 子类重写实现
-(void)userDidClick_nativeShareCircleFriendMenu;

-(void)userDidClick_nativeShareWeChatFriendMenu;

-(void)userDidClick_nativeShareWeChatFriendCircleMenu;

-(void)userDidClick_nativeShareWeBoMenu;

-(void)userDidClick_nativeShareCopyMenu;



#pragma mark- WKScriptMessageHandler 处理JS 调用 native 子类重写
// js call native
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;


@end
 
