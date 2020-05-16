//
//  XMOuterLinkArticleWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkArticleWebViewController.h"
#import "XMOuterLinkArticleCommentWebViewController.h"
#import "XMOuterLinkWebViewHttpTool.h"
#import "XMShareTool.h"

@interface XMOuterLinkArticleWebViewController ()
<XMOuterLinkArticleBottomToolBarDelegate>


@property(nonatomic, assign)BOOL isRead;
@end

@implementation XMOuterLinkArticleWebViewController


-(CGRect)toolBarFrame{
    CGFloat height = 55 + kSafeAreaBottom;
    CGFloat y = kScreenHeight - height;
    CGRect frame = CGRectMake(0, y, kScreenWidth, height);
    return frame;
}

-(CGRect)webViewFrame{
    CGFloat webViewY = kNavBarSafeTop;
    if(self.navBar.height > 0){
        webViewY = self.navBar.bottom;
    }
    CGFloat bottom = CGRectGetHeight([self toolBarFrame]);
    
    CGFloat webViewHeight = kScreenHeight - bottom - webViewY;
    return  CGRectMake(0, webViewY, kScreenWidth, webViewHeight);
}

-(XMOuterLinkArticleBottomToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [XMOuterLinkArticleBottomToolBar toolBarWithFrame:[self toolBarFrame]];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoad];
    self.webView.layer.borderColor = [UIColor redColor].CGColor;
    self.webView.layer.borderWidth = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // toolBar xib
    self.toolBar.frame = [self toolBarFrame];
    [self updateToolBarDisplay];
}



#pragma mark- 子类 按需重写下列方法
// override
-(void)setupUI{
    [super setupUI];
    [self setupBottomToolBar];
}

// override
-(BOOL)needDisplayNativeNavBar{
    return YES;
}

// override
-(void)setupNavBar{
    [super setupNavBar];
    [self.navBar XMInitRightBtn:[UIImage imageNamed:[XMCircleHomeTheme getOuterLinkArticle_ShareIcon]] addTarget:self action:@selector(rightItemBtnClick)];
}

-(void)setupBottomToolBar{
    [self.view addSubview:self.toolBar];
}

-(void)rightItemBtnClick{
//    if (self.loadingWebProgress >= 0.9) {
//    }
    
    NSMutableArray *shareTypeArr = [NSMutableArray array];
    [shareTypeArr addObject:@(XMShareButtonType_circle)];
    [shareTypeArr addObject:@(XMShareButtonType_weChatFriend)];
    [shareTypeArr addObject:@(XMShareButtonType_weChatFriendCircle)];
    [shareTypeArr addObject:@(XMShareButtonType_weBo)];
    [shareTypeArr addObject:@(XMShareButtonType_Copy)]; 
    [self showShareMenuAlertWithTypeArr:shareTypeArr];
}


#pragma mark- native 分享菜单 子类重写实现
// override
-(void)userDidClick_nativeShareCircleFriendMenu{
    NSString *articleUrl = self.webViewUrl;
    NSString *title = self.navBar.titleLabel.text;
    if (title.length == 0) {
        title = @"";
    }
    NSString *content = self.shareContent;
    if (content.length == 0) {
        content = @"";
    }
    
    
    NSString *imageUrl = self.imgUrl;
    if (imageUrl.length == 0) {
        imageUrl = @"";
    }
    
    [XMShareTool transmit2CircleFriendLinkUrl:articleUrl
                                               title:title
                                             content:content
                                     imageUrl:imageUrl fromVC:self];
    UILog(@"----native 打开 外链--- 圈子分享--");
}

