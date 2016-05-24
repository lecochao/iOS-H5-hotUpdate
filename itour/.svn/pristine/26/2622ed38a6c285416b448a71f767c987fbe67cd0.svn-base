//
//  ItBaseViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItBaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ItBaseViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (copy, nonatomic) dispatch_block_t leftItemBlock;
@property (copy, nonatomic) dispatch_block_t rightItemBlock;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@end
@implementation ItBaseViewController

-(void)setView
{
    NSLog(@"___BaseviewDidLoad");
    _webView = [UIWebView new];
    _webView.frame = self.view.bounds;
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewDidLayoutSubviews
{
     _webView.frame = self.view.bounds;
}
-(void)popGestureRecognizer{
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void)setNavigationBarTintColor:(UIColor *)color
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarTintColor:color];
}

-(void)setNavigationBarLeftItem:(id)item Action:(dispatch_block_t)leftBlock
{
    UIButton *btn;
    if ([item isKindOfClass:[UIButton class]]) {
        btn = item;
    }else if ([item isKindOfClass:[NSString class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        [btn setTitle:item forState:UIControlStateNormal];
    }else if ([item isKindOfClass:[UIImage class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        
        [btn setImage:item forState:UIControlStateNormal];
    }else NSLog(@"___nav bar left item 类型未被识别");
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [self barItemWithCustomView:btn];
    _leftItemBlock = leftBlock;
}

-(void)setNavigationBarRightItem:(id)item Action:(dispatch_block_t)rightBlock
{
    UIButton *btn;
    
    if ([item isKindOfClass:[UIButton class]]) {
        btn = item;
    }else if ([item isKindOfClass:[NSString class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        [btn setTitle:item forState:UIControlStateNormal];
    }else if ([item isKindOfClass:[UIImage class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        [btn setImage:item forState:UIControlStateNormal];
    }else NSLog(@"___nav bar right item 类型未被识别");
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [self barItemWithCustomView:btn];
    _rightItemBlock = rightBlock;
}

- (void)loadingWebWithUrl:(NSURL *)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadingHtmlWithName:(NSString *)fileName
{
    NSError *error;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    NSString *filePath = [resPath stringByAppendingPathComponent:fileName];
    [_webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error]
                    baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
    
    if (error) {
        NSLog(@"__%@ 加载失败 - %@",fileName,error.domain);
    }
}
- (UIBarButtonItem *)barItemWithCustomView:(id)custom{
    return [[UIBarButtonItem alloc]initWithCustomView:(UIView *)custom];
}

-(void)leftAction
{
    if (_leftItemBlock) {
        _leftItemBlock();
    }
}

-(void)rightAction
{
    if (_rightItemBlock) {
        _rightItemBlock();
    }
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (progress > 0.90) {
        //需要注册JS
        [self setWebJS];
    }
}


-(void)setWebJS
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"plus"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        
//        JSValue *jsVal = [args firstObject];
//        if ([[jsVal toString] isEqualToString:@"2"]) {
//            NSLog(@"分享");
//            
//            NSString *imgUrl = [args[1] toString];
//            NSString *title = [args[2] toString];
//            NSString *content = [args[3] toString];
//            NSString *shareUrl = [args[4] toString];
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self JSWithData:args];
            //...
        });
    };
    //0 类型 1 imgUrl 2title 3 content 4shareUrl
    //    iosbridge("1","loupan");
}

@end
