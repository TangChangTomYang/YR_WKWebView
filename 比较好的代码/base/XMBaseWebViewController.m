//
//  XMBaseWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/12.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMBaseWebViewController.h"
#import "XMWeakWebViewScriptMessageDelegate.h"
#import "XMBaseWebViewController+handleJsMessage.h"
#import "XMPhotoBrowserController.h"

// 接收到的url 可能包含 @"nav://" 和 @"noNav://" 前缀, 防止加载网页失败, 我们要去除
// 如果接受到的url包含 nav://前缀, native 需求有使用原生的navBar 控制生命周期
#define kWebNavPrefix           @"nav://"
#define kWebnoNavPrefix         @"nonav://"
 

@interface XMBaseWebViewController ()
{
    /** webView 真实加载的URL */
    NSString *_webViewUrl;
}

@end

@implementation XMBaseWebViewController


#pragma mark- 供外部 调用方法
-(BOOL)isLogined{
    return [[XMLogonManager sharedXMLogonManager] isLogoned];
}

-(NSString *)tokenStr{
    NSString *token = [[ClientManager sharedClientManager] getSafetyToken];
    if (token == nil) {
        token = @"";
    }
    return token;
}

-(long long)fetchUserID{
  return  [UserManager sharedUserManager].userId;
}


-(NSString *)mobilePhoneStr{
    NSString *mobile =  [[ClientManager sharedClientManager] getMobileNo];
    if(mobile.length == 0){
        return @"";
    }
    
    if ([mobile hasPrefix:@"+86"]) {
        mobile = [mobile substringFromIndex:3];
    }
    return mobile;
}

-(NSInteger)bankUserType{
   return   [[ClientManager sharedClientManager] getBankUserType];
}

