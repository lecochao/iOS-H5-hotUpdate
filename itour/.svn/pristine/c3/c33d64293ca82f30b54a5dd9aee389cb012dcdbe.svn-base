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
    [self setNavigationBarTintColor:[UIColor redColor]];
    [self setNavigationBarLeftItem:@"back" Action:^{
        NSLog(@"___back");
    }];
    [self setNavigationBarRightItem:@"right" Action:^{
        NSLog(@"____right");
    }];
    [self loadingWebWithUrl:[NSURL URLWithString:@"http://blog.sina.com.cn/s/blog_9693f61a010199te.html"]];
}
@end
