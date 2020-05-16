//
//  XMLiveListWebViewController.m
//  IMKit
//
//  Created by yangrui on 2020/5/15.
//  Copyright © 2020 Darren. All rights reserved.
//

#import "XMLiveListWebViewController.h"

@interface XMLiveListWebViewController ()


@end

@implementation XMLiveListWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoad];
}

-(BOOL)needDisplayNativeNavBar{
    return YES;
}



@end
