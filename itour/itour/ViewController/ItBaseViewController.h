//
//  ItBaseViewController.h
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface ItBaseViewController : UIViewController
@property (strong ,nonatomic) UIWebView *webView;

-(void)setView;
/*!
 *  popviewcontroller 侧滑手势
 */
-(void)popGestureRecognizer;

/*!
 *  设置navBar 的颜色
 *
 *  @param color color
 */
-(void)setNavigationBarTintColor:(UIColor *)color;

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
- (void)loadingWebWithUrl:(NSURL *)url;

/*!
 *  加载本地HTML
 *
 *  @param fileName 文件名 @"home.html"
 */
- (void)loadingHtmlWithName:(NSString *)fileName;
/*!
 *  子类必须重写的方法、JS 调用返回的数据
 *
 *  @param data jsValue 用toString类方法转换
 */
- (void)JSWithData:(NSArray<JSValue *>*)data;
@end
