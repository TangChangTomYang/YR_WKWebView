//
//  XMOuterLinkWebViewHttpTool.h
//  IMKit
//
//  Created by yangrui on 2020/5/9.
//  Copyright © 2020 Darren. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XMOuterLinkWebViewHttpTool : NSObject


+(void)postWithUrl:(NSString *)urlStr
             param:(NSDictionary *)param
          callBack:(void(^)(BOOL success, NSDictionary *rst, NSString *error))callback;


@end
 
