//
//  XMOuterLinkWebViewHttpTool.m
//  IMKit
//
//  Created by yangrui on 2020/5/9.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMOuterLinkWebViewHttpTool.h"
#import "GlobalConfig.h"


@implementation XMOuterLinkWebViewHttpTool

+(void)postWithUrl:(NSString *)urlStr
                     param:(NSDictionary *)param
                  callBack:(void(^)(BOOL success, NSDictionary *rst, NSString *error))callback{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil delegateQueue:[[NSOperationQueue alloc] init]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                              NSURLResponse *response,
                                                                                              NSError *error) {
        // 失败
        if (error) {
            [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
                callback(NO, nil, @"请求失败");
            }];
            return;
        }
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSInteger code = [responseDic[@"code"] integerValue];
        
        
        // 失败
        if (code != kXMCircleHomeHttpSuccessCode) {// 200
            [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
                callback(NO, nil, responseDic[@"error"]);
            }];
            return;
        }
        
        // 成功
        NSDictionary *dataDic = responseDic[@"data"];
        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
            callback(YES, dataDic, nil);
        }];
    }];
    [dataTask resume];
    
}
@end
