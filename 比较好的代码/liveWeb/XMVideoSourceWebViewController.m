//
//  XMVideoSourceWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/15.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMVideoSourceWebViewController.h"
#import "XMInvitationCardViewController.h"

@interface XMVideoSourceWebViewController ()

@property (nonatomic,strong)UIButton *invitationBtn;//邀请卡按钮

@end

@implementation XMVideoSourceWebViewController

-(CGRect)invitationBtnFrame{
    CGFloat btnX = kScreenWidth-66-10;
    CGFloat btnY = CGRectGetMaxY(self.navBar.frame)+45;
    CGFloat btnW = 66;
    CGFloat btnH = 22.5;
    return  CGRectMake(btnX, btnY, btnW, btnH);
}

- (UIButton *)invitationBtn{
    if (!_invitationBtn) {
        _invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _invitationBtn.frame = [self invitationBtnFrame];
        
        _invitationBtn.layer.cornerRadius = 11;
        [_invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _invitationBtn.titleLabel.font = [UIFont fontWithName:kMediumFont size:12];
        [_invitationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _invitationBtn.backgroundColor = [UIColor ty_colorWithHex:@"F8D03E"];
        [_invitationBtn setTitle:@"邀请卡" forState:UIControlStateNormal];
    }
    return _invitationBtn;
}

-(void)invitationBtnClick{
    UILog(@"-----邀请卡点 一点");
    [self  jump2InvitaionCardVC];
    
}

-(void)jump2InvitaionCardVC{
   
    XMInvitationCardViewController *invitationCardVC = [[XMInvitationCardViewController alloc] init];
    NSDictionary *invitationCardInfo ;
    invitationCardVC.invitationCardInfo= self.invitationCardInfo;
    [self.navigationController pushViewController:invitationCardVC animated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoad];
    self.webView.layer.borderColor = [UIColor redColor].CGColor;
    self.webView.layer.borderWidth =  1;
}

-(BOOL)needDisplayNativeNavBar{
    return YES;
}

// override
-(void)setupUI{
    [super setupUI];
    [self setupInvitationCardBtn];
}

// override
-(void)setupNavBar{
    [super setupNavBar];
    if (self.shareInfo) {
         [self.navBar XMInitRightBtn:[UIImage imageNamed:@"msg_center_more"] addTarget:self action:@selector(rightItemBtnClick)];
    }
}

-(void)rightItemBtnClick{ 
    NSMutableArray *shareTypeArr = [NSMutableArray array];
       [shareTypeArr addObject:@(XMShareButtonType_circle)];
       [shareTypeArr addObject:@(XMShareButtonType_weChatFriend)];
       [shareTypeArr addObject:@(XMShareButtonType_weChatFriendCircle)];
       [shareTypeArr addObject:@(XMShareButtonType_weBo)];
//       [shareTypeArr addObject:@(XMShareButtonType_Copy)];
       [self showShareMenuAlertWithTypeArr:shareTypeArr];
}


-(void)setupInvitationCardBtn{
    if (self.invitationCardInfo) {
        [self.view addSubview:self.invitationBtn];
    }
}

// override
-(void)webViewLoad{
     
    if ([self isVideoSourceUrl:self.url]) {
    //圈子直播视频页面由于是http会导致跨域的问题，需要客户端本地加载
    //为什么搞个html？因为需求不允许视频自动全屏播放，video标签需要加webkit-playsinline="true" playsinline="true"字段
    //http://live.cib.com.cn/plive/7002/playlist.m3u8
    NSString *filePath = [IMKitBundle pathForResource:@"video" ofType:@"html"];
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //替换直播视频url
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"src=\"\"" withString:[NSString stringWithFormat:@"src=\"%@\"",self.url]];

    if ([self isMp4VideoSource:self.url]) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"type=\"application/x-mpegURL\"" withString:@"type=\"video/mp4\""];
    }

    if (self.navBarTitle.length > 0) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"圈子直播间" withString:self.navBarTitle];
    }
    [self.webView loadHTMLString:htmlStr baseURL:nil];
        
    return;
        
    }
    
    [super webViewLoad];
    
}

 


