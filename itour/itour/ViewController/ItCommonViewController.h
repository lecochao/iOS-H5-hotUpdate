//
//  ItCommonViewController.h
//  itour
//
//  Created by Chaos on 16/6/2.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItBaseViewController.h"

@interface ItCommonViewController : ItBaseViewController
@property(nonatomic ,assign)iTourNavigationBarStyle style;
@property(nonatomic ,assign) BOOL isLeaf;
@property(nonatomic ,strong) NSString *url;
@property(nonatomic ,strong) NSString *txtTitle;
@property(nonatomic ,strong) NSString *type;/**< board1美食，board2娱乐，board3景点，board4纪念品*/
@end