-(NSString *)encodeUrlStr:(NSString *)urlStr{
    return  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

-(void)previewLiveQRCodePictures:(NSArray<NSString *> *)imageUrlArr{
   
    if(imageUrlArr.count == 0){
        return;
    }
    
    XMPhotoBrowserController *photoBrower = [[XMPhotoBrowserController alloc] initWithImageArray:imageUrlArr andCurrentIndex:0];
    [photoBrower addLongPressGestureWithInfoButtonArray:@[NSInternational(@"general_forward"),
                                                           NSInternational(@"general_save_image"),
//                                                           NSInternational(@"general_favorite"),
                                                           NSInternational(@"general_indetification_qr_code")]];
    
    WEAKSELF
    photoBrower.finishBlock = ^(BOOL success, ChatModel *model) {
        if (success) {
            NSLog(@"---预览陈宫 完成---");
            // 下面的方法要不要 调用??
           // [weakSelf addTheMessagesArrayWithChatModel:model];
        }
    };
    [self.navigationController pushViewController:photoBrower animated:NO];
}

// 视频资源路径, ios 需要内嵌HTML 打开
-(BOOL)isVideoSourceUrl:(NSString *)url{
    
    NSString *suffix = [url pathExtension];
    if (suffix.length > 0) {
        suffix = [suffix lowercaseString];
    }
    
    if ([suffix isEqualToString:@"m3u8"]||
        [suffix isEqualToString:@"mp4"]||
        [suffix isEqualToString:@"avi"]||
        [suffix isEqualToString:@"mov"]||
        [suffix isEqualToString:@"rmvb"]||
        [suffix isEqualToString:@"flv"]) {
        return YES;
    }
    return NO;
}

-(BOOL)isMp4VideoSource:(NSString *)url{
    NSString *suffix = [url pathExtension];
    if (suffix.length) {
        suffix = [suffix lowercaseString];
    }
    // 兼容mp4
    if ([suffix isEqualToString:@"mp4"]) {
        return YES;
    }
    return NO;
}

-(NSString *)webViewUrl{
    return _webViewUrl;
}

-(XMNavgationBar *)navBar{
    if (!_navBar) {
        _navBar = [[XMNavgationBar alloc]initWithFrame:CGRectZero];
        _navBar.titleLabel.textColor = [UIColor ty_colorWithHex:@"434C67"];
        _navBar.titleLabel.font = [UIFont fontWithName:kMediumFont size:18];
        [_navBar XMInitLeftBtn:[UIImage imageNamed:@"Nav_Back"] addTarget:self action:@selector(webViewGoBack)];
    }
    return _navBar;
}

-(WKWebView *)webView{
    if (!_webView) {
         
        WKUserContentController *userContentCtr = [[WKUserContentController alloc] init];
        
        // 注入cookie
        if ([self needInjectionUserToken] && [self isLogined]) {
            
            
            NSString *cookieStr = [NSString stringWithFormat:@"document.cookie ='user-token=%@'",[self tokenStr]];
            WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookieStr
                                                                 injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                              forMainFrameOnly:NO];
            [userContentCtr addUserScript:cookieScript];
            
            UILog(@"--cls: %@-- 成功注入 token:\n %@", [self class],  cookieStr );
        }
        
        // 注入 UIWebView 兼容性脚本
        if([self needInjectionUIWebViewCompatibilityScript]){
            NSString *filePath = [IMKitBundle pathForResource:@"ios_brige" ofType:@"js"];
            NSString *scriptStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptStr
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];
            [userContentCtr addUserScript:script];
        }
        
        // 注入 禁用放大手势
        if([self forbitZoomGesture]){
            NSString *scriptStr = @"var script = document.createElement('meta');"
                                           "script.name = 'viewport';"
                                           "script.content=\"width=device-width, user-scalable=no\";"
                                           "document.getElementsByTagName('head')[0].appendChild(script);";
            WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptStr
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                       forMainFrameOnly:YES];
            [userContentCtr addUserScript:script];
        }
        
        
        // 注册 js call native 消息
        NSArray *jsCallNativeMsgNameArr = [self registJsCallNativeMessageNames];
        if (jsCallNativeMsgNameArr.count > 0) {
            
            XMWeakWebViewScriptMessageDelegate *wkScriptMsgDelegate = [[XMWeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
            
            for (NSString *msgName in jsCallNativeMsgNameArr) {
                UILog(@"--- 注册 js call native 方法: %@",msgName );
                [userContentCtr addScriptMessageHandler:wkScriptMsgDelegate name:msgName];
            }
        }
        
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentCtr;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = [self useWebViewPlayer];
        
        
        _webView = [[WKWebView alloc] initWithFrame:[self webViewFrame] configuration:config];
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        // 监听网页加载进度
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}

// 显示分享 弹窗
-(void)showShareMenuAlertWithTypeArr:(NSArray<NSNumber  *> *)shareTypeArr{
    XMCustomShareActionSheet *cusSheet = [[XMCustomShareActionSheet alloc] init];
    cusSheet.delegate = self;
    [cusSheet showInView:self.view shareTypeArr:shareTypeArr];
}



-(void)customActionSheetButtonClick:(XMShareActionButton *)btn{
    XMShareButtonType shareType = btn.type;
    
    NSString *currentTitle = btn.currentTitle;
    if (shareType == XMShareButtonType_circle) { // 圈友转发连接
        [self userDidClick_nativeShareCircleFriendMenu];
        return;
    }
    
    if (shareType == XMShareButtonType_weChatFriend) {
        [self userDidClick_nativeShareWeChatFriendMenu];
        return;
    }
    
    if (shareType == XMShareButtonType_weChatFriendCircle) {
        [self userDidClick_nativeShareWeChatFriendCircleMenu];
        return;
    }
    
    if (shareType == XMShareButtonType_weBo) {
        [self userDidClick_nativeShareWeBoMenu];
        return;
    }
    
    if (shareType == XMShareButtonType_Copy) {
        [self userDidClick_nativeShareCopyMenu];
    }
}


-(void)setUrl:(NSString *)url{
    _url = url;
    
    NSString *temUrl = url;
    if([[url lowercaseString] hasPrefix:kWebNavPrefix]){
        temUrl = [url substringFromIndex:kWebNavPrefix.length];
    }
    else if([[url lowercaseString] hasPrefix:kWebNavPrefix]){
        temUrl = [url substringFromIndex:kWebnoNavPrefix.length];
    }
    
    // 避免#号被encoder
    if ([temUrl containsString:@"#"]) {
        NSArray<NSString *> *urlParts = [temUrl componentsSeparatedByString:@"#"];
        if(urlParts && urlParts.count == 2){
            NSString *urlPart0 = [self encodeUrlStr:urlParts[0]];
            NSString *urlPart1 = [self encodeUrlStr:urlParts[1]];
            temUrl = [NSString stringWithFormat:@"%@#%@", urlPart0, urlPart1];
        }
    }
    else{
        temUrl = [self encodeUrlStr:temUrl];
    }
    
    _webViewUrl = temUrl;
}

-(void)setNavBarTitle:(NSString *)navBarTitle{
    _navBarTitle = navBarTitle;
    [self.navBar XMInitTitle:navBarTitle];
}

-(void)webViewGoBack{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- 生命周期
- (void)dealloc{
    [self.webView stopLoading];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webView = nil;
    [XMNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupUI];
    
    [self registNotice];
}





#pragma mark- 子类 按需重写下列方法

-(void)setupUI{
    
    [self setupNavBar];
    
    [self setupWebView];
}

-(void)setupNavBar{
    if([self needDisplayNativeNavBar]){
        CGRect navBarFrame = CGRectMake(0, 0, kScreenWidth, kNavBarH);
        self.navBar.frame = navBarFrame;
        [self.view addSubview:self.navBar];
    }
}

//(默认情况下是根据 url 中包含 nav:// 自动添加的)
-(BOOL)needDisplayNativeNavBar{
    return (self.url.length > 0 && [self.url hasPrefix:kWebNavPrefix] );
}



// 子类根据需求, 可以重写这个方法
-(void)setupWebView{
    [self.view addSubview:self.webView];
}

// 注册 JS 可以个 native 发送的消息名称, 这个方法代表了native 可以为web提供的能
-(NSMutableArray<NSString *> *)registJsCallNativeMessageNames{
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    [arrM addObject:@"doBack"];
    [arrM addObject:@"doShare"];
    [arrM addObject:@"doLogin"];
    
    [arrM addObject:@"nativeSDKReleaseDate"];
    [arrM addObject:@"nativeOpenOuterLinkUrl"];
    [arrM addObject:@"getCommnetData"];
    
    [arrM addObject:@"getUserData"];
    [arrM addObject:@"previewLiveQRCodePictures"];
    [arrM addObject:@"openUrl"];
    [arrM addObject:@"openLiveUrl"];
    
    
    
    return arrM;
}

-(BOOL)needInjectionUserToken{
    return NO;
}

// 旧版本 webView JS call native 兼容性脚本
-(BOOL)needInjectionUIWebViewCompatibilityScript{
    return YES;
}

// 禁用放大手势
-(BOOL)forbitZoomGesture{
    return YES;
}

// 画中画
-(BOOL)useWebViewPlayer{
    return YES;
}

-(CGRect)webViewFrame{
    CGFloat webViewY = kNavBarSafeTop;
    if(self.navBar.height > 0){
        webViewY = self.navBar.bottom;
    }
    CGFloat bottom = kSafeAreaBottom;
    CGFloat webViewHeight = kScreenHeight - bottom - webViewY;
    return  CGRectMake(0, webViewY, kScreenWidth, webViewHeight);
}

-(void)webViewLoad{
    NSURL *url = [NSURL  URLWithString:self.webViewUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([self needInjectionUserToken] && [self isLogined]) {
        NSString *token = [self tokenStr];
        [request addValue:token forHTTPHeaderField:@"user­-token"];
        [request setValue:[NSString stringWithFormat:@"user­-token=%@", token] forHTTPHeaderField:@"Cookie"];
    }
    [self.webView loadRequest:request];
    
}

-(void)setLoadingWebProgress:(float)loadingWebProgress{
    _loadingWebProgress = loadingWebProgress;
}

-(void)registNotice{
    // 登录状态改变
       [XMNotificationCenter addObserver:self selector:@selector(onLogonStatusChanged) name:NOTIFY_LOGON_STATUS_CHANGED object:nil];
}

#pragma mark- native 分享菜单 子类重写实现
-(void)userDidClick_nativeShareCircleFriendMenu{
    UILog(@"---web用户点击了 分享圈友 菜单");
}

-(void)userDidClick_nativeShareWeChatFriendMenu{
    UILog(@"---web用户点击了 分享微信 菜单");
}

-(void)userDidClick_nativeShareWeChatFriendCircleMenu{
    UILog(@"---web用户点击了 分享 朋友圈 菜单");
}

-(void)userDidClick_nativeShareWeBoMenu{
    UILog(@"---web用户点击了 分享微博 菜单");
}

-(void)userDidClick_nativeShareCopyMenu{
    UILog(@"---web用户点击了 分享 复制 菜单");
}


#pragma mark- Notification
- (void)onLogonStatusChanged {
    if ([self isLogined]) {
        __weak typeof(self) weakSelf = self;
        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
            NSString *token = [weakSelf tokenStr];
            long long userId = [self fetchUserID];;
            NSString *jsStr = [NSString stringWithFormat:@"getUserId(%lld, '%@')", userId, token];
            [weakSelf.webView evaluateJavaScript:jsStr completionHandler:nil];
        }];
    }
}

     
#pragma mark- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if(object == self.webView){
        if ([keyPath isEqualToString:@"title"] ){
            [self.navBar XMInitTitle:self.webView.title];
        }
        else  if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.loadingWebProgress = self.webView.estimatedProgress;
        }
        
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
   



