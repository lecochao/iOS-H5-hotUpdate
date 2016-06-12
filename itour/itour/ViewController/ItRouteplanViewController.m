//
//  ItRouteplanViewController.m
//  itour
//
//  Created by Chaos on 16/5/31.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItRouteplanViewController.h"
@implementation ItRouteplanViewController

-(void)viewDidLoad
{
    [self setView];
    
    
    WEAKSELF
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_back_b"] Action:^{
        if ([weakSelf.webView canGoBack]) {
            [weakSelf.webView goBack];
        }else
            [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self webViewReload];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarStyle:0];
    [self.navigationItem setTitle:@"路径规划"];
}

-(void)webViewReload
{
    [self loadingHtmlWithName:@"routePlan.html"];
}

@end
