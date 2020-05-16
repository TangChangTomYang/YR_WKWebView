//
//  XMOuterLinkArticleBottomToolBar.h
//  IMKit
//
//  Created by yangrui on 2020/5/9.
//  Copyright © 2020 Darren. All rights reserved.
//

#import <UIKit/UIKit.h>



@class XMOuterLinkArticleBottomToolBar;

@protocol XMOuterLinkArticleBottomToolBarDelegate <NSObject>

-(void)toolBarDidClickPraiseBtn:(XMOuterLinkArticleBottomToolBar *)toolBar;
-(void)toolBarDidClickReadBtn:(XMOuterLinkArticleBottomToolBar *)toolBar;
-(void)toolBarDidClickCommentBtn:(XMOuterLinkArticleBottomToolBar *)toolBar;
-(void)toolBarDidClickCommentListBtn:(XMOuterLinkArticleBottomToolBar *)toolBar;
@end
 


@interface XMOuterLinkArticleBottomToolBar : UIView



@property (assign, nonatomic)  NSInteger praiseCount;
// 是否点赞
@property (assign, nonatomic)  NSInteger praiseStatus;

@property (assign, nonatomic)  NSInteger readCount;
// 是否阅读
@property (assign, nonatomic)  NSInteger readStatus;

// 评论数
@property (assign, nonatomic)  NSInteger commentCount;
 

@property(nonatomic, weak)id<XMOuterLinkArticleBottomToolBarDelegate> delegate;

+(instancetype)toolBarWithFrame:(CGRect)frame;
@end
 
