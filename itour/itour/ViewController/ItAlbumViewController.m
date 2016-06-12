//
//  ItAlbumViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItAlbumViewController.h"
#import "ItCommonViewController.h"
@implementation ItAlbumViewController
-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self webViewReload];
    [self setHeaderWithRefresh:YES];
//    self.webView.scalesPageToFit= NO;
    WEAKSELF
    UIButton *right = [UIButton new];
    right.frame = CGRectMake(0, 0, 50, 35);
    [right.titleLabel setFont:APPTextFont(14)];
    right.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [right setTitle:@"影展" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"nav_photo_right"] forState:UIControlStateNormal];
    [self setNavigationBarRightItem:right Action:^{
        ItCommonViewController *photoDet = [[ItCommonViewController alloc]init];
//        photoDet.webView.scalesPageToFit= NO;
        photoDet.txtTitle = @"影展";
        photoDet.style = 1;
        photoDet.url = @"photoWall.html?show=1";
        [weakSelf.navigationController pushViewController:photoDet animated:YES];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"照片墙"];
    [self setNavigationBarStyle:1];
}

-(void)webViewReload
{
    [self loadingHtmlWithName:@"photoWall.html"];
}
@end