#pragma mark- WKScriptMessageHandler 处理JS 调用 native 子类重写
// js call native
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *messageName = message.name;
    if ([messageName isEqualToString:@"doBack"]) {
        [self handleJs_doBack];
        return;
    }
    
    if ([messageName isEqualToString:@"doLogin"]) {
        [self handleJs_doLogin];
        return;
    }
    if ([messageName isEqualToString:@"getUserData"]) {
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *dic = (NSDictionary *)message.body;
            [self handleJs_getUserData:dic];
        }
        return;
    }
    
    if ([messageName isEqualToString:@"doShare"]) {
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *shareInfo = (NSDictionary *)message.body;
            [self handleJs_doShare:shareInfo];
        }
        return;
    }
    
    if ([messageName isEqualToString:@"openUrl"]) {
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *openUrlInfo = (NSDictionary *)message.body;
            NSString *url = openUrlInfo[@"url"];
            if(url.length >  0){
               [self handleJs_openUrl:url];
            }
        }
        return;
    }
    
    if ([messageName isEqualToString:@"nativeSDKReleaseDate"]) {
        [self handleJs_nativeSDKReleaseDate];
        return;
    }
    
    // 分享 及 跳转直播
    if ([messageName isEqualToString:@"openLiveUrl"]) {
        UILog(@"-----openLiveUrl  ----");
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *openLiveUrlInfo = (NSDictionary *)message.body;
            [self handleJs_openLiveUrl:openLiveUrlInfo];
        }
        return;
    }
    
    if ([messageName isEqualToString:@"nativeOpenOuterLinkUrl"]) {
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *info = (NSDictionary *)message.body;
            [self nativeOpenOuterLinkUrl:info];
        }
        return;
    }
    
    if ([messageName isEqualToString:@"previewLiveQRCodePictures"]) {
        if([message.body isKindOfClass:[NSDictionary  class]]){
            NSDictionary *infoDic = (NSDictionary *)message.body;
            NSString *imgUrl = infoDic[@"image"];
            if (imgUrl.length == 0) {
                return;
            }
            [self handleJs_previewLiveQRCodePictures:@[imgUrl]];
       }
        return;
         
    }
    
    
    
    if ([messageName isEqualToString:@"getCommnetData"]) {
        
        UILog(@"-----getCommnetData 还未实现 ----");  
        return;
         
    }
    
    
    
}







#pragma mark- WKUIDelegate 待子类根据需求实现 及 覆盖
// ...
                                    
      
#pragma mark- WKNavigationDelegate 待子类根据需求实现 及 覆盖
// 决定是否加载某个页面
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
