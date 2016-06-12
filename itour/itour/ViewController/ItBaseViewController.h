//
//  ItBaseViewController.h
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger, iTourNavigationBarStyle) {
    iTourNavigationBarStyleDefault = 0,
    iTourNavigationBarStyleRed,
    iTourNavigationBarStyleColourless
};
@interface ItBaseViewController : UIViewController
@property (strong ,nonatomic) UIWebView *webView;

-(void)setView;

/*!
 *  设置下拉刷新。默认 无刷新
 */
-(void)setHeaderWithRefresh:(BOOL)on_off;

/*!
 *  popviewcontroller 侧滑手势
 */
-(void)popGestureRecognizer;

/*!
 *  barde 颜色样式
 *  需要配合 preferredStatusBarStyle 方法改变状态栏的颜色
 *  @param style Basecontroller 默认为1 StyleRed
 */
-(void)setNavigationBarStyle:(iTourNavigationBarStyle)style;

/*!
 *  navigation 的左侧 按钮
 *
 *  @param item      UIButton、UIImage、NSString
 *  @param leftBlock action
 */
-(void)setNavigationBarLeftItem:(id)item Action:(dispatch_block_t)leftBlock;

/*!
 *  navigation 的右侧 按钮
 *
 *  @param item      UIButton、UIImage、NSString
 *  @param rightBlock action
 */
-(void)setNavigationBarRightItem:(id)item Action:(dispatch_block_t)rightBlock;

/*!
 *  加载远程web
 *
 *  @param url 地址
 */
- (void)loadingWebWithUrl:(NSString *)url;

/*!
 *  加载本地HTML
 *
 *  @param fileName 文件名 @"home.html"/[NSString stringWithFormat:@"home.html?test=%@",@"11111"]
 */
- (void)loadingHtmlWithName:(NSString *)fileName;

/*!
 *  子类必须重写的方法、JS 调用返回的数据
 *
 *  @param data jsValue 用toString类方法转换
 */
- (void)JSWithData:(NSArray<JSValue *>*)data;

/*!
 *  webview Reload
 */
- (void)webViewReload;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
