//
//  XMOuterLinkArticleBottomToolBar.m
//  IMKit
//
//  Created by yangrui on 2020/5/9.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkArticleBottomToolBar.h"
#import "GlobalConfig.h"
#import "XMOuterLinkArticleStyleTool.h"



@interface XMOuterLinkArticleBottomToolBar ()

 

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentListBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
 


@implementation XMOuterLinkArticleBottomToolBar

+(instancetype)toolBarWithFrame:(CGRect)frame{
    UINib * nib = [UINib nibWithNibName:@"XMOuterLinkArticleBottomToolBar" bundle:IMKitBundle];
    XMOuterLinkArticleBottomToolBar *toolBar = [[nib instantiateWithOwner:self options:nil] lastObject];
    return toolBar;
}

-(void)setupCommentBtn{
    UIButton *btn = self.commentBtn;
    btn.layer.cornerRadius = 17.5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [XMOuterLinkArticleStyleTool commentBtnBorderColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.backgroundColor = [XMOuterLinkArticleStyleTool  commentBtnBgColor];
    [btn setTitleColor:[XMOuterLinkArticleStyleTool btnTextColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: [XMCircleHomeTheme getOuterLinkArticle_CommnetIcon] ] forState:UIControlStateNormal];
    btn.titleLabel.font = [XMOuterLinkArticleStyleTool commentBtnFont];
    
}


-(void)setupCommentListBtn{
    UIButton *btn = self.commentListBtn;
    [btn setTitleColor:[XMOuterLinkArticleStyleTool btnTextColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: [XMCircleHomeTheme getOuterLinkArticle_CommnetListIcon] ] forState:UIControlStateNormal];
    btn.titleLabel.font = [XMOuterLinkArticleStyleTool commentList_read_PraiseBtnFont];
}


-(void)setupPraiseBtn{
    UIButton *btn = self.praiseBtn;
    [btn setTitleColor:[XMOuterLinkArticleStyleTool btnTextColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: [XMCircleHomeTheme getOuterLinkArticle_Praise_normalIcon] ] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: [XMCircleHomeTheme getOuterLinkArticle_Praise_selectedIcon] ] forState:UIControlStateSelected];
    btn.titleLabel.font = [XMOuterLinkArticleStyleTool commentList_read_PraiseBtnFont];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupCommentBtn];
    
    [self setupCommentListBtn];
    
    [self.readBtn setTitleColor:[XMOuterLinkArticleStyleTool btnTextColor] forState:UIControlStateNormal];
    self.readBtn.titleLabel.font = [XMOuterLinkArticleStyleTool commentList_read_PraiseBtnFont];
    self.readBtn.userInteractionEnabled = NO;
    
    [self setupPraiseBtn];
}




-(void)setPraiseCount:(NSInteger)praiseCount{
    _praiseCount = praiseCount;
     [self.praiseBtn setTitle:@(praiseCount).stringValue forState:UIControlStateNormal];
}

-(void)setPraiseStatus:(NSInteger)praiseStatus{
    _praiseStatus = praiseStatus;
    self.praiseBtn.selected = (praiseStatus > 0);
//    self.praiseBtn.userInteractionEnabled = (praiseStatus == 0);
}


-(void)setReadCount:(NSInteger)readCount{
    _readCount = readCount;
    [self.readBtn setTitle:[NSString stringWithFormat:@"阅读 %d", readCount] forState:UIControlStateNormal];
}

-(void)setReadStatus:(NSInteger)readStatus{
    _readStatus = readStatus;
//    self.readBtn.userInteractionEnabled = (readStatus == 0);
}

 
-(void)setCommentCount:(NSInteger)commentCount{
    _commentCount = commentCount; 
    [self.commentListBtn setTitle:@(commentCount).stringValue forState:UIControlStateNormal];
}



#pragma mark- BtnClick
- (IBAction)commentBtnClick:(id)sender {
    [self.delegate toolBarDidClickCommentBtn:self];
}
- (IBAction)commentListBtnClick:(id)sender {
    [self.delegate toolBarDidClickCommentListBtn:self];
}
- (IBAction)praiseBtnClick:(id)sender {
    [self.delegate toolBarDidClickPraiseBtn:self];
}
- (IBAction)readBtnClick:(id)sender {
    [self.delegate toolBarDidClickReadBtn:self];
}




/** 只是图标不一样 
 普板
 share@2x
 comment@2x (背景 FBFBFB, 边框 E5E5E5, 字体 9199BD, 大小 14)
 commentList@2x (字体 9199BD, 大小 12)
 zan@2x  zanSelected@2x (字体 9199BD, 大小 12)
 
 
 vip
 
 share_zhuanshu_siren@2x
 comment_zhuanshu_siren@2x  一样
 commentList_zhuanshu_siren@2x
 
 zan_zhuanshu_siren@2x zanSelected_zhuanshu_siren@2x
 
 */


@end
