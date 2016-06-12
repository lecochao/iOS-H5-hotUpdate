//
//  ItTopChartsViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItTopChartsViewController.h"

@implementation ItTopChartsViewController
-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self webViewReload];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"排行榜"];
    [self setNavigationBarStyle:1];
}

-(void)webViewReload
{
     [self loadingHtmlWithName:@"sort.html"];
}


@end
