//
//  ItBaseViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItBaseViewController.h"
#import "ItCommonViewController.h"
#import "AMapLocationKit/AMapLocationKit.h"
#import "MJRefresh.h"
#import "ItMapOptions.h"
#import "ItPostInfoViewController.h"


@interface ItBaseViewController ()<UIWebViewDelegate>
@property (assign,nonatomic) UIStatusBarStyle statusBarStyle;
@property (copy, nonatomic) dispatch_block_t leftItemBlock;
@property (copy, nonatomic) dispatch_block_t rightItemBlock;
@property (strong,nonatomic) JSContext *context;
@property (strong,nonatomic) UIButton *rightItem2;/**< webView canGoBack 关闭按钮*/
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end
@implementation ItBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return _statusBarStyle;
    
}
-(void)setView
{
    NSLog(@"___BaseviewDidLoad");
    _webView = [UIWebView new];
    _webView.scrollView.bounces = NO;//关闭反弹
    _webView.scrollView.bouncesZoom = NO;//关闭缩放
    _webView.frame = self.view.bounds;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    

    [self setWebJS];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webViewReload) name:@"webViewReload" object:nil];
    [self popGestureRecognizer];
}

-(void)viewDidLayoutSubviews
{
     _webView.frame = self.view.bounds;;
}
-(void)popGestureRecognizer{
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void)setHeaderWithRefresh:(BOOL)on_off
{
    if (on_off) {
        _webView.scrollView.bounces = YES;//关闭反弹
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self setWebJS];
            [self.webView reload];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_webView.scrollView.mj_header endRefreshing]; 
            });
        }];

    }
}
-(void)setNavigationBarStyle:(iTourNavigationBarStyle)style
{
    
    if (style == iTourNavigationBarStyleDefault) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [_rightItem2 setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _statusBarStyle = UIStatusBarStyleDefault;
    }else if (style == iTourNavigationBarStyleRed){
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController.navigationBar setBarTintColor:APPColorRed];
        [_rightItem2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statusBarStyle = UIStatusBarStyleLightContent;
    }else if (style == iTourNavigationBarStyleColourless){
        self.navigationController.navigationBar.translucent = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [_rightItem2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)setNavigationBarLeftItem:(id)item Action:(dispatch_block_t)leftBlock
{
    UIButton *btn;
    if ([item isKindOfClass:[UIButton class]]) {
        btn = item;
    }else if ([item isKindOfClass:[NSString class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        [btn.titleLabel setFont:APPTextFont(14)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitle:item forState:UIControlStateNormal];
    }else if ([item isKindOfClass:[UIImage class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 30, 35);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImage:item forState:UIControlStateNormal];
    }else NSLog(@"___nav bar left item 类型未被识别");
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _rightItem2 = [UIButton new];
    _rightItem2.frame = CGRectMake(0, 0, 40, 35);
    [_rightItem2.titleLabel setFont:APPTextFont(14)];
    [_rightItem2 setTitle:@"关闭" forState:UIControlStateNormal];
    _rightItem2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_rightItem2 addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [_rightItem2 setHidden:YES];
    self.navigationItem.leftBarButtonItems = @[[self barItemWithCustomView:btn],[self barItemWithCustomView:_rightItem2]];
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
        [btn.titleLabel setFont:APPTextFont(14)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setTitle:item forState:UIControlStateNormal];
    }else if ([item isKindOfClass:[UIImage class]]){
        btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 35);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setImage:item forState:UIControlStateNormal];
    }else NSLog(@"___nav bar right item 类型未被识别");
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [self barItemWithCustomView:btn];
    _rightItemBlock = rightBlock;
}

- (void)loadingWebWithUrl:(NSString *)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)loadingHtmlWithName:(NSString *)fileName
{
//    查找document／html5 文件下是否存在该文件
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *resPath = [NSString stringWithFormat:@"%@/%@",document,HTML5Source];
    NSString *filePath = [resPath stringByAppendingPathComponent:fileName];
    [self loadingWebWithUrl:filePath];
//    NSError *fileError;
//    NSString *file = [NSString stringWithContentsOfFile:filePath encoding: NSUTF8StringEncoding error:&fileError];
//    if (file&&!fileError) {
//        [_webView loadHTMLString:file
//                         baseURL:[NSURL fileURLWithPath:resPath]];
//    }

    
}
- (UIBarButtonItem *)barItemWithCustomView:(id)custom{
    return [[UIBarButtonItem alloc]initWithCustomView:(UIView *)custom];
}

