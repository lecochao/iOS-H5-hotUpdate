//
//  ItMoreViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMoreViewController.h"
#import "ItPostInfoViewController.h"
@implementation ItMoreViewController
-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self webViewReload];
    WEAKSELF
    UIButton *right = [UIButton new];
    right.frame = CGRectMake(0, 0, 50, 35);
    [right.titleLabel setFont:APPTextFont(14)];
    right.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [right setTitle:@"反馈" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"nav_more_right"] forState:UIControlStateNormal];
    [self setNavigationBarRightItem:right Action:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItPostImgStoryboard" bundle:nil];
        ItPostInfoViewController *postInfoController = [storyboard instantiateViewControllerWithIdentifier:@"PostInfoViewControllerIdentifier"];
        postInfoController.type = @"feedback";
        postInfoController.navigationItem.title = @"反馈信息";
        [weakSelf.navigationController pushViewController:postInfoController animated:YES];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"更多"];
    [self setNavigationBarStyle:1];
}

-(void)webViewReload
{
    [self loadingHtmlWithName:@"more.html"];
}

@end