#pragma mark- native 分享菜单 子类重写实现
// override
-(void)userDidClick_nativeShareCircleFriendMenu{
    UILog(@"---web用户点击了 分享圈友 菜单");
    NSString *videoUrl = self.shareInfo[@"link"];
    if (videoUrl.length == 0) {
        videoUrl = @"";
    }
    NSString *title = self.shareInfo[@"title"];
    if (title.length == 0) {
        title = @"";
    }
    NSString *content = self.shareInfo[@"content"];
    if (content.length == 0) {
        content = @"";
    }
    NSString *imageUrl = self.shareInfo[@"imageUrl"];
    if (imageUrl.length == 0) {
        imageUrl = @"";
    }

    [XMShareTool transmit2CircleFriendLinkUrl:videoUrl
                                               title:title
                                             content:content
                                     imageUrl:imageUrl fromVC:self];
}

// override
-(void)userDidClick_nativeShareWeChatFriendMenu{
     UILog(@"----native 打开 外链--- 微信分享--");
    NSString *videoUrl = self.shareInfo[@"link"];
    if (videoUrl.length == 0) {
        videoUrl = @"";
    }
    NSString *title = self.shareInfo[@"title"];
    if (title.length == 0) {
        title = @"";
    }
    NSString *content = self.shareInfo[@"content"];
    if (content.length == 0) {
        content = @"";
    }
    NSString *imageUrl = self.shareInfo[@"imageUrl"];
    if (imageUrl.length == 0) {
        imageUrl = @"";
    }
    NSDictionary *weChatShareDic = [XMShareTool weChatFriend_LinkShareInfoWithLinkUrl:videoUrl
                                                                                title:title
                                                                        thumbImageUrl:imageUrl
                                                                                 desc:content];

    [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
                                        object:nil
                                      userInfo:weChatShareDic];
}

// override
-(void)userDidClick_nativeShareWeChatFriendCircleMenu{
    
    UILog(@"----native 打开 外链--- 微信 朋友圈卷 分享--");
    NSString *videoUrl = self.shareInfo[@"link"];
    if (videoUrl.length == 0) {
       videoUrl = @"";
    }
    NSString *title = self.shareInfo[@"title"];
    if (title.length == 0) {
       title = @"";
    }
    NSString *content = self.shareInfo[@"content"];
    if (content.length == 0) {
       content = @"";
    }
    NSString *imageUrl = self.shareInfo[@"imageUrl"];
    if (imageUrl.length == 0) {
       imageUrl = @"";
    }

    NSDictionary *weChatCircleShareDic = [XMShareTool weChatFriendCircle_LinkShareInfoWithLinkUrl:videoUrl
                                                       title:title
                                               thumbImageUrl:imageUrl
                                                        desc:content];
    [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
                                        object:nil
                                      userInfo:weChatCircleShareDic];
    
}

// override
-(void)userDidClick_nativeShareWeBoMenu{
    
    UILog(@"----native 打开 外链--- 微博 分享--");
    NSString *videoUrl = self.shareInfo[@"link"];
    if (videoUrl.length == 0) {
       videoUrl = @"";
    }
    NSString *title = self.shareInfo[@"title"];
    if (title.length == 0) {
       title = @"";
    }
    NSString *content = self.shareInfo[@"content"];
    if (content.length == 0) {
       content = @"";
    }
//    NSString *imageUrl = self.shareInfo[@"imageUrl"];
//    if (imageUrl.length == 0) {
//       imageUrl = @"";
//    }
    NSDictionary *weBoShareDic = [XMShareTool weBo_LinkShareInfoWithLinkUrl:videoUrl
                                                title:title
                                                 text:content];
           [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
             object:nil
           userInfo:weBoShareDic];
}

// override
-(void)userDidClick_nativeShareCopyMenu{
    
   UILog(@"----native 打开 外链--- 微博 分享--");
    NSString *videoUrl = self.shareInfo[@"link"];
    if (videoUrl.length == 0) {
       videoUrl = @"";
    }
   [TYHUDTools showSuccess:@"已复制"];
   UIPasteboard *board = [UIPasteboard generalPasteboard];
   [board setString:videoUrl];
}



 

@end
