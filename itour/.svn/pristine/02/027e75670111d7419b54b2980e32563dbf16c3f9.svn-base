//
//  ItMoreViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMoreViewController.h"

@implementation ItMoreViewController
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
    [self loadingWebWithUrl:[NSURL URLWithString:@"http://jingyan.baidu.com/article/c33e3f4886d930ea15cbb5aa.html"]];
}
@end
