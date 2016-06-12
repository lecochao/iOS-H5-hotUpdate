//
//  ItMapOptions.h
//  itour
//
//  Created by Chaos on 16/6/8.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItMapOptions : UIView
typedef void(^addCellIndex)(NSInteger n);
@property (strong,nonatomic) addCellIndex actionBlock;

+(void)showMapOptions:(NSArray*)titles Add:(UIView *)view Action:(void (^)(NSInteger n))action;
@end