// override
-(void)userDidClick_nativeShareWeChatFriendMenu{
    
    NSString *articleUrl = self.webViewUrl;
    
    NSString *title = self.navBar.titleLabel.text;
    if (title.length == 0) {
        title = @"";
    }
    NSString *content = self.shareContent;
    if (content.length == 0) {
        content = @"";
    }
    
    
    NSString *imageUrl = self.imgUrl;
    if (imageUrl.length == 0) {
        imageUrl = @"";
    }
    NSDictionary *weChatShareDic = [XMShareTool weChatFriend_LinkShareInfoWithLinkUrl:articleUrl
                                                                                title:title
                                                                        thumbImageUrl:imageUrl
                                                                                 desc:content];
    
    [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
                                        object:nil
                                      userInfo:weChatShareDic];
}

// override
-(void)userDidClick_nativeShareWeChatFriendCircleMenu{
    
    NSString *articleUrl = self.webViewUrl;
       
       NSString *title = self.navBar.titleLabel.text;
       if (title.length == 0) {
           title = @"";
       }
       NSString *content = self.shareContent;
       if (content.length == 0) {
           content = @"";
       }
       
       
       NSString *imageUrl = self.imgUrl;
       if (imageUrl.length == 0) {
           imageUrl = @"";
       }
    
    NSDictionary *weChatCircleShareDic = [XMShareTool weChatFriendCircle_LinkShareInfoWithLinkUrl:articleUrl
                                                       title:title
                                               thumbImageUrl:imageUrl
                                                        desc:content];
    [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
                                        object:nil
                                      userInfo:weChatCircleShareDic];
    
}

// override
-(void)userDidClick_nativeShareWeBoMenu{
    NSString *articleUrl = self.webViewUrl;
         
     NSString *title = self.navBar.titleLabel.text;
     if (title.length == 0) {
         title = @"";
     }
     NSString *content = self.shareContent;
     if (content.length == 0) {
         content = @"";
     }
     
    NSDictionary *weBoShareDic = [XMShareTool weBo_LinkShareInfoWithLinkUrl:articleUrl
                                                title:title
                                                 text:content];
           [XMNotificationCenter postNotificationName:XMCallExternalShareNotificaion
             object:nil
           userInfo:weBoShareDic];
}

// override
-(void)userDidClick_nativeShareCopyMenu{
   [TYHUDTools showSuccess:@"已复制"];
   UIPasteboard *board = [UIPasteboard generalPasteboard];
   [board setString:self.webViewUrl];
}

 

#pragma mark- XMOuterLinkArticleBottomToolBarDelegate 工具条代理
-(void)toolBarDidClickPraiseBtn:(XMOuterLinkArticleBottomToolBar *)toolBar{
   
    if (toolBar.praiseStatus > 0) {
        [self canclePraise_Article];
    }
    else{
        [self praise_Article];
    }
}

-(void)toolBarDidClickReadBtn:(XMOuterLinkArticleBottomToolBar *)toolBar{
    
    [self read_Article];
}

-(void)toolBarDidClickCommentBtn:(XMOuterLinkArticleBottomToolBar *)toolBar{

    XMOuterLinkArticleCommentWebViewController *articleCommentVC = [[XMOuterLinkArticleCommentWebViewController alloc] init];
    articleCommentVC.injectionUserToken = YES;
    articleCommentVC.url = [NSString stringWithFormat:@"%@postComment?publisherId=%@&msgId=%@&outerLinkComment=true",
                            self.commentBaseUrl,
                            self.publisherId,
                            self.msgId];
    
    [self.navigationController pushViewController:articleCommentVC animated:YES];
    
}

-(void)toolBarDidClickCommentListBtn:(XMOuterLinkArticleBottomToolBar *)toolBar{
    
    XMOuterLinkArticleCommentWebViewController *articleCommentVC = [[XMOuterLinkArticleCommentWebViewController alloc]init];
    articleCommentVC.injectionUserToken = YES;
    articleCommentVC.url = [NSString stringWithFormat:@"%@commentlistPage?publisherId=%@&msgId=%@&outerLinkComment=true",
                     self.commentBaseUrl,
                     self.publisherId,
                     self.msgId];
    [self.navigationController pushViewController:articleCommentVC animated:YES];
}




