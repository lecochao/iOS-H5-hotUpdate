//
//  NSObject+HUD.h
//  itour
//
//  Created by Chaos on 16/6/12.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface NSObject (HUD)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
@end