-(void)leftAction
{
    if ([_webView canGoBack]) {
        [_rightItem2 setHidden:NO];
    }else [_rightItem2 setHidden:YES];
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


//#pragma mark - NJKWebViewProgressDelegate
//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [_progressView setProgress:progress animated:YES];
//    self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSLog(@"progress___%f",progress);
//}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_webView.scrollView.mj_header endRefreshing];
    [self setWebJS];
    if ([webView canGoBack]) {
        [_rightItem2 setHidden:NO];
    }else [_rightItem2 setHidden:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_webView.scrollView.mj_header endRefreshing];
    NSLog(@"__webLoadError%@",error.userInfo);
}
-(void)setWebJS
{
    WEAKSELF
    _context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"plus"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        
//        JSValue *jsVal = [args firstObject];
//        if ([[jsVal toString] isEqualToString:@"2"]) {
//            NSLog(@"分享");
//
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf JSWithData:args];
            //...
        });
    };

    _context[@"getSessionId"] = ^{ return [weakSelf returnSessionId];};
    _context[@"alter"] = ^{
        NSArray *args = [JSContext currentArguments];
        [weakSelf showHint:[[args firstObject] toString]];
    };
}

-(void)JSWithData:(NSArray<JSValue *> *)data
{
    if (data) {
        NSLog(@"___JS___%@",data);
        if ([[[data firstObject] toString]isEqualToString:@"openMessage"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItPostImgStoryboard" bundle:nil];
            ItPostInfoViewController *postInfoController = [storyboard instantiateViewControllerWithIdentifier:@"PostInfoViewControllerIdentifier"];
            postInfoController.type = @"message";
            postInfoController.navigationItem.title = @"谏言";
            [self.navigationController pushViewController:postInfoController animated:YES];
        }else if ([[[data firstObject] toString]isEqualToString:@"openView"]) {
            
            if (data.count>2) {
                NSMutableArray *titles = [NSMutableArray array];
                [data enumerateObjectsUsingBlock:^(JSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx>0) {
                        NSDictionary *dic = [self dictionaryWithJsonString:[obj toString]];
                        [titles addObject:dic[@"title"]];
                    }
                }];
                [ItMapOptions showMapOptions:titles Add:self.view Action:^(NSInteger n) {
                    NSDictionary *dic = [self dictionaryWithJsonString:[data[n+1] toString]];
                    ItCommonViewController *sceneDetail = [[ItCommonViewController alloc]init];
                    sceneDetail.txtTitle = dic[@"title"];
                    sceneDetail.style = [dic[@"navbar"] intValue];
                    sceneDetail.url = dic[@"url"];
                    sceneDetail.isLeaf = [dic[@"isLeaf"] isEqualToString:@"1"]? YES:NO;
                    sceneDetail.type = dic[@"type"];
                    [self.navigationController pushViewController:sceneDetail animated:YES];
                    
                }];
            }else {
                NSDictionary *dic = [self dictionaryWithJsonString:[data[1] toString]];
                NSString *dispatch = dic[@"dispatch"];
                if (dispatch) {
                    //{"id":"1","dispatch":"reply-scene","navbar":0,"title":"发表评论"}
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItPostImgStoryboard" bundle:nil];
                    ItPostInfoViewController *postInfoController = [storyboard instantiateViewControllerWithIdentifier:@"PostInfoViewControllerIdentifier"];
                    postInfoController.dispatch = dic[@"dispatch" ];
                    postInfoController.assoId = dic[@"id"];
                    postInfoController.navigationItem.title = dic[@"title"];
                    [self.navigationController pushViewController:postInfoController animated:YES];
                }else{
                    ItCommonViewController *sceneDetail = [[ItCommonViewController alloc]init];
                    sceneDetail.txtTitle = dic[@"title"];
                    sceneDetail.style = [dic[@"navbar"] intValue];
                    sceneDetail.url = dic[@"url"];
                    sceneDetail.isLeaf = [dic[@"isLeaf"] isEqualToString:@"1"]? YES:NO;
                    sceneDetail.type = dic[@"type"];
                    [self.navigationController pushViewController:sceneDetail animated:YES];
                }
            }
            
            
        }else if ([[[data firstObject] toString]isEqualToString:@"getPlan"]){
            //定位
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
            hud.labelText = @"定位中...";
            _locationManager = [[AMapLocationManager alloc] init];
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
            [_locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                [hud hide:YES];
                if (error) {
                    [self showHint:@"定位失败！"];
                    NSString *getPlan_js=[NSString stringWithFormat:@"getPlan('%@')",@""];
                    [_context evaluateScript:getPlan_js];
                    return;
                }else{
                    if (location) {
                        NSString *locatinString = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
                        NSString *getPlan_js=[NSString stringWithFormat:@"getPlan('%@')",locatinString];
                        [_context evaluateScript:getPlan_js];
                    }
                }
            }];
         
        }
    }
}
-(void)webViewReload{};
-(NSString *)returnSessionId
{
    return ITOUR_GET_OBJECT(UserToken);
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
