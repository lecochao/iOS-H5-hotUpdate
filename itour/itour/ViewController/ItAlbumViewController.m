//
//  ItAlbumViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItAlbumViewController.h"

@implementation ItAlbumViewController
-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self setNavigationBarTintColor:[UIColor redColor]];
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_add"] Action:^{
        NSLog(@"___back");
    }];
    [self setNavigationBarRightItem:[UIImage imageNamed:@"nav_go"] Action:^{
        NSLog(@"____right");
    }];
    [self loadingWebWithUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
}
@end