#pragma mark- http

-(void)praise_Article{
    
    [self praise_Or_canclePraise_Or_readArticle:2];
}

-(void)canclePraise_Article{
    [self praise_Or_canclePraise_Or_readArticle:3];
}

-(void)read_Article{
        [self praise_Or_canclePraise_Or_readArticle:1];
}
// 010831
// 点赞 或 阅读
// praise_Or_read = 1 阅读
// praise_Or_read = 2 点赞
// praise_Or_read = 3 取消点赞

-(void)praise_Or_canclePraise_Or_readArticle:(int)praise_Or_canclePraise_read{
    
    long long userID = [self fetchUserID];
    NSDictionary *paramDic = @{
                                @"msgId":self.msgId,
                                @"type":@(praise_Or_canclePraise_read),
                                @"userId":@(userID).stringValue,
                            };
    NSString *articleMsgDetailPath = @"/circle/publisher/message/setMsgReadOrPraise";
    NSString *articleMsgDetailUrlStr = [NSString stringWithFormat:@"%@%@",self.baseUrl, articleMsgDetailPath];
    
    // 查询
    __weak typeof(self) weakSelf = self;
    [XMOuterLinkWebViewHttpTool postWithUrl:articleMsgDetailUrlStr param:paramDic callBack:^(BOOL success, NSDictionary *rst, NSString *error) {
       
        if(success){
            
            if (praise_Or_canclePraise_read == 1) { // 阅读
                NSInteger  readCount = [rst[@"count"] integerValue];
                NSInteger  readStatus = [rst[@"status"] integerValue];
                  
                weakSelf.toolBar.readCount = readCount;
                weakSelf.toolBar.readStatus = readStatus ;
            }
            else if (praise_Or_canclePraise_read == 2){ // 点赞
                weakSelf.toolBar.praiseCount += 1;
                weakSelf.toolBar.praiseStatus = 1;
            }
            else if (praise_Or_canclePraise_read == 3){ // 取消点赞
                weakSelf.toolBar.praiseCount -= 1;
                weakSelf.toolBar.praiseStatus = 0;
            }
        }
        
    }];
}

// 更新底部工具条显示 信息
-(void)updateToolBarDisplay{
    long long userID = [[ClientManager sharedClientManager] getUserId];
    NSDictionary *paramDic = @{
                                @"msgId":self.msgId,
                                @"userId":@(userID).stringValue,
                                @"publisherId":self.publisherId
                            };
    NSString *articleMsgDetailPath = @"/circle/publisher/message/details";
    NSString *articleMsgDetailUrlStr = [NSString stringWithFormat:@"%@%@",self.baseUrl, articleMsgDetailPath];
    
    // 查询
    __weak typeof(self) weakSelf = self;
    [XMOuterLinkWebViewHttpTool postWithUrl:articleMsgDetailUrlStr param:paramDic callBack:^(BOOL success, NSDictionary *rst, NSString *error) {
       
         
        if(success){
            [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
                NSInteger  commentCount = [rst[@"commentCount"] integerValue];
                
                NSInteger  praiseCount = [rst[@"praiseCount"] integerValue];
                NSInteger  praiseStatus = [rst[@"praiseStatus"] integerValue];
                
                NSInteger  readCount = [rst[@"readCount"] integerValue];
                NSInteger  readStatus = [rst[@"readStatus"] integerValue];
                
                weakSelf.shareContent = rst[@"summary"];
                 
                 
                weakSelf.toolBar.praiseCount = praiseCount;
                weakSelf.toolBar.praiseStatus = praiseStatus;
                weakSelf.toolBar.readCount = readCount;
                weakSelf.toolBar.readStatus = readStatus ;
                weakSelf.toolBar.commentCount = commentCount;
                
                if (weakSelf.isRead == NO) {
                   [weakSelf read_Article];
                    weakSelf.isRead = YES;
                }
            }];
        }
        
    }];
}
@end
