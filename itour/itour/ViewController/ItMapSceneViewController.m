//
//  ItMapSceneViewController.m
//  itour
//
//  Created by Chaos on 16/6/7.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMapSceneViewController.h"

@implementation ItMapSceneViewController

-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self webViewReload];
    [self setavAudio];
    WEAKSELF
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_back_w"] Action:^{
        [weakSelf.avAudioPlayer stop];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.webView.scalesPageToFit = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"西安古城墙"];
    [self setNavigationBarStyle:1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avAudioPlayer stop];
}
-(void)webViewReload
{
    [self loadingHtmlWithName:@"indexNext.html"];
}

-(void)setavAudio
{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"mapScene" ofType:@"mp3"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
//    _avAudioPlayer.delegate = self;
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.3];
}

@end
