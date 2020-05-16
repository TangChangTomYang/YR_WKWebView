//
//  XMOuterLinkArticleStyleTool.m
//  IMKit
//
//  Created by yangrui on 2020/5/9.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkArticleStyleTool.h"
#import "GlobalConfig.h"



@implementation XMOuterLinkArticleStyleTool


#pragma mark- style
+(UIColor *)commentBtnBgColor{
    return  [UIColor ty_colorWithHex:@"FBFBFB"];
}

+(UIColor *)commentBtnBorderColor{
    return  [UIColor ty_colorWithHex:@"E5E5E5"];
}

+(UIColor *)btnTextColor{
    return  [UIColor ty_colorWithHex:@"9199BD"];
}

+(UIFont *)commentBtnFont{
    return  [UIFont systemFontOfSize:14];
}

+(UIFont *)commentList_read_PraiseBtnFont{
    return  [UIFont systemFontOfSize:12];
}

@end
